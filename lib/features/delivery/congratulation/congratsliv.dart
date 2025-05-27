import 'package:flutter/material.dart';
import 'package:pharmaciyti/features/delivery/dashboard/view/Dashboard.dart';
import 'package:pharmaciyti/features/delivery/navigation/MainContainer.dart';

class Congratsliv extends StatefulWidget {
  const Congratsliv({super.key});

  @override
  State<Congratsliv> createState() => _CongratulationsState();
}

class _CongratulationsState extends State<Congratsliv> {
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
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Congratulations",
                          style: const TextStyle(
                            color: Color(0xff000000),
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 10), // Add spacing between texts
                        Text(
                          "Your account has been created!",
                          style: const TextStyle(
                            color: Color(0xff000000),
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0.05 * mediaQH, 
                  left: 0.06615776081424936 * mediaQW,
                  right: 0.06615776081424936 * mediaQW,
                   child: GestureDetector( // Wrap with GestureDetector
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LivreurMainContainer(),
                        ),
                      );
                    },
                  child: Container(
                    height: 0.056338028169014086 * mediaQH,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Done",
                      style: const TextStyle(
                        color: Color(0xffffffff),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}