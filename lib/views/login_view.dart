import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import '../utilities/dialogs/error_dialog.dart';


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
              await AuthService.firebase()
              .login(email: email.text, password: password.text);
              final user = AuthService.firebase().currentUser;
              if(user?.isEmailVerified ?? false){
                 Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (_) => false,);
              }else {
                 Navigator.of(context).pushNamedAndRemoveUntil(verifyEmailRoute, (_) => false,);
              }
            } on UserNotFoundAuthException {
              await showErrorDialog(context, "User not found");
            } on WrongPasswordAuthException {
              await showErrorDialog(context, "Wrong credentials");
            } on GenericAuthException {
              await showErrorDialog(context, "Authentication Error");
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

