import 'package:flutter/material.dart';

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
        child: Stack(children: [
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
            child: Image.network(
              "https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/95ee9fc6-e498-483a-8915-d6012627b01c",
              height: 0.39906103286384975 * mediaQH,
              width: 0.8651399491094147 * mediaQW,
            ),
          ),
          Positioned(
            top: 0.7875586854460094 * mediaQH,
            left: 0.06870229007633588 * mediaQW,
            child: Container(
              height: 0.056338028169014086 * mediaQH,
              width: 0.8676844783715013 * mediaQW,
              decoration: BoxDecoration(
                  color: const Color(0xff2299c3),
                  border: Border.all(color: const Color(0x00000000)),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                    bottomLeft: Radius.circular(6),
                    bottomRight: Radius.circular(6),
                  )),
              alignment: Alignment.center,
            ),
          ),
          Positioned(
            top: 0.8028169014084507 * mediaQH,
            left: 0.25699745547073793 * mediaQW,
            child: SizedBox(
              width: 0.4910941475826972 * mediaQW,
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
          Positioned(
            top: 0.8568075117370892 * mediaQH,
            left: 0.06870229007633588 * mediaQW,
            child: Container(
              height: 0.056338028169014086 * mediaQH,
              width: 0.8676844783715013 * mediaQW,
              decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  border: Border.all(color: const Color(0xff2299c3)),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                    bottomLeft: Radius.circular(6),
                    bottomRight: Radius.circular(6),
                  )),
              alignment: Alignment.center,
            ),
          ),
          Positioned(
            top: 0.8720657276995305 * mediaQH,
            left: 0.28880407124681934 * mediaQW,
            child: SizedBox(
              width: 0.42748091603053434 * mediaQW,
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
        ]),
      ))),
    );
  }
}
