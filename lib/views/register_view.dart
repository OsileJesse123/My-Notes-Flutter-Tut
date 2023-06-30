import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/firebase_options.dart';

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
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: Colors.deepPurple,
        ),
        body: FutureBuilder(
          future: Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform
                ),
          builder: (context, snapshot) {
            switch(snapshot.connectionState){
              case ConnectionState.done:
                return Column(
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
                        print("The User Credential: $userCredential");
                      } on FirebaseAuthException catch (e){
                        if(e.code == 'weak-password'){
                          print('Weak password');
                        } else if(e.code == 'email-already-in-use'){
                          print('email is already in use');
                        } else if(e.code == 'invalid-email'){
                          print('this is an invalid email');
                        }
                      }
                      
                    }, child: const Text("Register")),
                  ],
                );
              default:
                return const Text("Loading...");        
            }
          },
        ),
    );
  }
}
