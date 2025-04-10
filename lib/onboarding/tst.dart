import 'package:flutter/material.dart';
import 'onboarding1.dart'; // Import your onboarding screens
import 'onboarding2.dart';
import 'onboarding3.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Controller for PageView
  final PageController _pageController = PageController(initialPage: 0);

  // Current page index
  int _currentPage = 0;

  // List of onboarding screens
  final List<Widget> _onboardingScreens = const [
    Onboarding1(),
    Onboarding2(),
    Onboarding3(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView for sliding screens
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: _onboardingScreens,
          ),

          // Pagination indicators at the bottom
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _onboardingScreens.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Container(
                    height: 6,
                    width: 6,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? Colors.blue : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Navigation buttons (optional)
          Positioned(
            bottom: 20, // Adjust the position as needed
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity, // Ensure the button spans the full width
              margin: const EdgeInsets.symmetric(horizontal: 20), // Optional: Add padding
              child: ElevatedButton(
                onPressed: () {
                  if (_currentPage < _onboardingScreens.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  } else {
                    // Navigate to the home screen or another destination
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Solid blue background
                  padding: const EdgeInsets.symmetric(vertical: 16), // Vertical padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  elevation: 0, // Remove shadow/elevation for a flat design
                ),
                child: Text(
                  _currentPage < _onboardingScreens.length - 1 ? "Next" : "Get Started",
                  style: const TextStyle(
                    color: Colors.white, // White text color
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center, // Center-align the text
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}