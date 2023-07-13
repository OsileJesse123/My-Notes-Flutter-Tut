import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException, FirebaseAuth;
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';

class FirebaseAuthProvider implements AuthProvider{
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,}) async{
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      final user = currentUser;
      if(user != null){
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    }
    on FirebaseAuthException catch(e){
      if(e.code == 'weak-password'){
        throw WeakPasswordAuthException();    
      } else if(e.code == 'email-already-in-use'){
        throw EmailAlreadyInUseAuthException(); 
      } else if(e.code == 'invalid-email'){
        throw InvalidEmailAuthException();        
      } else {
        throw GenericAuthException();        
      }
    }
    catch(_){
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if(user != null){
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<void> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }

  @override
  Future<AuthUser> login({required String email, required String password}) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<void> sendEmailVerification() {
    // TODO: implement sendEmailVerification
    throw UnimplementedError();
  }
  
}
