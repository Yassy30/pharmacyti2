import 'package:flutter/material.dart';

class PersonalInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.02),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.01),
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: screenWidth * 0.16,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: AssetImage('assets/images/client.png'),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Icon(Icons.camera_alt, size: screenWidth * 0.07, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                _buildLabel('Your name', screenWidth),
                _buildInfoField('Fatima Bichouarine', context),
                SizedBox(height: screenHeight * 0.025),
                _buildLabel('Your Email', screenWidth),
                _buildInfoField('fatemabichouarine@gmail.com', context),
                SizedBox(height: screenHeight * 0.025),
                _buildLabel('Phone number', screenWidth),
                _buildInfoField('0612345678', context, hint: '0612345678'),
                SizedBox(height: screenHeight * 0.025),
                _buildLabel('Addresse', screenWidth),
                _buildInfoField('123, Mohammed V Avenue', context),
                SizedBox(height: screenHeight * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(left: screenWidth * 0.01, bottom: screenWidth * 0.01),
      child: Text(
        label,
        style: TextStyle(
          fontSize: screenWidth * 0.042,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildInfoField(String value, BuildContext context, {String? hint}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.018,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: screenWidth * 0.042,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(Icons.edit, color: Colors.black, size: screenWidth * 0.055),
        ],
      ),
    );
  }
}