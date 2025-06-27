import 'package:flutter/material.dart';
import 'package:pharmaciyti/features/client/profile/view/profile_client.dart';
import 'package:provider/provider.dart';
import 'package:pharmaciyti/features/auth/viewmodel/user_viewmodel.dart';
import 'package:pharmaciyti/features/client/home/view/homepage.dart';

class Congratulations extends StatelessWidget {
  const Congratulations({super.key});

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    double mediaQH = MediaQuery.of(context).size.height;
    double mediaQW = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => false, // Disable back button
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
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
                          const Text(
                            "Congratulations",
                            style: TextStyle(
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Your account has been created!",
                            style: TextStyle(
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
                    child: GestureDetector(
                      onTap: () async {
                        if (userViewModel.isLoading) return;

                        final isComplete = await userViewModel.isProfileComplete();
                        if (isComplete) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) =>  HomePage()),
                          );
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) =>  ProfilePage()),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please complete your profile')),
                          );
                        }
                      },
                      child: Container(
                        height: 0.056338028169014086 * mediaQH,
                        decoration: BoxDecoration(
                          color: const Color(0xff2299c3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        alignment: Alignment.center,
                        child: userViewModel.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Done",
                                style: TextStyle(
                                  color: Color(0xffffffff),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}