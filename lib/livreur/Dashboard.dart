import 'package:flutter/material.dart';
import 'package:pharmaciyti/livreur/OrderScreen.dart';
import 'package:pharmaciyti/livreur/MainContainer.dart';

class LivreurDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Welcome section with light background
          Container(
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
                      'Cscodetech',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  backgroundColor: Colors.orange.withOpacity(0.1),
                  child: Icon(
                    Icons.logout,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
          // Main content with orders stats
          Expanded(
            child: Container(
              color: Colors.grey[200],
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // Orders card - Navigate to Current Orders tab
                  GestureDetector(
                    onTap: () {
                      // Find the MainContainer state and use the navigateTo method
                      final mainContainerState = context.findAncestorStateOfType<LivreurMainContainerState>();
                      if (mainContainerState != null) {
                        mainContainerState.navigateTo(1, tabIndex: 0); // Navigate to Orders screen, Current Orders tab
                      }
                    },
                    child: _buildStatsCard(
                      title: 'Orders',
                      count: '2',
                      icon: Icons.shopping_bag_outlined,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      // Find the MainContainer state and use the navigateTo method
                      final mainContainerState = context.findAncestorStateOfType<LivreurMainContainerState>();
                      if (mainContainerState != null) {
                        mainContainerState.navigateTo(1, tabIndex: 1); // Navigate to Orders screen, Past Orders tab
                      }
                    },
                    child: _buildStatsCard(
                      title: 'Completed orders',
                      count: '1',
                      icon: Icons.shopping_bag_outlined,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard({
    required String title,
    required String count,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
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
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 4),
              Text(
                count,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}