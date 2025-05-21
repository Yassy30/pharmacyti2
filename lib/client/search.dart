import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // State variables
  String _searchQuery = ''; // To store the search input
  String? _selectedFilter; // To track the selected filter

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Search bar and filter icon
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04, // Slightly larger padding
                vertical: screenHeight * 0.02,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: screenHeight * 0.07, // Larger search bar
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(30), // More rounded
                        border: Border.all(color: Colors.grey[300]!, width: 1.5),
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
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.03),
                            child: Icon(Icons.search,
                                color: Colors.grey[600],
                                size: screenWidth * 0.07), // Larger icon
                          ),
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value; // Update search query
                                });
                              },
                              decoration: InputDecoration(
                                hintText: "Search for medicines, pharmacies...",
                                hintStyle: TextStyle(color: Colors.grey[500]),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.015),
                              ),
                              style: TextStyle(fontSize: screenWidth * 0.045), // Larger font
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Container(
                    height: screenHeight * 0.07, // Match search bar height
                    width: screenHeight * 0.07,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16), // Larger radius
                      border: Border.all(color: Colors.grey[300]!, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.tune,
                          color: Colors.grey[700], size: screenWidth * 0.07),
                      onPressed: () {
                        // Add filter icon functionality (e.g., open filter dialog)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Filter options not implemented yet')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Filter buttons
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterButton("Prescription", screenWidth),
                    SizedBox(width: screenWidth * 0.025),
                    _buildFilterButton("Distance", screenWidth),
                    SizedBox(width: screenWidth * 0.025),
                    _buildFilterButton("Price", screenWidth),
                    SizedBox(width: screenWidth * 0.025),
                    _buildFilterButton("Rating", screenWidth),
                  ],
                ),
              ),
            ),
            // Display search query or selected filter (for demo purposes)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Text(
                _searchQuery.isNotEmpty
                    ? 'Searching for: $_searchQuery'
                    : _selectedFilter != null
                        ? 'Filtered by: $_selectedFilter'
                        : 'Enter a search term or select a filter',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.grey[700],
                ),
              ),
            ),
            // The rest of the page
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label, double screenWidth) {
    bool isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = isSelected ? null : label; // Toggle filter selection
        });
      },
      child: Container(
        height: screenWidth * 0.12, // Larger filter buttons
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.white,
          border: Border.all(
              color: isSelected ? Colors.blue[700]! : Colors.grey[300]!, width: 1.5),
          borderRadius: BorderRadius.circular(12), // More rounded
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Prevent stretching
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: screenWidth * 0.04, // Larger font
                color: isSelected ? Colors.blue[700] : Colors.grey[800],
                fontWeight: FontWeight.w500, // Slightly bolder text
              ),
            ),
            SizedBox(width: screenWidth * 0.015),
            Icon(
              Icons.keyboard_arrow_down,
              size: screenWidth * 0.055, // Larger icon
              color: isSelected ? Colors.blue[700] : Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }
}