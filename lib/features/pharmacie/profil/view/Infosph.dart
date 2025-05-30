import 'package:flutter/material.dart';
import 'package:pharmaciyti/features/pharmacie/congratulation/congratsph.dart';

class Infosph extends StatefulWidget {
  const Infosph({Key? key}) : super(key: key);

  @override
  State<Infosph> createState() => _InfosphState();
}

class _InfosphState extends State<Infosph> {
  final TextEditingController pharmacyNameController = TextEditingController();
  final TextEditingController pharmacyAddressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

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
                "Upload pharmacy logo",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              // Pharmacy logo upload container
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
              
              // Pharmacy name field
              const Text(
                "Pharmacy name",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: pharmacyNameController,
                decoration: InputDecoration(
                  hintText: "Enter Pharmacy name",
                  filled: true,
                  fillColor: const Color(0xfff2f2f2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Pharmacy address field
              const Text(
                "Pharmacy Adress",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: pharmacyAddressController,
                decoration: InputDecoration(
                  hintText: "Enter Pharmacy Adress",
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
              const SizedBox(height: 100),
              
              // Submit button
              ElevatedButton(
                onPressed: () {
                  // Navigate to congratulations screen when form is submitted
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Congratsph(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Changed from orange to green
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