import 'package:flutter/material.dart';
import 'package:pharmaciyti/auth/login.dart';
import 'package:pharmaciyti/pharmacie/ProfileInfos.dart';

class Profile extends StatelessWidget {
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
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Pharmacy Logo and Info
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              children: [
                // Pharmacy Logo
                Image.asset(
                  'pharmacy_logo.png',
                  width: screenWidth * 0.18,
                  height: screenWidth * 0.18,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback if image is not found
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
                            child: Icon(Icons.person, color: Colors.green, size: screenWidth * 0.075),
                          ),
                          Positioned(
                            right: screenWidth * 0.025,
                            bottom: screenHeight * 0.02,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                              child: Icon(Icons.check, color: Colors.white, size: screenWidth * 0.05),
                            ),
                          ),
                          Positioned(
                            right: screenWidth * 0.025,
                            top: screenHeight * 0.02,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                              ),
                              child: Icon(Icons.add, color: Colors.white, size: screenWidth * 0.05),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                // Pharmacy Info Column
                Column(
                  children: [
                    Text(
                      'Amine Livreur',
                      style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    Text(
                      'rider@gmail.com',
                      style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.grey),
                    ),
            padding: EdgeInsets.all(16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileInfos()),
                );
              },
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Pharmacy Logo
                          Image.asset(
                            'images/pharmacy_logo.png',
                            width: 70,
                            height: 70,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback if image is not found
                              return Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue.shade100,
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Positioned(
                                      left: 10,
                                      top: 15,
                                      child: Icon(Icons.person, color: Colors.green, size: 30),
                                    ),
                                    Positioned(
                                      right: 10,
                                      bottom: 15,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.green,
                                        ),
                                        child: Icon(Icons.check, color: Colors.white, size: 20),
                                      ),
                                    ),
                                    Positioned(
                                      right: 10,
                                      top: 15,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.blue,
                                        ),
                                        child: Icon(Icons.add, color: Colors.white, size: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 16),
                          // Pharmacy Info Column
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Healthy pharmacie',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'healthypharma@gmail.com',
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ),
          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.01),
              children: [
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

    // Determine icon color based on title
    Color iconColor;
    if (isDestructive) {
      iconColor = Colors.red;
    } else if (title == 'Privacy Policy' || title == 'Terms & Conditions' || title == 'Contact Us') {
      iconColor = Colors.green; // Set to green for Privacy, Terms, and Contact
    } else {
      iconColor = Colors.orange;
    }

    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.01),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 246, 241, 241), // Lighter grey background
        color: const Color.fromARGB(255, 246, 241, 241),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
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
            color: iconColor,
            size: screenWidth * 0.06,
            color: isDestructive ? Colors.red : Colors.green,
            size: 25,
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
        trailing: Icon(Icons.chevron_right, size: screenWidth * 0.06, color: Colors.black),
        contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.005),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title tapped')),
          );
          if (title == 'Logout') {
            // Navigate to login page and remove all previous routes
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Login(),
              ),
            );
          } else {
            // Handle other menu items
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$title tapped')),
            );
          }
        },
      ),
    );
  }
}
