import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger_by_qwilton/services/auth/login_or_register.dart';
import 'package:messenger_by_qwilton/pages/home_page.dart';

class AuthGate extends StatelessWidget {
    const AuthGate({super.key});
    
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(), 
                builder: (context, snapshot) {
                    // чео залогинен
                    if (snapshot.hasData) {
                        return const HomePage();
                    }
                    else {
                        return const LoginOrRegister();
                    }
                }
            )
        );
    }
}
