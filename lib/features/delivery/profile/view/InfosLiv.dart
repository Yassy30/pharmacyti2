import 'package:flutter/material.dart';
import 'package:pharmaciyti/features/delivery/congratulation/congratsliv.dart';

class InfosLiv extends StatefulWidget {
  const InfosLiv({Key? key}) : super(key: key);

  @override
  State<InfosLiv> createState() => _InfosLivState();
}

class _InfosLivState extends State<InfosLiv> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Upload your profile picture",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              // Profile picture upload container
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 180,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green.shade200,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Full name field
              const Text(
                "Full name",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(
                  hintText: "Enter your fullname",
                  filled: true,
                  fillColor: const Color(0xfff2f2f2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Phone number field
              const Text(
                "Phone number",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "Enter Phone Number",
                  filled: true,
                  fillColor: const Color(0xfff2f2f2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Address field
              const Text(
                "Adress",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  hintText: "Enter Your Adress",
                  filled: true,
                  fillColor: const Color(0xfff2f2f2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 100),
              
              // Submit button
              ElevatedButton(
                onPressed: () {
                  // Navigate to congratulations screen when form is submitted
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Congratsliv(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}