import 'package:flutter/material.dart';
import 'package:pharmaciyti/onboarding/onboarding3.dart';

class Onboarding2 extends StatefulWidget {
  const Onboarding2({super.key});

  @override
  State<Onboarding2> createState() => _Onboarding2State();
}

class _Onboarding2State extends State<Onboarding2> {
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
            right: 0,
            child: Center( // Wrap with Center widget
              child: Image.asset("assets/images/onboard2.png"),
            ),        
            ),
          Positioned(
            top: 0.16314553990610328 * mediaQH,
            left: 0.10432569974554708 * mediaQW,
            child: SizedBox(
              width: 0.7913486005089059 * mediaQW,
              child: Text(
                "24/7 Pharmacies Near You",
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
                "Locate pharmacies around you that are open anytime, day or night",
                style: const TextStyle(
                  color: Color(0xff000000),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          // Positioned(
          //   top: 0.818075117370892 * mediaQH,
          //   left: 0.32061068702290074 * mediaQW,
          //   child: Container(
          //     height: 0.008215962441314555 * mediaQH,
          //     width: 0.06615776081424936 * mediaQW,
          //     decoration: BoxDecoration(
          //         color: const Color(0xffe7e7e7),
          //         border: Border.all(color: const Color(0x00000000)),
          //         borderRadius: const BorderRadius.only(
          //           topLeft: Radius.circular(4),
          //           topRight: Radius.circular(4),
          //           bottomLeft: Radius.circular(4),
          //           bottomRight: Radius.circular(4),
          //         )),
          //     alignment: Alignment.center,
          //   ),
          // ),
          // Positioned(
          //   top: 0.818075117370892 * mediaQH,
          //   left: 0.4071246819338422 * mediaQW,
          //   child: Container(
          //     height: 0.008215962441314555 * mediaQH,
          //     width: 0.183206106870229 * mediaQW,
          //     decoration: BoxDecoration(
          //         color: const Color(0xff2299c3),
          //         border: Border.all(color: const Color(0x00000000)),
          //         borderRadius: const BorderRadius.only(
          //           topLeft: Radius.circular(4),
          //           topRight: Radius.circular(4),
          //           bottomLeft: Radius.circular(4),
          //           bottomRight: Radius.circular(4),
          //         )),
          //     alignment: Alignment.center,
          //   ),
          // ),
          // Positioned(
          //   top: 0.818075117370892 * mediaQH,
          //   left: 0.6106870229007634 * mediaQW,
          //   child: Container(
          //     height: 0.008215962441314555 * mediaQH,
          //     width: 0.06615776081424936 * mediaQW,
          //     decoration: BoxDecoration(
          //         color: const Color(0xffe7e7e7),
          //         border: Border.all(color: const Color(0x00000000)),
          //         borderRadius: const BorderRadius.only(
          //           topLeft: Radius.circular(4),
          //           topRight: Radius.circular(4),
          //           bottomLeft: Radius.circular(4),
          //           bottomRight: Radius.circular(4),
          //         )),
          //     alignment: Alignment.center,
          //   ),
          // ),
        ]),
      ))),
    );
  }
}
