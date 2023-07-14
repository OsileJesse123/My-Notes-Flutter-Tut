import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:mynotes/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider{

  final AuthProvider authProvider;

  const AuthService(this.authProvider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({required String email, required String password}) {
    return authProvider.createUser(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => authProvider.currentUser;

  @override
  Future<void> logOut() {
    return authProvider.logOut();
  }

  @override
  Future<AuthUser> login({required String email, required String password}) {
    return authProvider.login(email: email, password: password);
  }

  @override
  Future<void> sendEmailVerification() {
    return authProvider.sendEmailVerification();
  }
  
  @override
  Future<void> initialize() => authProvider.initialize();

}