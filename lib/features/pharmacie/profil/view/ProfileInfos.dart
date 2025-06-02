import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pharmaciyti/features/auth/viewmodel/user_viewmodel.dart';
import 'package:pharmaciyti/features/pharmacie/congratulation/congratsph.dart';

class ProfileInfos extends StatefulWidget {
  const ProfileInfos({Key? key}) : super(key: key);

  @override
  State<ProfileInfos> createState() => _ProfileInfosState();
}

class _ProfileInfosState extends State<ProfileInfos> {
  late TextEditingController pharmacyNameController;
  late TextEditingController pharmacyAddressController;
  late TextEditingController phoneController;
  String? _imageProfile;

  @override
  void initState() {
    super.initState();
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    pharmacyNameController = TextEditingController(text: userViewModel.fullName);
    pharmacyAddressController = TextEditingController(text: userViewModel.address);
    phoneController = TextEditingController(text: userViewModel.phoneNumber);
    _imageProfile = userViewModel.imageProfile;

    // Fetch user details if not already loaded
    if (userViewModel.fullName == null) {
      userViewModel.fetchUserDetails();
    }
  }

  @override
  void dispose() {
    pharmacyNameController.dispose();
    pharmacyAddressController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Pharmacy Information', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            // Profile Image
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.lightBlue.shade100,
                    ),
                    child: _imageProfile != null
                        ? Image.network(
                            _imageProfile!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.blue.shade300,
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.blue.shade300,
                          ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Implement image picker logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Image upload not implemented')),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            // Pharmacy Name Field
            _buildInfoField("Pharmacy name", pharmacyNameController),
            SizedBox(height: 16),
            // Email Field
            _buildInfoField("Email", TextEditingController(text: userViewModel.email ?? ''), enabled: false),
            SizedBox(height: 16),
            // Phone Field
            _buildInfoField("Phone number", phoneController),
            SizedBox(height: 16),
            // Address Field
            _buildInfoField("Address", pharmacyAddressController),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: userViewModel.isLoading
                  ? null
                  : () async {
                      final success = await userViewModel.updateUserDetails(
                        fullName: pharmacyNameController.text.trim(),
                        phoneNumber: phoneController.text.trim(),
                        address: pharmacyAddressController.text.trim(),
                      );
                      if (success) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Congratsph()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(userViewModel.errorMessage ?? 'Failed to update profile')),
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
                      'Submit',
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
    );
  }

  Widget _buildInfoField(String label, TextEditingController controller, {bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            enabled: enabled,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              suffixIcon: enabled ? Icon(Icons.edit, color: Colors.black) : null,
            ),
          ),
        ),
      ],
    );
  }
}