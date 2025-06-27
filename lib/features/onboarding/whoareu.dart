import 'package:flutter/material.dart';
import 'package:pharmaciyti/features/client/profile/view/profile_client.dart';
import 'package:provider/provider.dart';
import 'package:pharmaciyti/features/auth/viewmodel/autho_viewmodel.dart';
import 'package:pharmaciyti/features/delivery/profile/view/infosliv.dart';
import 'package:pharmaciyti/features/pharmacie/profil/view/infosph.dart';

class WhoAreYou extends StatelessWidget {
  const WhoAreYou({super.key});

  Future<void> _handleRoleSelection(BuildContext context, String roleName, Widget profilePage) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    final success = await authViewModel.updateUserRole(roleName);
    if (success) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => profilePage));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authViewModel.errorMessage ?? 'Failed to set role. Please try again.'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center( // Center the entire content
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Who Are You?',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Please select your role to continue',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: authViewModel.isLoading
                      ? null
                      : () => _handleRoleSelection(context, 'client',  ProfilePage()),
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xff2299c3),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/client.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: authViewModel.isLoading
                            ? const Center(child: CircularProgressIndicator(color: Color(0xff2299c3)))
                            : null,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Client',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xff2299c3)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: authViewModel.isLoading
                      ? null
                      : () => _handleRoleSelection(context, 'pharmacy', const Infosph()),
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.green,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/pharmacie.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: authViewModel.isLoading
                            ? const Center(child: CircularProgressIndicator(color: Colors.green))
                            : null,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Pharmacy',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: authViewModel.isLoading
                      ? null
                      : () => _handleRoleSelection(context, 'livreur', const InfosLiv()),
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.orange,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/liv.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: authViewModel.isLoading
                            ? const Center(child: CircularProgressIndicator(color: Colors.orange))
                            : null,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Delivery',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.orange),
                      ),
                    ],
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