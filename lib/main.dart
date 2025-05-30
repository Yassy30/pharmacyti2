import 'package:flutter/material.dart';
import 'package:pharmaciyti/features/auth/view/login.dart';
import 'package:pharmaciyti/features/auth/view/signup.dart';
import 'package:pharmaciyti/features/client/home/view/HomePage.dart';
import 'package:pharmaciyti/features/delivery/profile/view/InfosLiv.dart';
import 'package:pharmaciyti/features/delivery/navigation/MainContainer.dart';
import 'package:pharmaciyti/features/onboarding/onboarding1.dart';
import 'package:pharmaciyti/features/onboarding/onboarding2.dart';
import 'package:pharmaciyti/features/onboarding/onboarding3.dart';
import 'package:pharmaciyti/features/onboarding/onboarding_wrapper.dart';
import 'package:pharmaciyti/features/onboarding/whoareu.dart';
import 'package:pharmaciyti/features/pharmacie/profil/view/Infosph.dart';
import 'package:pharmaciyti/features/pharmacie/navigation/MainCont.dart';
import 'package:pharmaciyti/features/pharmacie/orders/view/order_screens.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );
  print(dotenv.env['SUPABASE_URL']);
  print(dotenv.env['SUPABASE_ANON_KEY']);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pharmacyti',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      
      debugShowCheckedModeBanner: false,
      home:  MainContainer(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
          ],
        ),
      ),
    );
  }
}
