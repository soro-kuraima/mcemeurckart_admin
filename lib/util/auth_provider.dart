import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mcemeurckart_admin/screens/auth_screen/signin_screen.dart';
import 'package:mcemeurckart_admin/screens/base_screen/base_screen.dart';

class AuthProvider extends StatelessWidget {
  const AuthProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print('homescreen');
              return const BaseScreen();
            } else {
              print('Login Screen');
              return const SignInScreen();
            }
          }),
    );
  }
}
