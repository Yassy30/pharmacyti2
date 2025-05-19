import 'package:flutter/material.dart';
import 'package:pharmaciyti/pharmacie/medcine.dart';
import 'package:pharmaciyti/pharmacie/category.dart';
import 'package:pharmaciyti/pharmacie/payment.dart';
import 'package:pharmaciyti/utils/colors.dart';
import 'earning.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<Dashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Welcome section with light background
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
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
                        color: AppColors.textGrey,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Healthy Pharmacy',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  backgroundColor: AppColors.primaryGreen.withOpacity(0.1),
                  child: Icon(
                    Icons.logout_outlined,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
          ),
          // Main content
          Expanded(
            child: Container(
              color: AppColors.lightGrey,
              padding: EdgeInsets.all(16),
              child: ListView(
                children: [
                  _buildDashboardItem(
                    'Medicine',
                    Icons.medical_services_outlined,
                    AppColors.primaryGreen,
                    count: '8',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MedicinePage()),
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  _buildDashboardItem(
                    'Category',
                    Icons.category_outlined,
                    AppColors.primaryGreen,
                    count: '6',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CategoryPage()),
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  _buildDashboardItem(
                    'Payout',
                    Icons.payment_outlined,
                    AppColors.primaryGreen,
                    amount: '\$160',
                    
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PayPage()),
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildDashboardItem(
                    'Earning',
                    Icons.attach_money_outlined,
                    AppColors.primaryGreen,
                    amount: '\$668.9',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EarningsPage()),
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

  Widget _buildDashboardItem(String title, IconData icon, Color color,
      {String? count, String? amount, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
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
                    color: AppColors.textGrey,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  count ?? amount ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}