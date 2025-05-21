import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final String initialQuery;

  const SearchPage({Key? key, this.initialQuery = ''}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late String _searchQuery;
  String? _selectedFilter;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _searchQuery = widget.initialQuery;
    _controller = TextEditingController(text: _searchQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: screenHeight * 0.07,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(30),
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
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                            child: Icon(Icons.search, color: Colors.grey[600], size: screenWidth * 0.07),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: "Search for medicines, pharmacies...",
                                hintStyle: TextStyle(color: Colors.grey[500]),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                              ),
                              style: TextStyle(fontSize: screenWidth * 0.045),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Container(
                    height: screenHeight * 0.07,
                    width: screenHeight * 0.07,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
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
                      icon: Icon(Icons.tune, color: Colors.grey[700], size: screenWidth * 0.07),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Filter options not implemented yet')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
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
            Expanded(
              child: _searchQuery.isNotEmpty
                  ? _buildNoResultsFound(screenWidth, screenHeight)
                  : _buildInitialMessage(screenWidth),
            ),
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
          _selectedFilter = isSelected ? null : label;
        });
      },
      child: Container(
        height: screenWidth * 0.12,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.white,
          border: Border.all(
              color: isSelected ? Colors.blue[700]! : Colors.grey[300]!, width: 1.5),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: isSelected ? Colors.blue[700] : Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: screenWidth * 0.015),
            Icon(
              Icons.keyboard_arrow_down,
              size: screenWidth * 0.055,
              color: isSelected ? Colors.blue[700] : Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialMessage(double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      child: Text(
        _selectedFilter != null
            ? 'Filtered by: $_selectedFilter'
            : 'Enter a search term or select a filter',
        style: TextStyle(
          fontSize: screenWidth * 0.04,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildNoResultsFound(double screenWidth, double screenHeight) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: screenWidth * 0.5,
            height: screenHeight * 0.3,
            child: Image.asset('assets/images/notFound.png'),
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            'No medicine found for "$_searchQuery".',
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            'Try checking the spelling or filters.',
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}