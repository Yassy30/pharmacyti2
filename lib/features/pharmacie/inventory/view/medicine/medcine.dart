import 'package:flutter/material.dart';
import 'package:pharmaciyti/features/pharmacie/inventory/view/medicine/addMedcine.dart';
import 'package:pharmaciyti/core/constants/colors.dart';

class MedicinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Medicine'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textBlack,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle, color: AppColors.primaryGreen),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddMedicinePage()),
              );
            },
          ),
          
        ],
      ),
      body: ListView(
        children: [
          _buildMedicineItem(
            context,
            imagePath: 'assets/images/triphala.jpeg',
            name: 'Arckveda Triphala Juice Herbal - 600 MI',
            category: 'Dandruff',
            price: '\$15',
            originalPrice: '\$59',
          ),
          _buildMedicineItem(
            context,
            imagePath: 'assets/images/a_gen_cream.jpeg',
            name: 'A GEN Cream 15gm',
            category: 'Dandruff',
            price: '\$18',
            originalPrice: '\$20',
          ),
          _buildMedicineItem(
            context,
            imagePath: 'assets/images/eclo_ointment.jpeg',
            name: 'ECLO 6 Ointment 30gm',
            category: 'Pain relief',
            price: '\$82',
            originalPrice: '\$90',
          ),
        ],
      ),
    );
  }

  Widget _buildMedicineItem(
    BuildContext context, {
    required String imagePath,
    required String name,
    required String category,
    required String price,
    required String originalPrice,
  }) {
    return Card(
      color: AppColors.white, // Set Card background to white
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) =>
                      Icon(Icons.broken_image, size: 80, color: AppColors.textGrey),
                ),
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    category,
                    style: TextStyle(fontSize: 14.0, color: AppColors.textGrey),
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text(
                        price,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.priceBlue, // Set price color to blue
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        originalPrice,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: AppColors.textGrey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: AppColors.primaryGreen),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}