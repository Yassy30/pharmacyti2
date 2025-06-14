import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pharmaciyti/features/auth/view/signup.dart';
import 'package:pharmaciyti/features/auth/viewmodel/autho_viewmodel.dart';
import 'package:pharmaciyti/features/client/home/view/HomePage.dart';
import 'package:pharmaciyti/features/pharmacie/navigation/MainCont.dart';
import 'package:pharmaciyti/features/delivery/navigation/MainContainer.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    double mediaQH = MediaQuery.of(context).size.height;
    double mediaQW = MediaQuery.of(context).size.width;
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: mediaQH,
            width: mediaQW,
            child: Stack(
              children: [
                // Centered Image
                Positioned(
                  top: 0.07 * mediaQH,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset("assets/images/auth.png"),
                  ),
                ),
                // Email Label
                Positioned(
                  top: 0.36 * mediaQH,
                  left: 0.066 * mediaQW,
                  child: const Text(
                    "Email",
                    style: TextStyle(
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                // Email TextField
                Positioned(
                  top: 0.396 * mediaQH,
                  left: 0.066 * mediaQW,
                  child: SizedBox(
                    width: 0.867 * mediaQW,
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xfff2f2f2),
                        hintText: "Enter your email",
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
                      onPressed: authViewModel.isLoading
                          ? null
                          : () async {
                              final email = _emailController.text.trim();
                              final password = _passwordController.text.trim();

                              if (email.isEmpty || password.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please enter email and password')),
                                );
                                return;
                              }

                              final success = await authViewModel.login(email, password);
                              if (success) {
                                final role = await authViewModel.getUserRole();
                                if (role != null) {
                                  switch (role) {
                                    case 'client':
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) =>  HomePage()),
                                      );
                                      break;
                                    case 'pharmacy':
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) =>  MainContainer()),
                                      );
                                      break;
                                    case 'livreur':
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) =>  LivreurMainContainer()),
                                      );
                                      break;
                                    default:
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Invalid user role')),
                                      );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to fetch user role')),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(authViewModel.errorMessage ?? 'Login failed')),
                                );
                              }
                            },
                      child: authViewModel.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
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
                    "Or login with",
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
                  child: GestureDetector(
                    onTap: () async {
                      try {
                        await Supabase.instance.client.auth.signInWithOAuth(
                          OAuthProvider.google,
                          redirectTo: 'io.supabase.flutter://',
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Google sign-in failed: $e')),
                        );
                      }
                    },
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
                                MaterialPageRoute(builder: (context) => const SignUp()),
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