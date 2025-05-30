import 'package:flutter/material.dart';

class ProfileInfos extends StatefulWidget {
  const ProfileInfos({Key? key}) : super(key: key);

  @override
  State<ProfileInfos> createState() => _ProfileInfosState();
}

class _ProfileInfosState extends State<ProfileInfos> {
  final TextEditingController nameController = TextEditingController(text: "Amine Livreur");
  final TextEditingController emailController = TextEditingController(text: "rider@gmail.com");
  final TextEditingController phoneController = TextEditingController(text: "0612345678");
  final TextEditingController addressController = TextEditingController(text: "123, Mohammed V Avenue");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Profile Information', style: TextStyle(color: Colors.black)),
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
                    child: Center(
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.blue.shade300,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
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
                ],
              ),
            ),
            SizedBox(height: 30),
            
            // Name Field
            _buildInfoField("Your name", nameController),
            SizedBox(height: 16),
            
            // Email Field
            _buildInfoField("Your email", emailController),
            SizedBox(height: 16),
            
            // Phone Field
            _buildInfoField("Phone number", phoneController),
            SizedBox(height: 16),
            
            // Address Field
            _buildInfoField("Adress", addressController),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoField(String label, TextEditingController controller) {
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
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              suffixIcon: Icon(Icons.edit, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
  
}