import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pharmaciyti/auth/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    double mediaQH = MediaQuery.of(context).size.height;
    double mediaQW = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: mediaQH,
            width: mediaQW,
            child: Stack(
              children: [
                Positioned(
                  top: 0.10446009389671361 * mediaQH,
                  left: 0.356234096692112 * mediaQW,
                  child: Image.network(
                    "https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/1db8bd93-ea72-4e0d-893f-58ee79cdd9c6",
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
                      "   Welcome to  PHARMACYTI",
                      style: const TextStyle(
                        color: Color(0xff000000),
                        fontWeight: FontWeight.w900,
                        fontSize: 26,
                      ),
                    ),
                  ),
                ),
                // Username Label
                Positioned(
                  top: 0.36 * mediaQH,
                  left: 0.066 * mediaQW,
                  child: const Text(
                    "Username",
                    style: TextStyle(
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                // Username TextField
                Positioned(
                  top: 0.396 * mediaQH,
                  left: 0.066 * mediaQW,
                  child: SizedBox(
                    width: 0.867 * mediaQW,
                    child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xfff2f2f2),
                        hintText: "Enter your username",
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                // Password Label
                Positioned(
                  top: 0.478 * mediaQH,
                  left: 0.066 * mediaQW,
                  child: const Text(
                    "Password",
                    style: TextStyle(
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),

                // Password TextField
                Positioned(
                  top: 0.514 * mediaQH,
                  left: 0.066 * mediaQW,
                  child: SizedBox(
                    width: 0.867 * mediaQW,
                    child: TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xfff2f2f2),
                        hintText: "Enter your password",
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                // Forgot Password
                Positioned(
                  top: 0.577 * mediaQH,
                  left: 0.066 * mediaQW,
                  child: const Text(
                    "Forgot password?",
                    style: TextStyle(
                      color: Color(0xff2299c3),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),

                // Login Button
                Positioned(
                  top: 0.633 * mediaQH,
                  left: 0.066 * mediaQW,
                  child: SizedBox(
                    width: 0.867 * mediaQW,
                    height: 0.056 * mediaQH,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff2299c3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: () {
                        // Handle login logic here
                        String username = _usernameController.text;
                        String password = _passwordController.text;
                        print('Username: $username');
                        print('Password: $password');
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),

                // Or login with
                Positioned(
                  top: 0.735 * mediaQH,
                  left: 0.389 * mediaQW,
                  child: const Text(
                    "Or  login  with",
                    style: TextStyle(
                      color: Color(0xffa4a4a4),
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ),

                // Google Button
                Positioned(
                  top: 0.796 * mediaQH,
                  left: 0.066 * mediaQW,
                  child: Container(
                    width: 0.867 * mediaQW,
                    height: 0.056 * mediaQH,
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      border: Border.all(color: const Color(0xffe7e7e7)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          "https://img.icons8.com/color/48/000000/google-logo.png",
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Google",
                          style: TextStyle(
                            color: Color(0xffa4a4a4),
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0.9014084507042254 * mediaQH,
                  left: 0.2010178117048346 * mediaQW,
                  child: RichText(
                    text: TextSpan(
                      text: "Don’t have an account yet? ",
                      style: const TextStyle(
                        color: Color(0xff000000),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      children: [
                        TextSpan(
                          text: "Register here",
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
                                  builder: (context) => const SignUp(),
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
      ),
    );
  }
}
