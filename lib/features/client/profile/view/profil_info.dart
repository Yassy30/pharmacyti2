import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pharmaciyti/features/auth/viewmodel/user_viewmodel.dart';
import 'package:pharmaciyti/features/client/congratulation/congratulations.dart';

class PersonalInfoPage extends StatefulWidget {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;
  final String? imageProfile;

  const PersonalInfoPage({
    Key? key,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    this.imageProfile,
  }) : super(key: key);

  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  Uint8List? _webImage;
  String? _imageName;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    fullNameController.text = widget.fullName;
    phoneController.text = widget.phoneNumber;
    addressController.text = widget.address;

    // Listen for changes to detect if the user has modified any fields
    fullNameController.addListener(_checkForChanges);
    phoneController.addListener(_checkForChanges);
    addressController.addListener(_checkForChanges);
  }

  void _checkForChanges() {
    setState(() {
      _hasChanges = fullNameController.text.trim() != widget.fullName ||
          phoneController.text.trim() != widget.phoneNumber ||
          addressController.text.trim() != widget.address ||
          _imageFile != null ||
          _webImage != null;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        if (bytes.length > 5 * 1024 * 1024) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image size must be less than 5MB')),
          );
          return;
        }
        setState(() {
          _webImage = bytes;
          _imageName = pickedFile.name;
          _imageFile = null;
          _hasChanges = true;
        });
      } else {
        final file = File(pickedFile.path);
        if (await file.length() > 5 * 1024 * 1024) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image size must be less than 5MB')),
          );
          return;
        }
        setState(() {
          _imageFile = file;
          _webImage = null;
          _imageName = null;
          _hasChanges = true;
        });
      }
    }
  }

  Future<String?> _uploadImage(String userId) async {
    if (_imageFile == null && _webImage == null) return null;
    final fileName = '$userId${DateTime.now().millisecondsSinceEpoch}.jpg';
    try {
      if (kIsWeb && _webImage != null) {
        await Supabase.instance.client.storage
            .from('userprofil')
            .uploadBinary(fileName, _webImage!);
      } else if (_imageFile != null) {
        await Supabase.instance.client.storage
            .from('userprofil')
            .upload(fileName, _imageFile!);
      }
      return Supabase.instance.client.storage
          .from('userprofil')
          .getPublicUrl(fileName);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
      return null;
    }
  }

  Widget _buildImageContainer(String? existingImageUrl) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 180,
        decoration: BoxDecoration(
          border: Border.all(
            color: _hasChanges ? Colors.blue.shade200 : Colors.green.shade200,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _getImageWidget(existingImageUrl),
        ),
      ),
    );
  }

  Widget _getImageWidget(String? existingImageUrl) {
    if (kIsWeb && _webImage != null) {
      return Image.memory(
        _webImage!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _placeholderWidget(),
      );
    } else if (!kIsWeb && _imageFile != null) {
      return Image.file(
        _imageFile!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _placeholderWidget(),
      );
    } else if (existingImageUrl != null && existingImageUrl.isNotEmpty) {
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
          if (kDebugMode) print('Error loading image: $error');
          return _placeholderWidget();
        },
      );
    } else {
      return _placeholderWidget();
    }
  }

  Widget _placeholderWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.image_outlined, size: 48, color: Colors.grey.shade400),
        const SizedBox(height: 8),
        const Text('Tap to select image (optional)', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Future<void> _saveChanges() async {
    final fullName = fullNameController.text.trim();
    final phone = phoneController.text.trim();
    final address = addressController.text.trim();
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    if (fullName.isEmpty || phone.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    // Phone number validation (Moroccan format: starts with '06', 10 digits)
    if (!phone.startsWith('06') || phone.length != 10 || !RegExp(r'^\d+$').hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number (e.g., 0612345678)')),
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

    String? imageUrl = widget.imageProfile;
    if (_imageFile != null || _webImage != null) {
      imageUrl = await _uploadImage(userId);
      if (imageUrl == null) return; // Stop if image upload fails
    }

    final success = await userViewModel.updateUserDetails(
      fullName: fullName,
      phoneNumber: phone,
      address: address,
      imageProfile: imageUrl,
    );

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Congratulations()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(userViewModel.errorMessage ?? 'Failed to save profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      if (_hasChanges) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Discard Changes?'),
                            content: const Text('You have unsaved changes. Are you sure you want to go back?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: const Text('Discard', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  if (_hasChanges)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          fullNameController.text = widget.fullName;
                          phoneController.text = widget.phoneNumber;
                          addressController.text = widget.address;
                          _imageFile = null;
                          _webImage = null;
                          _imageName = null;
                          _hasChanges = false;
                        });
                      },
                      child: const Text('Cancel', style: TextStyle(color: Colors.red)),
                    ),
                ],
              ),
              SizedBox(height: screenHeight * 0.01),
              Center(child: _buildImageContainer(widget.imageProfile)),
              SizedBox(height: screenHeight * 0.03),
              _buildLabel('Your name', screenWidth),
              _buildInfoField(widget.fullName, fullNameController, context),
              SizedBox(height: screenHeight * 0.025),
              _buildLabel('Your Email', screenWidth),
              _buildInfoField(widget.email, null, context, isEditable: false),
              SizedBox(height: screenHeight * 0.025),
              _buildLabel('Phone number', screenWidth),
              _buildInfoField(widget.phoneNumber, phoneController, context, hint: '0612345678'),
              SizedBox(height: screenHeight * 0.025),
              _buildLabel('Address', screenWidth),
              _buildInfoField(widget.address, addressController, context),
              SizedBox(height: screenHeight * 0.04),
              ElevatedButton(
                onPressed: userViewModel.isLoading || !_hasChanges
                    ? null
                    : () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Save Changes'),
                            content: const Text('Are you sure you want to save your profile changes?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _saveChanges();
                                },
                                child: const Text('Save', style: TextStyle(color: Colors.blue)),
                              ),
                            ],
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2299c3),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: userViewModel.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Save Changes',
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
  }

  Widget _buildLabel(String label, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(left: screenWidth * 0.01, bottom: screenWidth * 0.01),
      child: Text(
        label,
        style: TextStyle(
          fontSize: screenWidth * 0.042,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildInfoField(String value, TextEditingController? controller, BuildContext context,
      {String? hint, bool isEditable = true}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.018,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: controller != null && controller.text != value ? Colors.blue.shade200 : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: isEditable
                ? TextField(
                    controller: controller?..text = value,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hint ?? value,
                      hintStyle: TextStyle(color: Colors.grey[600]),
                    ),
                    style: TextStyle(
                      fontSize: screenWidth * 0.042,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                : Text(
                    value,
                    style: TextStyle(
                      fontSize: screenWidth * 0.042,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
          ),
          if (isEditable)
            Icon(Icons.edit, color: Colors.black, size: screenWidth * 0.055),
        ],
      ),
    );
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }
}