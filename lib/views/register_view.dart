import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/constants/routes.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register"),
      titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 25.0
        ),
        backgroundColor: Colors.deepPurple,
        ),
      body: Column(
        children: [
          TextField(controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: "Enter your email"),
          ),
          TextField(controller: _password,
            obscureText: true,
            decoration: const InputDecoration(hintText: "Enter your password"),
            enableSuggestions: false,
            autocorrect: false,
          ),
          TextButton(onPressed: () async{
            final email = _email;
            final password = _password;
            try {
              final userCredential = 
              await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email.text, password: password.text);
              devtools.log("The User Credential: $userCredential");
            } on FirebaseAuthException catch (e){
              if(e.code == 'weak-password'){
                devtools.log('Weak password');
              } else if(e.code == 'email-already-in-use'){
                devtools.log('email is already in use');
              } else if(e.code == 'invalid-email'){
                devtools.log('this is an invalid email');
              }
            }
            
          }, child: const Text("Register")),
          TextButton(onPressed: (){
            Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false);
          }, child: const Text('Already Registered? Login here!'))
        ],
      ),
    );
  }
}

