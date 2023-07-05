import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text("Verify Email"),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 25.0
        ),
        backgroundColor: Colors.purple,
      ),
      body: Column(children: [
           const Text("Please Verify your email address"),
            TextButton(onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              devtools.log("The User: $user");
              //await user?.sendEmailVerification();
            }, child: const Text("Send email verification"))
        ],),
    );
    
  }
}