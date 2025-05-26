import 'package:flutter/material.dart';
// TODO: Create personal_info_page.dart file and uncomment this import
// import 'package:pharmacyti2/client/personal_info_page.dart';
import 'package:pharmaciyti/client/profil_info.dart';
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Profile Card (Larger) - Now navigates to PersonalInfoPage
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PersonalInfoPage()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.015,
                    ),
                    leading: CircleAvatar(
                      radius: screenWidth * 0.1,
                      backgroundImage: AssetImage('assets/images/client.png'),
                    ),
                    title: Text(
                      'Fatima Bichouarine',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.05,
                      ),
                    ),
                    subtitle: Text(
                      'Personal informations',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: screenWidth * 0.05,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ),
            // Settings List
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!, width: 1.5),
                ),
                child: Column(
                  children: [
                    _buildProfileOption(
                      icon: Icons.shopping_cart_outlined,
                      text: 'My Orders',
                      onTap: () {},
                    ),
                    _buildProfileOption(
                      icon: Icons.credit_card,
                      text: 'Payment Methods',
                      onTap: () {},
                    ),
                    _buildProfileOption(
                      icon: Icons.notifications_none,
                      text: 'Notifications Settings',
                      onTap: () {},
                    ),
                    _buildProfileOption(
                      icon: Icons.help_outline,
                      text: 'Help & Support',
                      onTap: () {},
                    ),
                    _buildProfileOption(
                      icon: Icons.lock_outline,
                      text: 'Privacy',
                      onTap: () {},
                    ),
                    _buildProfileOption(
                      icon: Icons.language,
                      text: 'Language',
                      onTap: () {},
                      showDivider: false,
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            // Logout Button
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.025,
              ),
              child: GestureDetector(
                onTap: () {
                  // Handle logout
                },
                child: Container(
                  width: double.infinity,
                  height: screenHeight * 0.06,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: Colors.red, size: screenWidth * 0.06),
                      SizedBox(width: screenWidth * 0.02),
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.045,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.grey[700], size: 24),
          title: Text(text, style: TextStyle(fontSize: 15)),
          trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey[400]),
          onTap: onTap,
        ),
        if (showDivider)
          Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
      ],
    );
  }
}