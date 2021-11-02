import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../shared/auth/auth_controller.dart';
import '../../shared/models/user_model.dart';

class LoginController {
  final authController = AuthController();
  Future<void> googleSignIn(BuildContext context) async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
      ],
    );
    try {
      final response = await _googleSignIn.signIn();
      final user =
          UserModel(name: response!.displayName!, photoURL: response.photoUrl);
      // ignore: avoid_print
      print(response);
      authController.setUser(context, user);
    } catch (error) {
      authController.setUser(context, null);
      // ignore: avoid_print
      print(error);
    }
  }
}
