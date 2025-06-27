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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  
  File? _imageFile;
  Uint8List? _webImage;
  String? _imageName;
  bool _hasChanges = false;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupChangeListeners();
  }

  void _initializeControllers() {
    fullNameController.text = widget.fullName;
    phoneController.text = widget.phoneNumber;
    addressController.text = widget.address;
  }

  void _setupChangeListeners() {
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
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          if (bytes.length > 5 * 1024 * 1024) {
            _showSnackBar('Image size must be less than 5MB', isError: true);
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
            _showSnackBar('Image size must be less than 5MB', isError: true);
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
    } catch (e) {
      _showSnackBar('Failed to pick image: $e', isError: true);
    }
  }

  Future<String?> _uploadImage(String userId) async {
    if (_imageFile == null && _webImage == null) return null;
    
    setState(() => _isUploading = true);
    
    final fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    
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
      _showSnackBar('Failed to upload image: $e', isError: true);
      return null;
    } finally {
      setState(() => _isUploading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: isError ? 4 : 2),
      ),
    );
  }

  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 2) {
      return 'Full name must be at least 2 characters';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    if (!userViewModel.isValidPhoneNumber(value)) {
      return 'Please enter a valid phone number (e.g., 0612345678)';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Address is required';
    }
    if (value.trim().length < 5) {
      return 'Address must be at least 5 characters';
    }
    return null;
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final userId = userViewModel.currentUserId;
    
    if (userId == null) {
      _showSnackBar('No authenticated user found', isError: true);
      return;
    }

    String? imageUrl = widget.imageProfile;
    if (_imageFile != null || _webImage != null) {
      imageUrl = await _uploadImage(userId);
      if (imageUrl == null) return; // Stop if image upload fails
    }

    final success = await userViewModel.updateUserDetails(
      fullName: fullNameController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      address: addressController.text.trim(),
      imageProfile: imageUrl,
    );

    if (success) {
      _showSnackBar('Profile updated successfully!');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Congratulations()),
      );
    } else {
      _showSnackBar(
        userViewModel.errorMessage ?? 'Failed to save profile',
        isError: true,
      );
    }
  }

  void _resetChanges() {
    setState(() {
      fullNameController.text = widget.fullName;
      phoneController.text = widget.phoneNumber;
      addressController.text = widget.address;
      _imageFile = null;
      _webImage = null;
      _imageName = null;
      _hasChanges = false;
    });
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;
    
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard Changes?'),
        content: const Text('You have unsaved changes. Are you sure you want to go back?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Consumer<UserViewModel>(
      builder: (context, userViewModel, child) {
        return WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () async {
                  if (await _onWillPop()) {
                    Navigator.pop(context);
                  }
                },
              ),
              title: const Text(
                'Edit Profile',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
              actions: [
                if (_hasChanges)
                  TextButton(
                    onPressed: _resetChanges,
                    child: const Text('Reset', style: TextStyle(color: Colors.red)),
                  ),
              ],
            ),
            body: SafeArea(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: _buildImageContainer()),
                      SizedBox(height: screenHeight * 0.03),
                      
                      _buildFormField(
                        label: 'Full Name',
                        controller: fullNameController,
                        validator: _validateFullName,
                        hint: 'Enter your full name',
                      ),
                      
                      SizedBox(height: screenHeight * 0.025),
                      
                      _buildFormField(
                        label: 'Email',
                        initialValue: widget.email,
                        isEnabled: false,
                        hint: 'Email cannot be changed',
                      ),
                      
                      SizedBox(height: screenHeight * 0.025),
                      
                      _buildFormField(
                        label: 'Phone Number',
                        controller: phoneController,
                        validator: _validatePhoneNumber,
                        hint: '0612345678',
                        keyboardType: TextInputType.phone,
                      ),
                      
                      SizedBox(height: screenHeight * 0.025),
                      
                      _buildFormField(
                        label: 'Address',
                        controller: addressController,
                        validator: _validateAddress,
                        hint: 'Enter your address',
                        maxLines: 2,
                      ),
                      
                      SizedBox(height: screenHeight * 0.04),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (userViewModel.isUpdating || _isUploading || !_hasChanges)
                              ? null
                              : _saveChanges,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff2299c3),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: (userViewModel.isUpdating || _isUploading)
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageContainer() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: _hasChanges ? Colors.blue.shade300 : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: ClipOval(
          child: Stack(
            children: [
              _getImageWidget(),
              if (_isUploading)
                Container(
                  color: Colors.black54,
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getImageWidget() {
    if (kIsWeb && _webImage != null) {
      return Image.memory(
        _webImage!,
        fit: BoxFit.cover,
        width: 120,
        height: 120,
        errorBuilder: (context, error, stackTrace) => _placeholderWidget(),
      );
    } else if (!kIsWeb && _imageFile != null) {
      return Image.file(
        _imageFile!,
        fit: BoxFit.cover,
        width: 120,
        height: 120,
        errorBuilder: (context, error, stackTrace) => _placeholderWidget(),
      );
    } else if (widget.imageProfile != null && widget.imageProfile!.isNotEmpty) {
      return Image.network(
        widget.imageProfile!,
        fit: BoxFit.cover,
        width: 120,
        height: 120,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 120,
            height: 120,
            color: Colors.grey[200],
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => _placeholderWidget(),
      );
    } else {
      return _placeholderWidget();
    }
  }

  Widget _placeholderWidget() {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    return Container(
      width: 120,
      height: 120,
      color: Colors.grey[200],
      child: Center(
        child: Text(
          userViewModel.getUserInitials(),
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    TextEditingController? controller,
    String? initialValue,
    String? Function(String?)? validator,
    String? hint,
    bool isEnabled = true,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          validator: validator,
          enabled: isEnabled,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: isEnabled ? Colors.grey[50] : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xff2299c3)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            suffixIcon: isEnabled ? const Icon(Icons.edit, size: 20) : null,
          ),
        ),
      ],
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