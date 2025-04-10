import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
            top: 0.10446009389671361 * mediaQH,
            left: 0.356234096692112 * mediaQW,
            child: Image.network(
              "https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/f7f95324-8d7d-4780-b8ab-16fdce769e60",
              height: 0.13262910798122066 * mediaQH,
              width: 0.2875318066157761 * mediaQW,
            ),
          ),
          Positioned(
            top: 0.23708920187793428 * mediaQH,
            left: 0.23918575063613232 * mediaQW,
            child: SizedBox(
              width: 0.5216284987277354 * mediaQW,
              child: Text(
                "     Welcome to PHARMACYTI",
                style: const TextStyle(
                  color: Color(0xff000000),
                  fontWeight: FontWeight.w900,
                  fontSize: 26,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0.3615023474178404 * mediaQH,
            left: 0.06615776081424936 * mediaQW,
            child: SizedBox(
              width: 0.183206106870229 * mediaQW,
              child: Text(
                "Username",
                style: const TextStyle(
                  color: Color(0xff000000),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0.3967136150234742 * mediaQH,
            left: 0.06615776081424936 * mediaQW,
            child: Container(
              height: 0.056338028169014086 * mediaQH,
              width: 0.8676844783715013 * mediaQW,
              decoration: BoxDecoration(
                  color: const Color(0xfff2f2f2),
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
            top: 0.4119718309859155 * mediaQH,
            left: 0.09669211195928754 * mediaQW,
            child: SizedBox(
              width: 0.15012722646310434 * mediaQW,
              child: Text(
                "Username",
                style: const TextStyle(
                  color: Color(0xffa4a4a4),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0.4788732394366197 * mediaQH,
            left: 0.06615776081424936 * mediaQW,
            child: SizedBox(
              width: 0.8676844783715013 * mediaQW,
              child: Text(
                "Password",
                style: const TextStyle(
                  color: Color(0xff000000),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0.5140845070422535 * mediaQH,
            left: 0.06615776081424936 * mediaQW,
            child: Container(
              height: 0.056338028169014086 * mediaQH,
              width: 0.8676844783715013 * mediaQW,
              decoration: BoxDecoration(
                  color: const Color(0xfff2f2f2),
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
            top: 0.5293427230046949 * mediaQH,
            left: 0.09669211195928754 * mediaQW,
            child: SizedBox(
              width: 0.11704834605597965 * mediaQW,
              child: Text(
                "*******",
                style: const TextStyle(
                  color: Color(0xffa4a4a4),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0.5316901408450704 * mediaQH,
            left: 0.8447837150127226 * mediaQW,
            child: Image.network(
              "https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/e1e22cd7-b8f3-4656-9049-0f27fad9b23f",
              height: 0.022300469483568074 * mediaQH,
              width: 0.05597964376590331 * mediaQW,
            ),
          ),
          Positioned(
            top: 0.5774647887323944 * mediaQH,
            left: 0.06615776081424936 * mediaQW,
            child: SizedBox(
              width: 0.8676844783715013 * mediaQW,
              child: Text(
                "Forgot password?",
                style: const TextStyle(
                  color: Color(0xff2299c3),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0.6338028169014085 * mediaQH,
            left: 0.06615776081424936 * mediaQW,
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
            top: 0.6490610328638498 * mediaQH,
            left: 0.44529262086513993 * mediaQW,
            child: SizedBox(
              width: 0.10941475826972011 * mediaQW,
              child: Text(
                "Login",
                style: const TextStyle(
                  color: Color(0xffffffff),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0.7359154929577465 * mediaQH,
            left: 0.3893129770992366 * mediaQW,
            child: SizedBox(
              width: 0.22391857506361323 * mediaQW,
              child: Text(
                "Or  login  with",
                style: const TextStyle(
                  color: Color(0xffa4a4a4),
                  fontWeight: FontWeight.w300,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0.7969483568075117 * mediaQH,
            left: 0.06615776081424936 * mediaQW,
            child: Container(
              height: 0.056338028169014086 * mediaQH,
              width: 0.8676844783715013 * mediaQW,
              decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  border: Border.all(color: const Color(0xffe7e7e7)),
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
            top: 0.812206572769953 * mediaQH,
            left: 0.37404580152671757 * mediaQW,
            child: Image.network(
              "https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/fb550b07-f437-44f6-b0bf-3156115b890c",
              height: 0.025821596244131457 * mediaQH,
              width: 0.05597964376590331 * mediaQW,
            ),
          ),
          Positioned(
            top: 0.812206572769953 * mediaQH,
            left: 0.4758269720101781 * mediaQW,
            child: SizedBox(
              width: 0.15012722646310434 * mediaQW,
              child: Text(
                "Google",
                style: const TextStyle(
                  color: Color(0xffa4a4a4),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0.9014084507042254 * mediaQH,
            left: 0.2010178117048346 * mediaQW,
            child: SizedBox(
              width: 0.6005089058524173 * mediaQW,
              child: Text(
                "Don’t have an account yet? Register here",
                style: const TextStyle(
                  color: Color(0xff000000),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ]),
      ))),
    );
  }
}
