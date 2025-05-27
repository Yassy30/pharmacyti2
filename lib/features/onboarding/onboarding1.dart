import 'package:flutter/material.dart';
import 'package:pharmaciyti/features/onboarding/onboarding2.dart';

class Onboarding1 extends StatefulWidget {
  const Onboarding1({super.key});

  @override
  State<Onboarding1> createState() => _Onboarding1State();
}

class _Onboarding1State extends State<Onboarding1> {
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
        child: Stack(children: [
          Positioned(
            top: 0.3039906103286385 * mediaQH,
            left: 0, // Remove the left positioning
            right: 0, // Add right positioning
            child: Center( // Wrap with Center widget
              child: Image.asset("assets/images/onboard1.png"),
            ),
          ),
          Positioned(
            top: 0.16314553990610328 * mediaQH,
            left: 0.10432569974554708 * mediaQW,
            child: SizedBox(
              width: 0.7913486005089059 * mediaQW,
              child: Text(
                "Easily Find Your Medications",
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
                "Browse a wide range of medicines and health products. Order in just a few taps",
                style: const TextStyle(
                  color: Color(0xff000000),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ]),
      ))),
    );
  }
}
