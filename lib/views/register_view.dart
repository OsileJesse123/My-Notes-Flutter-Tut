import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';

import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_state.dart';
import '../utilities/dialogs/error_dialog.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async{
        if(state is AuthStateRegistering){
          if(state.exception is WeakPasswordAuthException){
            await showErrorDialog(context, "Weak password");
          } else if(state.exception is EmailAlreadyInUseAuthException){
            await showErrorDialog(context, "Email is already in use");
          } else if(state.exception is InvalidEmailAuthException){
            await showErrorDialog(context, "This is an invalid email");
          } else if(state.exception is GenericAuthException){
            await showErrorDialog(context, "Registration Error");
          }
        } 
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Register"),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 25.0),
          backgroundColor: Colors.deepPurple,
        ),
        body: Column(
          children: [
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: "Enter your email"),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              decoration:
                  const InputDecoration(hintText: "Enter your password"),
              enableSuggestions: false,
              autocorrect: false,
            ),
            TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  context.read<AuthBloc>().add(AuthEventRegister(email: email, password: password));
                },
                child: const Text("Register")),
            TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(AuthEventLogOut());
                },
                child: const Text('Already Registered? Login here!'))
          ],
        ),
      ),
    );
  }
}
