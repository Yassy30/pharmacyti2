import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pharmaciyti/features/auth/viewmodel/autho_viewmodel.dart';
import 'package:pharmaciyti/features/auth/viewmodel/user_viewmodel.dart';
import 'package:pharmaciyti/features/auth/view/login.dart';
import 'package:pharmaciyti/features/delivery/profile/view/ProfileInfos.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final userViewModel = Provider.of<UserViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context);

    // Fetch user details when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!userViewModel.isLoading && userViewModel.fullName == null) {
        userViewModel.fetchUserDetails();
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Delivery Profile'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: userViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Delivery Info
                Padding(
                  padding: EdgeInsets.all(16),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfileInfos()),
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
                          // Delivery Logo
                          userViewModel.imageProfile != null
                              ? Image.network(
                                  userViewModel.imageProfile!,
                                  width: 70,
                                  height: 70,
                                  errorBuilder: (context, error, stackTrace) => _buildFallbackAvatar(),
                                )
                              : _buildFallbackAvatar(),
                          SizedBox(width: 16),
                          // Delivery Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userViewModel.fullName ?? 'Amine Livreur',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  userViewModel.email ?? 'rider@gmail.com',
                                  style: TextStyle(fontSize: 14, color: Colors.grey),
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
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    children: [
                      _buildMenuItem(context, 'Privacy Policy', Icons.description_outlined),
                      _buildMenuItem(context, 'Terms & Conditions', Icons.description_outlined),
                      _buildMenuItem(context, 'Contact Us', Icons.contact_support_outlined),
                      _buildMenuItem(context, 'Delete Account', Icons.delete_outline, isDestructive: true),
                      _buildMenuItem(context, 'Logout', Icons.logout, isDestructive: true, onTap: () async {
                        await authViewModel.signOut();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const Login()),
                          (route) => false,
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildFallbackAvatar() {
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
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, {bool isDestructive = false, VoidCallback? onTap}) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 246, 241, 241),
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
        onTap: onTap ??
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$title tapped')),
              );
            },
      ),
    );
  }
}