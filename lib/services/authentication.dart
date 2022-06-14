import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _showErrorMessage(String message, BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error Occurred!'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Okay'),
          ),
        ],
      ),
    );
  }

  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  Future<User?> signIn(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      var errMessage = 'Authentication failed';
      switch (e.code) {
        case 'invalid-email':
          errMessage = 'This is not valid email address';
          break;
        case 'user-disabled':
          errMessage =
              'user corresponding to the given email has been disabled';
          break;
        case 'user-not-found':
          errMessage = 'could not find a user with that email';
          break;
        case 'wrong-password':
          errMessage = 'Invalid password';
          break;
      }
      _showErrorMessage(errMessage, context);
      return null;
    } catch (e) {
      const errMessage = 'couldn\'t authenticate you. Please try again later';
      _showErrorMessage(errMessage, context);
      return null;
    }
  }

  Future<User?> signUp(String email, String password, context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      var errMessage = 'Authentication failed';
      switch (e.code) {
        case 'invalid-email':
          errMessage = 'This is not valid email address';
          break;
        case 'email-already-in-use':
          errMessage = 'This email address is already in use';
          break;
        case 'operation-not-allowed':
          errMessage = 'account are not enabled';
          break;
        case 'weak-password':
          errMessage = 'The password is not strong enough';
          break;
      }
      _showErrorMessage(errMessage, context);
      return null;
    } catch (e) {
      const errMessage = 'couldn\'t authenticate you. Please try again later';
      _showErrorMessage(errMessage, context);
      return null;
    }
  }

  void resetPassword(String email) {
    try {
      _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
