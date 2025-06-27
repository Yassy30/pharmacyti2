// lib/features/delivery/dashboard/view/livreur_dashboard.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pharmaciyti/features/auth/view/login.dart';
import 'package:pharmaciyti/features/auth/viewmodel/user_viewmodel.dart';
import 'package:pharmaciyti/features/delivery/navigation/MainContainer.dart';

class LivreurDashboard extends StatefulWidget {
  @override
  State<LivreurDashboard> createState() => _LivreurDashboardState();
}

class _LivreurDashboardState extends State<LivreurDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDashboardData();
    });
  }

  void _loadDashboardData() {
    final userViewModel = context.read<UserViewModel>();
    
    // Fetch user details if not already loaded
    if (userViewModel.fullName == null) {
      userViewModel.fetchUserDetails();
    }
    // No need to fetch dashboard data since it's static
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _loadDashboardData(); // Only refreshes user data
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Welcome section with user info
              Consumer<UserViewModel>(
                builder: (context, userViewModel, child) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, Welcome Back',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              userViewModel.isLoading 
                                  ? 'Loading...' 
                                  : userViewModel.fullName ?? 'Delivery Person',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            if (userViewModel.errorMessage != null)
                              Text(
                                'Error loading profile',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 10,
                                ),
                              ),
                          ],
                        ),
                        Row(
                          children: [
                            // Profile avatar
                            CircleAvatar(
                              backgroundColor: Colors.blue.withOpacity(0.1),
                              backgroundImage: userViewModel.imageProfile != null
                                  ? NetworkImage(userViewModel.imageProfile!)
                                  : null,
                              child: userViewModel.imageProfile == null
                                  ? Text(
                                      userViewModel.getUserInitials(),
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
                            ),
                            SizedBox(width: 8),
                            // Logout button
                            CircleAvatar(
                              backgroundColor: Colors.orange.withOpacity(0.1),
                              child: GestureDetector(
                                onTap: () {
                                  _showLogoutDialog(context);
                                },
                                child: Icon(
                                  Icons.logout,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              // Main content with static orders stats
              Container(
                color: Colors.grey[200],
                padding: EdgeInsets.all(16),
                height: MediaQuery.of(context).size.height - 100,
                child: Column(
                  children: [
                    // Current Orders (Static)
                    GestureDetector(
                      onTap: () {
                        final mainContainerState = context.findAncestorStateOfType<LivreurMainContainerState>();
                        if (mainContainerState != null) {
                          mainContainerState.navigateTo(1, tabIndex: 0);
                        }
                      },
                      child: _buildStatsCard(
                        title: 'Current Orders',
                        count: '10', // Static value
                        subtitle: 'All pending & in progress deliveries',
                        icon: Icons.shopping_bag_outlined,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    // Completed Orders (Static)
                    GestureDetector(
                      onTap: () {
                        final mainContainerState = context.findAncestorStateOfType<LivreurMainContainerState>();
                        if (mainContainerState != null) {
                          mainContainerState.navigateTo(1, tabIndex: 1);
                        }
                      },
                      child: _buildStatsCard(
                        title: 'Completed Orders',
                        count: '15', // Static value
                        subtitle: 'All successfully delivered orders',
                        icon: Icons.check_circle_outline,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    // Total Orders (Static)
                    _buildStatsCard(
                      title: 'Total Delivery Orders',
                      count: '25', // Static value
                      subtitle: 'All orders with delivery assigned',
                      icon: Icons.analytics_outlined,
                      color: Colors.blue,
                    ),
                    SizedBox(height: 24),
                    
                    // Quick stats row (Static)
                    // Row(
                    //   children: [
                    //     // Expanded(
                    //     //   child: _buildMiniStatsCard(
                    //     //     title: 'Pending',
                    //     //     count: '5', // Static value
                    //     //     color: Colors.grey,
                    //     //   ),
                    //     ),
                    //     SizedBox(width: 12),
                    //     // Expanded(
                    //     //   child: _buildMiniStatsCard(
                    //     //     title: 'In Progress',
                    //     //     count: '5', // Static value
                    //     //     color: Colors.orange,
                    //     //   ),
                    //     // ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard({
    required String title,
    required String count,
    String? subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  count,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.black87,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStatsCard({
    required String title,
    required String count,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Clear user data
                context.read<UserViewModel>().resetUserData();
                // No need to reset dashboard data since it's static
                
                // Navigate to login
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                  (route) => false,
                );
              },
              child: Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}