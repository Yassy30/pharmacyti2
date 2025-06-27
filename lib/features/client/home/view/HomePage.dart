import 'package:flutter/material.dart';
import 'package:pharmaciyti/features/auth/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../search/view/search.dart';
import '../../cart/view/cart.dart';
import 'package:pharmaciyti/features/client/profile/view/profile_client.dart';
import 'package:pharmaciyti/features/client/home/viewmodel/home_viewmodel.dart';
import 'package:pharmaciyti/features/client/search/viewmodel/search_viewmodel.dart';
import 'package:pharmaciyti/features/pharmacie/inventory/data/models/category.dart' as myCategory;
import 'package:pharmaciyti/features/client/home/data/models/pharmacy.dart' as myPharmacy;
import 'map_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
      if (userViewModel.fullName == null && !userViewModel.isLoading) {
        userViewModel.fetchUserDetails();
      }
      homeViewModel.fetchUser(); // Ensure initial user data fetch
    });
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    ).then((_) {
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
      userViewModel.fetchUserDetails();
      homeViewModel.fetchUser(); // Refresh HomeViewModel data after profile update
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final viewModel = Provider.of<HomeViewModel>(context);

    final List<Widget> screens = [
      _buildHomeContent(context, viewModel),
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
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: const [
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
              if (index == 1) {
                _searchQuery = '';
              } else if (index == 3) {
                _navigateToProfile();
              }
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
              icon: Icon(
                Icons.search,
                color: _selectedIndex == 1 ? Colors.blue[700] : Colors.grey[600],
                size: screenWidth * 0.07,
              ),
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

  Widget _buildHomeContent(BuildContext context, HomeViewModel viewModel) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: viewModel.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            _buildUserAvatar(viewModel, screenWidth),
                            SizedBox(width: screenWidth * 0.03),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  viewModel.user?.fullName ?? 'Guest User',
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
                                      viewModel.user?.address ?? 'Unknown Location',
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
                          icon: Icon(Icons.search, color: Colors.blue, size: screenWidth * 0.07),
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 1;
                              _searchQuery = '';
                            });
                          },
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
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
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
              child: viewModel.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : viewModel.categories.isEmpty
                      ? Center(
                          child: Text(
                            'No categories available',
                            style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                          itemCount: viewModel.categories.length,
                          itemBuilder: (context, index) {
                            final category = viewModel.categories[index];
                            return _buildCategoryItem(category, screenWidth);
                          },
                        ),
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Container(
                height: screenHeight * 0.16,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F7FA),
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
                  decoration: const BoxDecoration(
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
              padding: EdgeInsets.only(
                left: screenWidth * 0.04,
                right: screenWidth * 0.04,
                top: screenHeight * 0.03,
                bottom: screenHeight * 0.01,
              ),
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
              child: viewModel.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : viewModel.pharmacies.isEmpty
                      ? Center(
                          child: Text(
                            'No pharmacies available',
                            style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: viewModel.pharmacies.length,
                          itemBuilder: (context, index) {
                            final pharmacy = viewModel.pharmacies[index];
                            return _buildPharmacyItem(pharmacy, screenWidth, screenHeight);
                          },
                        ),
            ),
            SizedBox(height: screenHeight * 0.03),
          ],
        ),
      ),
    );
  }

  Widget _buildUserAvatar(HomeViewModel viewModel, double screenWidth) {
    final userViewModel = Provider.of<UserViewModel>(context);
    return Container(
      width: screenWidth * 0.11,
      height: screenWidth * 0.11,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.blue.shade200, width: 2),
      ),
      child: ClipOval(
        child: _buildProfileImage(userViewModel, screenWidth),
      ),
    );
  }

  Widget _buildProfileImage(UserViewModel userViewModel, double screenWidth) {
    String? imageUrl = userViewModel.imageProfile;
    
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey.shade200,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade300),
            ),
          ),
        ),
        errorWidget: (context, url, error) {
          print('Error loading profile image: $error');
          print('Failed URL: $imageUrl');
          return _buildDefaultAvatar(screenWidth);
        },
      );
    } else {
      return _buildDefaultAvatar(screenWidth);
    }
  }

  Widget _buildDefaultAvatar(double screenWidth) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    return Container(
      color: Colors.blue.shade50,
      child: Center(
        child: Text(
          userViewModel.getUserInitials(),
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(myCategory.Category category, double screenWidth) {
    return Container(
      margin: EdgeInsets.only(right: screenWidth * 0.04),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: screenWidth * 0.15,
            height: screenWidth * 0.15,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue.shade100, width: 1),
            ),
            child: _buildCategoryImage(category, screenWidth),
          ),
          SizedBox(height: screenWidth * 0.02),
          SizedBox(
            width: screenWidth * 0.15,
            child: Text(
              category.name,
              style: TextStyle(
                fontSize: screenWidth * 0.03,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryImage(myCategory.Category category, double screenWidth) {
    if (category.image != null && category.image!.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: category.image!,
          width: screenWidth * 0.075,
          height: screenWidth * 0.075,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: screenWidth * 0.075,
            height: screenWidth * 0.075,
            color: Colors.blue.shade50,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade300),
              ),
            ),
          ),
          errorWidget: (context, url, error) {
            print('Error loading category image for ${category.name}: $error');
            return _buildCategoryDefaultIcon(screenWidth);
          },
        ),
      );
    } else {
      return _buildCategoryDefaultIcon(screenWidth);
    }
  }

  Widget _buildCategoryDefaultIcon(double screenWidth) {
    return Center(
      child: Icon(
        Icons.medical_services_outlined,
        size: screenWidth * 0.075,
        color: Colors.blue.shade400,
      ),
    );
  }

  Widget _buildPharmacyItem(myPharmacy.Pharmacy pharmacy, double screenWidth, double screenHeight) {
    final bool isOpen = pharmacy.isOpen ?? false;
    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    pharmacy.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.045),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Icon(Icons.star, color: Colors.amber, size: screenWidth * 0.035),
                  Text(
                    '4.5',
                    style: TextStyle(fontSize: screenWidth * 0.035),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: screenHeight * 0.005),
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
          SizedBox(height: screenHeight * 0.005),
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.red, size: screenWidth * 0.035),
              Text(
                ' ${pharmacy.address ?? 'Unknown Address'}',
                style: TextStyle(fontSize: screenWidth * 0.035),
              ),
              Text(
                ' • 0.8 km away',
                style: TextStyle(color: Colors.grey, fontSize: screenWidth * 0.035),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: pharmacy.phoneNumber != null
                      ? () async {
                          final Uri phoneUri = Uri(scheme: 'tel', path: pharmacy.phoneNumber);
                          try {
                            if (await canLaunchUrl(phoneUri)) {
                              await launchUrl(phoneUri);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Cannot launch phone dialer')),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error launching dialer: $e')),
                            );
                          }
                        }
                      : null,
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
              SizedBox(width: screenWidth * 0.02),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapPage(pharmacy: pharmacy),
                      ),
                    );
                  },
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