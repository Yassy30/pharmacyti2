import 'package:flutter/material.dart';
import 'package:pharmaciyti/core/constants/colors.dart';
import 'package:pharmaciyti/features/auth/view/login.dart';
import 'package:pharmaciyti/features/delivery/profile/view/ProfileInfos.dart';


class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: screenWidth * 0.06),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profile',
          style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: AppColors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Pharmacy Logo and Info
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileInfos()),
                );
              },
              child: Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    // Pharmacy Logo
                    Image.asset(
                      'images/pharmacy_logo.png',
                      width: screenWidth * 0.18,
                      height: screenWidth * 0.18,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: screenWidth * 0.18,
                          height: screenWidth * 0.18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue.shade100,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                left: screenWidth * 0.025,
                                top: screenHeight * 0.02,
                                child: Icon(
                                  Icons.person,
                                  color: AppColors.primaryGreen,
                                  size: screenWidth * 0.075,
                                ),
                              ),
                              Positioned(
                                right: screenWidth * 0.025,
                                bottom: screenHeight * 0.02,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primaryGreen,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: AppColors.white,
                                    size: screenWidth * 0.05,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: screenWidth * 0.025,
                                top: screenHeight * 0.02,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue,
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: AppColors.white,
                                    size: screenWidth * 0.05,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    // Pharmacy Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Healthy Pharmacy',
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.005),
                          Text(
                            'healthypharma@gmail.com',
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: AppColors.textGrey),
                  ],
                ),
              ),
            ),
          ),
          // Menu Items
          Expanded(
            child: ListView(
               children:[
              _buildMenuItem(context, 'Privacy Policy', Icons.description_outlined),
              _buildMenuItem(context, 'Terms & Conditions', Icons.description_outlined),
              _buildMenuItem(context, 'Contact Us', Icons.contact_support_outlined),
              _buildMenuItem(context, 'Delete Account', Icons.delete_outline, isDestructive: true),
              _buildMenuItem(context, 'Logout', Icons.logout, isDestructive: true),
            ],
          ),
           
            ),
          ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, {bool isDestructive = false}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.01),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(screenWidth * 0.02),
          child: Icon(
            icon,
            color: isDestructive ? Colors.red : AppColors.primaryGreen,
            size: screenWidth * 0.06,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? Colors.red : Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: screenWidth * 0.042,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          size: screenWidth * 0.06,
          color: AppColors.textGrey,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.005,
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title tapped')),
          );
          if (title == 'Logout') {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
              (route) => false,
            );
          }
        },
      ),
    );
  }
}