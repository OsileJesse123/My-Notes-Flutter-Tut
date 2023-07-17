import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

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
               await AuthService.firebase()
              .createUser(email: email.text, password: password.text);
              final user = AuthService.firebase().currentUser;
              await AuthService.firebase().sendEmailVerification();
              Navigator.of(context).pushNamed(verifyEmailRoute,);
            }
            on WeakPasswordAuthException {
              await showErrorDialog(context, "Weak Password");
            }
            on EmailAlreadyInUseAuthException {
              await showErrorDialog(context, "Email is already in use");
            }
            on InvalidEmailAuthException {
              await showErrorDialog(context, "This is an invalid email");
            }
            on GenericAuthException {
              await showErrorDialog(context, "Registration Error");
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

