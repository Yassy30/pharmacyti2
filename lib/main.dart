import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pharmaciyti/features/client/home/viewmodel/home_viewmodel.dart';
import 'package:pharmaciyti/features/client/search/viewmodel/search_viewmodel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pharmaciyti/features/auth/view/login.dart';
import 'package:pharmaciyti/features/auth/viewmodel/autho_viewmodel.dart';
import 'package:pharmaciyti/features/auth/viewmodel/user_viewmodel.dart';
import 'package:pharmaciyti/features/pharmacie/inventory/viewmodel/category_viewmodel.dart';
import 'package:pharmaciyti/features/pharmacie/inventory/viewmodel/medicine_viewmodel.dart';
import 'package:pharmaciyti/features/client/home/view/HomePage.dart';
import 'package:pharmaciyti/features/pharmacie/navigation/MainCont.dart';
import 'package:pharmaciyti/features/delivery/navigation/MainContainer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // Auth state listener
  Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
    final user = data.session?.user;
    if (user != null) {
      final exists = await Supabase.instance.client
          .from('User')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (exists == null) {
        await Supabase.instance.client.from('User').insert({
          'id': user.id,
          'email': user.email,
          'full_name': user.userMetadata?['full_name'] ?? 'Google User',
          'role': 'client',
        });
      }
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => CategoryViewModel()..fetchCategories()),
        ChangeNotifierProvider(create: (_) => MedicineViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pharmacy App',
        theme: ThemeData(primarySwatch: Colors.green),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    return FutureBuilder<String?>(
      future: authViewModel.getUserRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final role = snapshot.data;
        if (role == null) {
          return const Login();
        }

        switch (role) {
          case 'client':
            return const HomePage();
          case 'pharmacy':
            return  MainContainer();
          case 'livreur':
            return  LivreurMainContainer();
          default:
            return const Login();
        }
      },
    );
  }
}