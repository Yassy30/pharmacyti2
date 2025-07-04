import 'package:flutter/material.dart';
// import 'package:pharmacyti2/pharmacie/Dashboard.dart';
import 'package:pharmaciyti/features/pharmacie/dashboard/view/Dashboard.dart';
import 'package:pharmaciyti/features/pharmacie/profil/view/Profile_pharmacy.dart';
import 'package:pharmaciyti/features/pharmacie/orders/view/order_screens.dart';

class MainContainer extends StatefulWidget {
  @override
  _MainContainerState createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [
    Dashboard(),
    OrderScreens(),
    Profile(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'My Order'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}