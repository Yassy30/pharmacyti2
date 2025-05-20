import 'package:flutter/material.dart';
import 'package:pharmaciyti/client/congratulations.dart';
import 'package:pharmaciyti/livreur/congratsliv.dart';
import 'package:pharmaciyti/pharmacie/congratsph.dart';

class WhoAreYou extends StatefulWidget {
  const WhoAreYou({super.key});

  @override
  State<WhoAreYou> createState() => _WhoAreYouState();
}

class _WhoAreYouState extends State<WhoAreYou> {
  String? selectedRole;

  @override
  void initState() {
    super.initState();
  }

  void selectRole(String role) {
    setState(() {
      selectedRole = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Text(
                  "Who are you ?",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 27,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildRoleOption(
                      title: "Client",
                      imagePath: "assets/images/client.png", 
                      role: "client",
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildRoleOption(
                      title: "Pharmacy",
                      imagePath: "assets/images/pharmacie.png",
                      role: "pharmacy",
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildRoleOption(
                      title: "Delivery guy",
                      imagePath: "assets/images/livreur.png",
                      role: "delivery",
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                if (selectedRole != null)
                  ElevatedButton(
                    onPressed: () {
                      if (selectedRole == "client") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Congratulations(),
                          ),
                        );
                      } else if (selectedRole == "pharmacy") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Congratsph(),
                          ),
                        );
                      } else if (selectedRole == "delivery") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Congratsliv(),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleOption({
    required String title,
    required String imagePath,
    required String role,
  }) {
    bool isSelected = selectedRole == role;
    
    return GestureDetector(
      onTap: () => selectRole(role),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                imagePath,
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
