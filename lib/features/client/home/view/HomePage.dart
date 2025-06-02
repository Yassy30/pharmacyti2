import 'package:flutter/material.dart';
import '../../search/view/search.dart';
import '../../cart/view/cart.dart';
import '../../profile/view/profile_client.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Define the screens dynamically to ensure they use the latest context and state
    final List<Widget> screens = [
      _buildHomeContent(context),
      SearchPage(initialQuery: _searchQuery),
      CartPage(),
      ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.blue[700],
          unselectedItemColor: Colors.grey[600],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          showUnselectedLabels: true,
          selectedFontSize: screenWidth * 0.035,
          unselectedFontSize: screenWidth * 0.03,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: screenWidth * 0.07),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search,
                  color: _selectedIndex == 1 ? Colors.blue[700] : Colors.grey[600],
                  size: screenWidth * 0.07),
              label: "Search",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined, size: screenWidth * 0.07),
              label: "Cart",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: screenWidth * 0.07),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: screenWidth * 0.055,
                        backgroundImage: AssetImage('assets/images/client.png'),
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fatima Bichouarine',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.045,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.circle, color: Colors.green, size: screenWidth * 0.025),
                              SizedBox(width: 4),
                              Text(
                                'Agadir, Morocco',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: screenWidth * 0.032,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.logout_outlined, color: Colors.blue, size: screenWidth * 0.07),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey, size: screenWidth * 0.06),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        onSubmitted: (value) {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search for medicines, pharmacies...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey, fontSize: screenWidth * 0.037),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.document_scanner_outlined, color: Colors.grey, size: screenWidth * 0.06),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.filter_list, color: Colors.grey, size: screenWidth * 0.06),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.04, top: screenHeight * 0.03, bottom: screenHeight * 0.01),
              child: Text(
                'Categories',
                style: TextStyle(fontSize: screenWidth * 0.048, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.12,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                children: [
                  _buildCategoryItem('Cold & Flu', 'assets/images/pharmacy_logo.png', screenWidth),
                  _buildCategoryItem('Vitamins', 'assets/images/pharmacy_logo.png', screenWidth),
                  _buildCategoryItem('Personal Care', 'assets/images/pharmacy_logo.png', screenWidth),
                  _buildCategoryItem('Baby & Mom', 'assets/images/pharmacy_logo.png', screenWidth),
                  _buildCategoryItem('Natural & Organic', 'assets/images/pharmacy_logo.png', screenWidth),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Container(
                height: screenHeight * 0.16,
                decoration: BoxDecoration(
                  color: Color(0xFFE0F7FA),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Need help fast? Get',
                              style: TextStyle(fontSize: screenWidth * 0.038),
                            ),
                            Text(
                              '24/7 delivery now',
                              style: TextStyle(fontSize: screenWidth * 0.042, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: screenHeight * 0.015),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Order now',
                                style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.034),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Image.asset(
                        'assets/images/triphala.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: screenWidth * 0.02,
                  height: screenWidth * 0.02,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: screenWidth * 0.01),
                Container(
                  width: screenWidth * 0.02,
                  height: screenWidth * 0.02,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: screenWidth * 0.01),
                Container(
                  width: screenWidth * 0.02,
                  height: screenWidth * 0.02,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.04, right: screenWidth * 0.04, top: screenHeight * 0.03, bottom: screenHeight * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pharmacies Near You',
                    style: TextStyle(fontSize: screenWidth * 0.048, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Map view',
                    style: TextStyle(fontSize: screenWidth * 0.032, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Column(
                children: [
                  _buildPharmacyItem('Pharmacy Al Yassir', '4.5', 'Rue Hassan II', '0.8 km away', true, screenWidth, screenHeight),
                  _buildPharmacyItem('Pharmacy Al Yassir', '4.5', 'Rue Hassan II', '0.8 km away', false, screenWidth, screenHeight),
                  _buildPharmacyItem('Pharmacy Al Yassir', '4.5', 'Rue Hassan II', '0.8 km away', true, screenWidth, screenHeight),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String title, String imagePath, double screenWidth) {
    return Container(
      margin: EdgeInsets.only(right: screenWidth * 0.04),
      child: Column(
        children: [
          Container(
            width: screenWidth * 0.15,
            height: screenWidth * 0.15,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                width: screenWidth * 0.075,
                height: screenWidth * 0.075,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: screenWidth * 0.02),
          Text(
            title,
            style: TextStyle(fontSize: screenWidth * 0.03),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPharmacyItem(String name, String rating, String address, String distance, bool isOpen, double screenWidth, double screenHeight) {
    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.045),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Icon(Icons.star, color: Colors.amber, size: screenWidth * 0.04),
                  Text(
                    rating,
                    style: TextStyle(fontSize: screenWidth * 0.035),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.007),
                decoration: BoxDecoration(
                  color: isOpen ? Colors.green.shade100 : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isOpen ? 'Open now' : 'Closed',
                  style: TextStyle(
                    color: isOpen ? Colors.green.shade700 : Colors.red.shade700,
                    fontSize: screenWidth * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.red, size: screenWidth * 0.04),
              Text(
                ' $address',
                style: TextStyle(fontSize: screenWidth * 0.035),
              ),
              Text(
                ' • $distance',
                style: TextStyle(color: Colors.grey, fontSize: screenWidth * 0.035),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.call, color: Colors.white, size: screenWidth * 0.045),
                  label: Text('Call', style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.035)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.menu_book, color: Colors.blue, size: screenWidth * 0.045),
                  label: Text('View', style: TextStyle(color: Colors.blue, fontSize: screenWidth * 0.035)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.blue.shade200),
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    backgroundColor: Colors.blue.shade50,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}