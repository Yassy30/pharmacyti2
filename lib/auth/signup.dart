// import 'package:flutter/material.dart';

// class SignUp extends StatefulWidget {
//   const SignUp({super.key});

//   @override
//   State<SignUp> createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double mediaQH = MediaQuery.of(context).size.height;
//     double mediaQW = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: Color(0xffffffff),
//       body: SafeArea(
//           child: SingleChildScrollView(
//               child: SizedBox(
//         height: mediaQH,
//         width: mediaQW,
//         child: Stack(children: [
//           Positioned(
//             top: 0.10446009389671361 * mediaQH,
//             left: 0.356234096692112 * mediaQW,
//             child: Image.network(
//               "https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/f7f95324-8d7d-4780-b8ab-16fdce769e60",
//               height: 0.13262910798122066 * mediaQH,
//               width: 0.2875318066157761 * mediaQW,
//             ),
//           ),
//           Positioned(
//             top: 0.2347417840375587 * mediaQH,
//             left: 0.23918575063613232 * mediaQW,
//             child: SizedBox(
//               width: 0.5216284987277354 * mediaQW,
//               child: Text(
//                 "Welcome to PHARMACYTI",
//                 style: const TextStyle(
//                   color: Color(0xff000000),
//                   fontWeight: FontWeight.w900,
//                   fontSize: 26,
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 0.3615023474178404 * mediaQH,
//             left: 0.06615776081424936 * mediaQW,
//             child: SizedBox(
//               width: 0.8676844783715013 * mediaQW,
//               child: Text(
//                 "Email",
//                 style: const TextStyle(
//                   color: Color(0xff000000),
//                   fontWeight: FontWeight.w500,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 0.3967136150234742 * mediaQH,
//             left: 0.06615776081424936 * mediaQW,
//             child: Container(
//               height: 0.056338028169014086 * mediaQH,
//               width: 0.8676844783715013 * mediaQW,
//               decoration: BoxDecoration(
//                   color: const Color(0xfff2f2f2),
//                   border: Border.all(color: const Color(0x00000000)),
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(6),
//                     topRight: Radius.circular(6),
//                     bottomLeft: Radius.circular(6),
//                     bottomRight: Radius.circular(6),
//                   )),
//               alignment: Alignment.center,
//             ),
//           ),
//           Positioned(
//             top: 0.4119718309859155 * mediaQH,
//             left: 0.09669211195928754 * mediaQW,
//             child: SizedBox(
//               width: 0.07888040712468193 * mediaQW,
//               child: Text(
//                 "Email",
//                 style: const TextStyle(
//                   color: Color(0xffa4a4a4),
//                   fontWeight: FontWeight.w500,
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 0.4788732394366197 * mediaQH,
//             left: 0.06615776081424936 * mediaQW,
//             child: SizedBox(
//               width: 0.8676844783715013 * mediaQW,
//               child: Text(
//                 "Username",
//                 style: const TextStyle(
//                   color: Color(0xff000000),
//                   fontWeight: FontWeight.w500,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 0.5140845070422535 * mediaQH,
//             left: 0.06615776081424936 * mediaQW,
//             child: Container(
//               height: 0.056338028169014086 * mediaQH,
//               width: 0.8676844783715013 * mediaQW,
//               decoration: BoxDecoration(
//                   color: const Color(0xfff2f2f2),
//                   border: Border.all(color: const Color(0x00000000)),
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(6),
//                     topRight: Radius.circular(6),
//                     bottomLeft: Radius.circular(6),
//                     bottomRight: Radius.circular(6),
//                   )),
//               alignment: Alignment.center,
//             ),
//           ),
//           Positioned(
//             top: 0.5293427230046949 * mediaQH,
//             left: 0.09923664122137404 * mediaQW,
//             child: SizedBox(
//               width: 0.15012722646310434 * mediaQW,
//               child: Text(
//                 "Username",
//                 style: const TextStyle(
//                   color: Color(0xffa4a4a4),
//                   fontWeight: FontWeight.w500,
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 0.596244131455399 * mediaQH,
//             left: 0.06615776081424936 * mediaQW,
//             child: SizedBox(
//               width: 0.8676844783715013 * mediaQW,
//               child: Text(
//                 "Password",
//                 style: const TextStyle(
//                   color: Color(0xff000000),
//                   fontWeight: FontWeight.w500,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 0.6314553990610329 * mediaQH,
//             left: 0.06615776081424936 * mediaQW,
//             child: Container(
//               height: 0.056338028169014086 * mediaQH,
//               width: 0.8676844783715013 * mediaQW,
//               decoration: BoxDecoration(
//                   color: const Color(0xfff2f2f2),
//                   border: Border.all(color: const Color(0x00000000)),
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(6),
//                     topRight: Radius.circular(6),
//                     bottomLeft: Radius.circular(6),
//                     bottomRight: Radius.circular(6),
//                   )),
//               alignment: Alignment.center,
//             ),
//           ),
//           Positioned(
//             top: 0.6467136150234741 * mediaQH,
//             left: 0.09669211195928754 * mediaQW,
//             child: SizedBox(
//               width: 0.11704834605597965 * mediaQW,
//               child: Text(
//                 "*******",
//                 style: const TextStyle(
//                   color: Color(0xffa4a4a4),
//                   fontWeight: FontWeight.w700,
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 0.6490610328638498 * mediaQH,
//             left: 0.8447837150127226 * mediaQW,
//             child: Image.network(
//               "https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/e1e22cd7-b8f3-4656-9049-0f27fad9b23f",
//               height: 0.022300469483568074 * mediaQH,
//               width: 0.05597964376590331 * mediaQW,
//             ),
//           ),
//           Positioned(
//             top: 0.7335680751173709 * mediaQH,
//             left: 0.06615776081424936 * mediaQW,
//             child: Container(
//               height: 0.056338028169014086 * mediaQH,
//               width: 0.8676844783715013 * mediaQW,
//               decoration: BoxDecoration(
//                   color: const Color(0xff2299c3),
//                   border: Border.all(color: const Color(0x00000000)),
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(6),
//                     topRight: Radius.circular(6),
//                     bottomLeft: Radius.circular(6),
//                     bottomRight: Radius.circular(6),
//                   )),
//               alignment: Alignment.center,
//             ),
//           ),
//           Positioned(
//             top: 0.7488262910798122 * mediaQH,
//             left: 0.42366412213740456 * mediaQW,
//             child: SizedBox(
//               width: 0.15267175572519084 * mediaQW,
//               child: Text(
//                 "Sign Up",
//                 style: const TextStyle(
//                   color: Color(0xffffffff),
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 0.8509389671361502 * mediaQH,
//             left: 0.1806615776081425 * mediaQW,
//             child: SizedBox(
//               width: 0.6412213740458015 * mediaQW,
//               child: Text(
//                 "Do you already have an account? Login here",
//                 style: const TextStyle(
//                   color: Color(0xff000000),
//                   fontWeight: FontWeight.w600,
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//           ),
//         ]),
//       ))),
//     );
//   }
// }
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pharmaciyti/auth/login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
              Center(
                child: Image.network(
                  "https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/f7f95324-8d7d-4780-b8ab-16fdce769e60",
                  height: 100,
                ),
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  "Welcome to PHARMACYTI",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text("Email", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  filled: true,
                  fillColor: Color(0xfff2f2f2),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Username", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: "Username",
                  filled: true,
                  fillColor: Color(0xfff2f2f2),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Password", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "*******",
                  filled: true,
                  fillColor: Color(0xfff2f2f2),
                  suffixIcon: Icon(Icons.visibility_off),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Sign up logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff2299c3),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.w600,
                    color: Colors.white
                    ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: RichText(
                    text: TextSpan(
                      text: "Do you already have an account? ",
                      style: const TextStyle(
                        color: Color(0xff000000),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      children: [
                        TextSpan(
                          text: "Login here",
                          style: const TextStyle(
                            color: Color(0xff2299c3),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Login(),
                                 ),
                              );
                            },
                        ),
                      ],
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
