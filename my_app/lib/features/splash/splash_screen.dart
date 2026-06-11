import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {

const SplashScreen({super.key});

@override
State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

@override
void initState() {
super.initState();
Future.delayed(const Duration(seconds: 3), () {

  if (mounted) {

    context.go('/onboarding');

  }

});
}

@override
Widget build(BuildContext context) {
return Scaffold(

  body: Container(

    width: double.infinity,

    decoration: const BoxDecoration(

      gradient: LinearGradient(

        begin: Alignment.topLeft,
        end: Alignment.bottomRight,

        colors: [
          Color(0xFF2F6BFF),
          Color(0xFF17C6E5),
        ],
      ),
    ),

    child: const Column(

      mainAxisAlignment: MainAxisAlignment.center,

      children: [

        Icon(
          Icons.health_and_safety,
          size: 120,
          color: Colors.white,
        ),

        SizedBox(height: 30),

        Text(

          "Oral Diet",

          style: TextStyle(
            color: Colors.white,
            fontSize: 38,
            fontWeight: FontWeight.bold,
          ),
        ),

      ],
    ),
  ),
);
}
}
