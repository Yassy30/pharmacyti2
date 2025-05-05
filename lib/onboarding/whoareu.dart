import 'package:flutter/material.dart';

class WhoAreYou extends StatefulWidget {
  const WhoAreYou({super.key});

  @override
  State<WhoAreYou> createState() => _WhoAreYouState();
}

class _WhoAreYouState extends State<WhoAreYou> {
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
            left: 0.30025445292620867 * mediaQW,
            child: SizedBox(
              width: 0.3944020356234097 * mediaQW,
              child: Text(
                "Who are you ?",
                style: const TextStyle(
                  color: Color(0xff000000),
                  fontWeight: FontWeight.w900,
                  fontSize: 27,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0.22652582159624413 * mediaQH,
            left: 0.27735368956743 * mediaQW,
            child: Image.network(
              "https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/3a3db539-d130-4a08-a3f5-e59796c0bcff",
              height: 0.20305164319248825 * mediaQH,
              width: 0.4402035623409669 * mediaQW,
            ),
          ),
          Positioned(
            top: 0.24647887323943662 * mediaQH,
            left: 0.32061068702290074 * mediaQW,
            child: Image.network(
              "https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/ada39252-07cb-4ad8-9c5f-a4788d8bf229",
              height: 0.1643192488262911 * mediaQH,
              width: 0.356234096692112 * mediaQW,
            ),
          ),
          Positioned(
            top: 0.44366197183098594 * mediaQH,
            left: 0.27735368956743 * mediaQW,
            child: SizedBox(
              width: 0.4402035623409669 * mediaQW,
              child: Text(
                "Pharmacy",
                style: const TextStyle(
                  color: Color(0xff000000),
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0.5446009389671361 * mediaQH,
            left: 0.27735368956743 * mediaQW,
            child: Image.network(
              "https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/871dbe22-d2c5-4afc-bbf8-dcc956fa50f2",
              height: 0.20305164319248825 * mediaQH,
              width: 0.4402035623409669 * mediaQW,
            ),
          ),
          Positioned(
            top: 0.5645539906103286 * mediaQH,
            left: 0.32061068702290074 * mediaQW,
            child: Image.network(
              "https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/19340095-11a0-4986-8ce7-a24a74d8e95a",
              height: 0.1643192488262911 * mediaQH,
              width: 0.356234096692112 * mediaQW,
            ),
          ),
          Positioned(
            top: 0.7617370892018779 * mediaQH,
            left: 0.27735368956743 * mediaQW,
            child: SizedBox(
              width: 0.4402035623409669 * mediaQW,
              child: Text(
                "Client",
                style: const TextStyle(
                  color: Color(0xff000000),
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ]),
      ))),
    );
  }
}
