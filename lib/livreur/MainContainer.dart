import 'package:flutter/material.dart';
import 'package:pharmaciyti/livreur/Dashboard.dart';
import 'package:pharmaciyti/livreur/OrderScreen.dart';
import 'package:pharmaciyti/livreur/Profile.dart';

class LivreurMainContainer extends StatefulWidget {
  @override
  LivreurMainContainerState createState() => LivreurMainContainerState();
}

// Change from private to public state class
class LivreurMainContainerState extends State<LivreurMainContainer> {
  int _selectedIndex = 0;
  // Change to use the public state class of LivreurOrderScreen
  final GlobalKey<LivreurOrderScreenState> orderScreenKey = GlobalKey<LivreurOrderScreenState>();
  
  final List<Widget> _screens = [];
  
  @override
  void initState() {
    super.initState();
    _screens.addAll([
      LivreurDashboard(),
      LivreurOrderScreen(key: orderScreenKey),
      Profile()
    ]);
  }
  
  // Method to navigate to a specific screen and tab
  void navigateTo(int screenIndex, {int? tabIndex}) {
    setState(() {
      _selectedIndex = screenIndex;
    });
    // If tabIndex is provided and we're navigating to the order screen
    if (tabIndex != null && screenIndex == 1 && orderScreenKey.currentState != null) {
      // Use a small delay to ensure the screen has been built
      Future.delayed(Duration.zero, () {
        orderScreenKey.currentState!.setTabIndex(tabIndex);
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.amber,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              label: 'My Order',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}