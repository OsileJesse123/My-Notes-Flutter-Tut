import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import '../services/auth/bloc/auth_state.dart';
import '../utilities/dialogs/error_dialog.dart';
import '../utilities/dialogs/loading_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  CloseDialog? _closeDialogHandle;

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {


          final closeDialog = _closeDialogHandle;

          if(!state.isLoading && closeDialog != null){
            closeDialog();
            _closeDialogHandle = null;
          } else if(state.isLoading && closeDialog == null){
            _closeDialogHandle = showLoadingDialog(
              context: context, 
              text: "Loading...",);
          }


          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, 'User not found');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Wrong credentials');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication Error');
          }
        }
        if(state is AuthStateLoggedIn){
          final closeDialog = _closeDialogHandle;
          if(closeDialog != null){
            closeDialog();
            _closeDialogHandle = null;
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
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
                context
                    .read<AuthBloc>()
                    .add(AuthEventLogIn(_email.text, _password.text));
              },
              child: const Text("Login"),
            ),
            TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventShouldRegister());
                },
                child: const Text("Not Registered Yet? Register here!"))
          ],
        ),
      ),
    );
  }
}
