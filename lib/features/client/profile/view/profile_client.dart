// lib/features/client/profile/view/profile_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pharmaciyti/features/auth/viewmodel/autho_viewmodel.dart';
import 'package:pharmaciyti/features/auth/viewmodel/user_viewmodel.dart';
import 'package:pharmaciyti/features/auth/view/login.dart';
import 'package:pharmaciyti/features/client/profile/view/profil_info.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final userViewModel = Provider.of<UserViewModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Fetch user details when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!userViewModel.isLoading && userViewModel.fullName == null) {
        userViewModel.fetchUserDetails();
      }
    });

    return FutureBuilder<String?>(
      future: authViewModel.getUserRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData && snapshot.data == 'client') {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: userViewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        // Profile Card
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenHeight * 0.02,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PersonalInfoPage(
                                    fullName: userViewModel.fullName ?? 'Unknown User',
                                    email: userViewModel.email ?? 'No Email',
                                    phoneNumber: userViewModel.phoneNumber ?? 'No Phone',
                                    address: userViewModel.address ?? 'No Address',
                                    imageProfile: userViewModel.imageProfile,
                                  ),
                                ),
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
                                  backgroundImage: userViewModel.imageProfile != null
                                      ? NetworkImage(userViewModel.imageProfile!)
                                      : const AssetImage('assets/images/client.png')
                                          as ImageProvider,
                                  onBackgroundImageError: (error, stackTrace) {
                                    print('Error loading profile image: $error');
                                  },
                                ),
                                title: Text(
                                  userViewModel.fullName ?? 'Unknown User',
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
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Logout'),
                                  content: const Text('Are you sure you want to log out?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await authViewModel.signOut();
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(builder: (context) => const Login()),
                                          (route) => false,
                                        );
                                      },
                                      child: const Text('Logout', style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
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
        } else {
          return Scaffold(
            body: Center(
              child: Text(
                'Access restricted to clients only',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
          );
        }
      },
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