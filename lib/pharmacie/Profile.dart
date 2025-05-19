import 'package:flutter/material.dart';



class Profile extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  // Placeholder for custom logo (replace with actual image asset if available)
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.local_hospital, size: 50, color: Colors.blue),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Healthy Pharmacy',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Pharmacy Shops',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Text(
                    'healthy@gmail.com',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
            _buildOption(Icons.description, 'Privacy Policy', () {}),
            _buildOption(Icons.description, 'Terms & Conditions', () {}),
            _buildOption(Icons.contact_mail, 'Contact Us', () {}),
            _buildOption(Icons.delete, 'Delete Account', () {}),
            _buildOption(Icons.logout, 'Logout', () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(IconData icon, String title, VoidCallback onTap) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title),
        trailing: Icon(Icons.chevron_right, color: Colors.black),
        onTap: onTap,
      ),
    );
  }
}