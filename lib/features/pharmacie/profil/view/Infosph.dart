import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pharmaciyti/features/auth/viewmodel/user_viewmodel.dart';
import 'package:pharmaciyti/features/pharmacie/congratulation/congratsph.dart';

class Infosph extends StatefulWidget {
  const Infosph({Key? key}) : super(key: key);

  @override
  State<Infosph> createState() => _InfosphState();
}

class _InfosphState extends State<Infosph> {
  final TextEditingController pharmacyNameController = TextEditingController();
  final TextEditingController pharmacyAddressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  
  // For mobile
  File? _imageFile;
  // For web
  Uint8List? _webImage;
  String? _imageName;
  
  get userId_ => null;
   
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      userViewModel.fetchUserDetails().then((_) {
        if (userViewModel.fullName != null) {
          pharmacyNameController.text = userViewModel.fullName!;
        }
        if (userViewModel.address != null) {
          pharmacyAddressController.text = userViewModel.address!;
        }
        if (userViewModel.phoneNumber != null) {
          phoneController.text = userViewModel.phoneNumber!;
        }
      });
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        // For web platform
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
          _imageName = pickedFile.name;
          _imageFile = null; // Clear mobile file
        });
      } else {
        // For mobile platform
        setState(() {
          _imageFile = File(pickedFile.path);
          _webImage = null; // Clear web bytes
          _imageName = null;
        });
      }
    }
  }

  Future<String?> _uploadImage(String userId) async {
    if (_imageFile == null && _webImage == null) return null;
    
    final fileName = '$userId_${DateTime.now().millisecondsSinceEpoch}.jpg';
    try {
      if (kIsWeb && _webImage != null) {
        // Upload for web
        await Supabase.instance.client.storage
            .from('userprofil')
            .uploadBinary(fileName, _webImage!);
      } else if (_imageFile != null) {
        // Upload for mobile
        await Supabase.instance.client.storage
            .from('userprofil')
            .upload(fileName, _imageFile!);
      }
      
      return Supabase.instance.client.storage
          .from('userprofil')
          .getPublicUrl(fileName);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      }
      return null;
    }
  }

  Widget _buildImageContainer(String? existingImageUrl) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 180,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.green.shade200,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _getImageWidget(existingImageUrl),
      ),
    );
  }

  Widget _getImageWidget(String? existingImageUrl) {
    // Priority: New selected image > Existing image > Placeholder
    if (kIsWeb && _webImage != null) {
      // Show newly selected image on web
      return Image.memory(
        _webImage!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _placeholderWidget();
        },
      );
    } else if (!kIsWeb && _imageFile != null) {
      // Show newly selected image on mobile
      return Image.file(
        _imageFile!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _placeholderWidget();
        },
      );
    } else if (existingImageUrl != null && existingImageUrl.isNotEmpty) {
      // Show existing image from storage
      return Image.network(
        existingImageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / 
                    loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print('Error loading image: $error'); // Debug log
          return _placeholderWidget();
        },
      );
    } else {
      // Show placeholder
      return _placeholderWidget();
    }
  }

  Widget _placeholderWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.image_outlined,
          size: 48,
          color: Colors.grey.shade400,
        ),
        const SizedBox(height: 8),
        const Text(
          'Tap to select image (optional)',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, userViewModel, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Upload pharmacy logo",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: GestureDetector(
                      onTap: userViewModel.isLoading ? null : _pickImage,
                      child: _buildImageContainer(userViewModel.imageProfile),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Pharmacy name",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: pharmacyNameController,
                    decoration: InputDecoration(
                      hintText: "Enter Pharmacy name",
                      filled: true,
                      fillColor: const Color(0xfff2f2f2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Pharmacy Address",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: pharmacyAddressController,
                    decoration: InputDecoration(
                      hintText: "Enter Pharmacy Address",
                      filled: true,
                      fillColor: const Color(0xfff2f2f2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Phone number",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "Enter Phone Number",
                      filled: true,
                      fillColor: const Color(0xfff2f2f2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                  ElevatedButton(
                    onPressed: userViewModel.isLoading
                        ? null
                        : () async {
                            final pharmacyName = pharmacyNameController.text.trim();
                            final phone = phoneController.text.trim();
                            final pharmacyAddress = pharmacyAddressController.text.trim();

                            if (pharmacyName.isEmpty || phone.isEmpty || pharmacyAddress.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please fill all required fields')),
                              );
                              return;
                            }

                            final userId = Supabase.instance.client.auth.currentUser?.id;
                            if (userId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('No authenticated user found')),
                              );
                              return;
                            }

                            String? imageUrl = userViewModel.imageProfile;
                            if (_imageFile != null || _webImage != null) {
                              imageUrl = await _uploadImage(userId);
                            }
                            
                            final success = await userViewModel.updateUserDetails(
                              fullName: pharmacyName,
                              phoneNumber: phone,
                              address: pharmacyAddress,
                              imageProfile: imageUrl,
                            );
                            if (success) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const Congratsph()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(userViewModel.errorMessage ?? 'Failed to save profile')),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: userViewModel.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Submit",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}