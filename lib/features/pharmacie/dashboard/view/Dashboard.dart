import 'package:flutter/material.dart';
<<<<<<< HEAD:lib/pharmacie/Dashboard.dart
import 'package:pharmaciyti/auth/login.dart';
import 'package:pharmaciyti/pharmacie/medcine.dart';
import 'package:pharmaciyti/pharmacie/category.dart';
import 'package:pharmaciyti/pharmacie/payment.dart';
// import 'package:pharmaciyti/pharmacie/earning.dart'; // Added import
import 'package:pharmaciyti/utils/colors.dart';
=======
import 'package:pharmaciyti/features/auth/view/login.dart';
import 'package:pharmaciyti/features/pharmacie/inventory/view/medicine/medcine.dart';
import 'package:pharmaciyti/features/pharmacie/inventory/view/category/category.dart';
import 'package:pharmaciyti/features/pharmacie/financials/view/payment.dart';
import 'package:pharmaciyti/core/constants/colors.dart';
import '../../financials/view/earning.dart';
>>>>>>> fe06d79b0b3cd945e118aa584adc724ebfb4e678:lib/features/pharmacie/dashboard/view/Dashboard.dart

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<Dashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Welcome section
            Container(
              padding: EdgeInsets.all(screenWidth * 0.04),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
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
                          fontSize: screenWidth * 0.03,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        'Healthy Pharmacy',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.045,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: screenWidth * 0.06,
                    backgroundColor: AppColors.primaryGreen.withOpacity(0.1),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const Login()),
                          (route) => false,
                        );
                      },
                      child: Icon(
                        Icons.logout_outlined,
                        color: AppColors.primaryGreen,
                        size: screenWidth * 0.06,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Main content
            Expanded(
              child: Container(
                color: AppColors.lightGrey,
                padding: EdgeInsets.all(screenWidth * 0.02),
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
                          MaterialPageRoute(builder: (context) =>  MedicinePage()),
                        );
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    _buildDashboardItem(
                      'Category',
                      Icons.category_outlined,
                      AppColors.primaryGreen,
                      count: '6',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  CategoryPage()),
                        );
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    _buildDashboardItem(
                      'Payout',
                      Icons.payment_outlined,
                      AppColors.primaryGreen,
                      amount: '\$160',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  PayPage()),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    _buildDashboardItem(
                      'Earning',
                      Icons.attach_money_outlined,
                      AppColors.primaryGreen,
                      amount: '\$668.9',
                      // onTap: () => Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) =>  EarningsPage()),
                      // ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardItem(String title, IconData icon, Color color,
      {String? count, String? amount, VoidCallback? onTap}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(screenWidth * 0.025),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: screenWidth * 0.06,
              ),
            ),
            SizedBox(width: screenWidth * 0.04),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: screenWidth * 0.035,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  count ?? amount ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.045,
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