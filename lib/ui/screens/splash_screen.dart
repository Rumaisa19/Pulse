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
    // Logic: Artificial delay for branding, then move to Home
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) context.go('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.newspaper, size: 80, color: Colors.deepPurple),
            SizedBox(height: 20),
            Text(
              "CHRONICLE",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator.adaptive(),
          ],
        ),
      ),
    );
  }
}
