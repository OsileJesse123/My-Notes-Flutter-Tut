import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/constants/routes.dart';

import '../utilities/show_error_dialog.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();

}

class _LoginViewState extends State<LoginView> {

  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login"),
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
            try {
              final email = _email;
              final password = _password;
              final userCredential = 
              await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email.text, password: password.text);
              Navigator.of(context).pushNamedAndRemoveUntil(
                notesRoute,
                 (_) => false,);
            } on FirebaseAuthException catch (e){
              if(e.code == 'user-not-found'){
                await showErrorDialog(context, "User not found");
              } else if(e.code == 'wrong-password'){
                await showErrorDialog(context, "Wrong credentials");
              } else {
                await showErrorDialog(context, "Error: ${e.code}");
              }
            } catch(e){

            } 
          }, child: const Text("Login")),
          TextButton(onPressed: (){
            Navigator.of(context).pushNamedAndRemoveUntil(
              registerRoute,
               (route) => false,);
          }, child: const Text("Not Registered Yet? Register here!"))
        ],
      ),
    );
  }

}

