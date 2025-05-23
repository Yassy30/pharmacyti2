import 'package:flutter/material.dart';
import 'package:pharmaciyti/auth/login.dart';
import 'package:pharmaciyti/auth/signup.dart';
import 'package:pharmaciyti/client/HomePage.dart';
import 'package:pharmaciyti/livreur/InfosLiv.dart';
import 'package:pharmaciyti/livreur/MainContainer.dart';
import 'package:pharmaciyti/onboarding/onboarding1.dart';
import 'package:pharmaciyti/onboarding/onboarding2.dart';
import 'package:pharmaciyti/onboarding/onboarding3.dart';
import 'package:pharmaciyti/onboarding/onboarding_wrapper.dart';
import 'package:pharmaciyti/onboarding/whoareu.dart';
import 'package:pharmaciyti/pharmacie/Infosph.dart';
import 'package:pharmaciyti/pharmacie/MainCont.dart';
import 'package:pharmaciyti/pharmacie/order_screens.dart';

void main() {
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
      home:  HomePage(),
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
