import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pharmaciyti/features/auth/view/login.dart';
import 'package:pharmaciyti/features/client/congratulation/congratulations.dart';
import 'package:pharmaciyti/features/onboarding/whoareu.dart';

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
              child: Image.asset("assets/images/auth.png"),
              ),
              const SizedBox(height: 24),
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
                  Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const WhoAreYou(),
                                 ),
                              );
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
