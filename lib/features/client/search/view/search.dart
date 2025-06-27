import 'package:flutter/material.dart';
import 'package:pharmaciyti/features/client/cart/viewmodel/cart_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pharmaciyti/features/client/search/viewmodel/search_viewmodel.dart';
import 'package:pharmaciyti/features/pharmacie/inventory/data/models/medicine.dart';

class SearchPage extends StatefulWidget {
  final String initialQuery;
  const SearchPage({Key? key, this.initialQuery = ''}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _controller;
  List<CameraDescription> cameras = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SearchViewModel>(context, listen: false)
          .updateSearchQuery(widget.initialQuery);
      _initializeCamera();
    });
  }

  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No cameras available')),
          );
        }
      }
    } catch (e, stackTrace) {
      print('Error initializing camera: $e\nStack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to initialize camera')),
        );
      }
    }
  }

  Future<bool> _checkCameraPermission() async {
    try {
      final status = await Permission.camera.status;
      if (status.isDenied) {
        final result = await Permission.camera.request();
        if (!result.isGranted) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Camera permission denied')),
            );
          }
          return false;
        }
      } else if (status.isPermanentlyDenied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Camera permission permanently denied. Please enable in settings.')),
          );
          await openAppSettings();
        }
        return false;
      }
      return true;
    } catch (e, stackTrace) {
      print('Error checking camera permission: $e\nStack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error checking camera permission')),
        );
      }
      return false;
    }
  }

  Future<void> _scanPrescription() async {
    if (!await _checkCameraPermission()) return;
    if (cameras.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No camera available')),
        );
      }
      return;
    }

    // Get the viewModel reference before navigation
    final viewModel = Provider.of<SearchViewModel>(context, listen: false);
    final currentContext = context; // Store context reference

    final cameraController = CameraController(cameras[0], ResolutionPreset.low);
    try {
      await cameraController.initialize();
      if (!mounted) return;

      final result = await Navigator.push<XFile?>(
        context,
        MaterialPageRoute(
          builder: (context) => CameraScreen(
            cameraController: cameraController,
          ),
        ),
      );

      // Handle the result after navigation
      if (result != null) {
        await _handlePrescriptionImage(result, viewModel, currentContext);
      }

      // Dispose controller after navigation
      await Future.delayed(Duration(milliseconds: 200));
      await cameraController.dispose();
    } catch (e, stackTrace) {
      print('Error opening camera: $e\nStack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening camera')),
        );
      }
      await cameraController.dispose();
    }
  }

 Future<void> _handlePrescriptionImage(XFile image, SearchViewModel viewModel, BuildContext originalContext) async {
  print('Picture taken: ${image.path}');
  
  try {
    final imageFile = File(image.path);
    
    // Upload the prescription image without requiring a pharmacy ID initially
    final imageData = await viewModel.uploadPrescriptionImage(imageFile);
    if (imageData != null) {
      // Add to cart with the uploaded image URL
      final cartViewModel = Provider.of<CartViewModel>(originalContext, listen: false);
      cartViewModel.addPrescription(
        imageData['image_url'],
        prescriptionId: imageData['id'],
        // No pharmacyId needed here; will be assigned during checkout
      );

      if (mounted) {
        ScaffoldMessenger.of(originalContext).showSnackBar(
          SnackBar(
            content: Text('Prescription added to cart!'),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(originalContext).showSnackBar(
          SnackBar(content: Text('Failed to upload prescription image')),
        );
      }
    }
  } catch (e, stackTrace) {
    print('Error in prescription upload flow: $e Stack trace: $stackTrace');
    if (mounted) {
      ScaffoldMessenger.of(originalContext).showSnackBar(
        SnackBar(content: Text('Error uploading prescription')),
      );
    }
  }
}

  Future<String?> _selectPharmacy(SearchViewModel viewModel) async {
    final pharmacies = await viewModel.fetchPharmacies();
    if (pharmacies.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No pharmacies available')),
        );
      }
      return null;
    }

    if (!mounted) return null;

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Pharmacy'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: pharmacies.map((pharmacy) {
              return ListTile(
                title: Text(pharmacy.name),
                subtitle: Text(pharmacy.address ?? 'No address'),
                trailing: pharmacy.rating != null && pharmacy.rating! > 0
                    ? Text('Rating: ${pharmacy.rating!.toStringAsFixed(1)}')
                    : null,
                onTap: () => Navigator.pop(context, pharmacy.id),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final viewModel = Provider.of<SearchViewModel>(context);
    final cartViewModel = Provider.of<CartViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey, size: screenWidth * 0.06),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onChanged: (value) {
                          viewModel.updateSearchQuery(value);
                        },
                        onSubmitted: (value) {
                          viewModel.updateSearchQuery(value);
                        },
                        decoration: InputDecoration(
                          hintText: 'Search for medicines, pharmacies...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey, fontSize: screenWidth * 0.037),
                        ),
                        style: TextStyle(fontSize: screenWidth * 0.045),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.document_scanner_outlined, color: Colors.grey, size: screenWidth * 0.06),
                      onPressed: _scanPrescription,
                    ),
                    IconButton(
                      icon: Icon(Icons.bug_report, color: Colors.grey, size: screenWidth * 0.06),
                      onPressed: () {
                        final user = Supabase.instance.client.auth.currentUser;
                        print('Authenticated user: ${user?.id}');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('User: ${user?.id ?? "Not logged in"}')),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.filter_list, color: Colors.grey, size: screenWidth * 0.06),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Advanced filter options not implemented yet')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterButton("Prescription", screenWidth, viewModel),
                    SizedBox(width: screenWidth * 0.025),
                    _buildFilterButton("Distance", screenWidth, viewModel),
                    SizedBox(width: screenWidth * 0.025),
                    _buildFilterButton("Price", screenWidth, viewModel),
                    SizedBox(width: screenWidth * 0.025),
                    _buildFilterButton("Rating", screenWidth, viewModel),
                  ],
                ),
              ),
            ),
            Expanded(
              child: viewModel.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : viewModel.errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                viewModel.errorMessage!,
                                style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.red),
                              ),
                              TextButton(
                                onPressed: () => viewModel.fetchMedicines(),
                                child: Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : viewModel.medicines.isEmpty
                          ? _buildNoResultsFound(screenWidth, screenHeight, viewModel.searchQuery, viewModel.filter)
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                              itemCount: viewModel.medicines.length,
                              itemBuilder: (context, index) {
                                final medicine = viewModel.medicines[index];
                                return _buildMedicineItem(medicine, screenWidth, screenHeight, cartViewModel);
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label, double screenWidth, SearchViewModel viewModel) {
    bool isSelected = viewModel.filter == label;
    return GestureDetector(
      onTap: () {
        viewModel.updateFilter(isSelected ? null : label);
      },
      child: Container(
        height: screenWidth * 0.12,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.white,
          border: Border.all(
              color: isSelected ? Colors.blue[700]! : Colors.grey[300]!, width: 1.5),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: isSelected ? Colors.blue[700] : Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: screenWidth * 0.015),
            Icon(
              Icons.keyboard_arrow_down,
              size: screenWidth * 0.055,
              color: isSelected ? Colors.blue[700] : Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsFound(double screenWidth, double screenHeight, String searchQuery, String? filter) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: screenWidth * 0.5,
            height: screenHeight * 0.3,
            child: Image.asset('assets/images/notFound.png'),
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            searchQuery.isNotEmpty || filter != null
                ? 'No medicine found for "${searchQuery.isNotEmpty ? searchQuery : filter}".'
                : 'Enter a search term or select a filter',
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            'Try checking the spelling or filters.',
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicineItem(Medicine medicine, double screenWidth, double screenHeight, CartViewModel cartViewModel) {
    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: screenWidth * 0.2,
            height: screenWidth * 0.2,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: medicine.image != null
                ? Image.network(
                    medicine.image!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.medication,
                      size: screenWidth * 0.1,
                      color: Colors.grey[600],
                    ),
                  )
                : Icon(
                    Icons.medication,
                    size: screenWidth * 0.1,
                    color: Colors.grey[600],
                  ),
          ),
          SizedBox(width: screenWidth * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicine.name,
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  '\$${medicine.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                if (medicine.statusPrescription)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02,
                      vertical: screenHeight * 0.005,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Prescription Required',
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  'In stock: ${medicine.quantity}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.add_shopping_cart, color: Colors.blue[700], size: screenWidth * 0.07),
            onPressed: () {
              cartViewModel.addToCart(medicine);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Added ${medicine.name} to cart')),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CameraScreen extends StatefulWidget {
  final CameraController cameraController;
  const CameraScreen({Key? key, required this.cameraController}) : super(key: key);
  
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  bool _isTakingPicture = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      await widget.cameraController.initialize();
      if (!mounted) return;
      setState(() {
        _isInitialized = true;
      });
    } catch (e, stackTrace) {
      print('Error initializing camera: $e\nStack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to initialize camera')),
        );
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      if (_isInitialized && !widget.cameraController.value.isTakingPicture) {
        widget.cameraController.stopImageStream();
      }
    } else if (state == AppLifecycleState.resumed && _isInitialized) {
      _initializeCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || !widget.cameraController.value.isInitialized) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(widget.cameraController),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: _isTakingPicture
                    ? null
                    : () async {
                        setState(() {
                          _isTakingPicture = true;
                        });
                        try {
                          final image = await widget.cameraController.takePicture();
                          if (mounted) {
                            Navigator.pop(context, image);
                          }
                        } catch (e, stackTrace) {
                          print('Error taking picture: $e\nStack trace: $stackTrace');
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error taking picture')),
                            );
                          }
                        } finally {
                          if (mounted) {
                            setState(() {
                              _isTakingPicture = false;
                            });
                          }
                        }
                      },
                child: Icon(Icons.camera_alt),
              ),
            ),
          ),
        ],
      ),
    );
  }
}