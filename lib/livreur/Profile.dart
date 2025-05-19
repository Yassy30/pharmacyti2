import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Profile'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Pharmacy Logo and Info
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Pharmacy Logo
                Image.asset(
                  'images/liv.png',
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
                  children: [
                    Text(
                      'Amine Livreur',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'rider@gmail.com',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 246, 241, 241), // Lighter grey background matching the image
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          child: Icon(
            icon,
            color: isDestructive ? Colors.red : Colors.orange,
            size: 25,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? Colors.red : Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 17,
          ),
        ),
        trailing: Icon(Icons.chevron_right, size: 24, color: Colors.black),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        onTap: () {
          // Handle menu item tap
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title tapped')),
          );
        },
      ),
    );
  }
}
