import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


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
              print("The User Credential: $userCredential");
            } on FirebaseAuthException catch (e){
              if(e.code == 'user-not-found'){
                print("User not found");
              } else if(e.code == 'wrong-password'){
                print("Wrong password");
              }
            } 
          }, child: const Text("Login")),
          TextButton(onPressed: (){
            Navigator.of(context).pushNamedAndRemoveUntil('/register/', (route) => false);
          }, child: const Text("Not Registered Yet? Register here!"))
        ],
      ),
    );
  }

}