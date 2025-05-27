import 'package:flutter/material.dart';
import 'package:pharmaciyti/features/pharmacie/inventory/view/category/addCategory.dart';
import 'package:pharmaciyti/core/constants/colors.dart';

class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Category'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle, color: Colors.green),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCategoryPage()),
              );
            },
          ),
          
        ],
      ),
      body: ListView(
        children: [
          _buildCategoryItem(context, name: 'Dandruff'),
          _buildCategoryItem(context, name: 'Pain relief'),
          _buildCategoryItem(context, name: 'Vaccines'),
          _buildCategoryItem(context, name: 'Allergies'),
          _buildCategoryItem(context, name: 'Bacterial Infections'),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, {required String name}) {
    return Card(
      color: AppColors.white, // Set Card background to white
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Category Icon
            Icon(
              Icons.description,
              color: Colors.green,
              size: 40.0,
            ),
            SizedBox(width: 16.0),
            // Category Name
            Expanded(
              child: Text(
                name,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            // Edit Icon
            IconButton(
              icon: Icon(Icons.edit, color: Colors.green),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}