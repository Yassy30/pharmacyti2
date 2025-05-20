import 'package:flutter/material.dart';
import 'package:pharmaciyti/auth/login.dart';
import 'package:pharmaciyti/auth/signup.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double mediaQH = MediaQuery.of(context).size.height;
    double mediaQW = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: mediaQH,
            width: mediaQW,
            child: Stack(
              children: [
                Positioned(
                  top: 0.16314553990610328 * mediaQH,
                  left: 0.10432569974554708 * mediaQW,
                  child: SizedBox(
                    width: 0.7913486005089059 * mediaQW,
                    child: Text(
                      "Get Started",
                      style: const TextStyle(
                        color: Color(0xff000000),
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0.20892018779342722 * mediaQH,
                  left: 0.10432569974554708 * mediaQW,
                  child: SizedBox(
                    width: 0.7913486005089059 * mediaQW,
                    child: Text(
                      "Join us to access medications, pharmacies, and 24/7 delivery services",
                      style: const TextStyle(
                        color: Color(0xff000000),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0.3227699530516432 * mediaQH,
                  left: 0.06870229007633588 * mediaQW,
                  child: Image.asset("assets/images/GetStarted.png"),
                ),
                // Login Button
                Positioned(
                  top: 0.7875586854460094 * mediaQH,
                  left: 0,
                  right: 0, // Center horizontally
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
                    },
                    child: Container(
                      height: 0.056338028169014086 * mediaQH,
                      width: 0.8676844783715013 * mediaQW,
                      margin: const EdgeInsets.symmetric(horizontal: 20), // Add padding
                      decoration: BoxDecoration(
                        color: const Color(0xff2299c3),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Login to existing account",
                        style: const TextStyle(
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                // Register Button
                Positioned(
                  top: 0.8568075117370892 * mediaQH,
                  left: 0,
                  right: 0, // Center horizontally
                   child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUp()),
                      );
                    },
                    child: Container(
                      height: 0.056338028169014086 * mediaQH,
                      width: 0.8676844783715013 * mediaQW,
                      margin: const EdgeInsets.symmetric(horizontal: 20), // Add padding
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        border: Border.all(color: const Color(0xff2299c3)),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Register new account",
                        style: const TextStyle(
                          color: Color(0xff2299c3),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}