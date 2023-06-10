import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/src/services/auth/auths_impl.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

abstract class AuthService {

  factory AuthService ()=> AuthServiceImpl();

  Future register(
      {required String email,
        required String name,
        required  url,
        required String password,
      });


  Future<void> refreshToken();

  ////to check if the data already exist then login
  Future attemptLogIn(
      String email, String password);

  /// logout and refresh the token
  Future<bool?> logout();

  ///forget password
  Future<Map<String, dynamic>?> forgetPassword(String email);

  Future<bool?> resetPassword(
      {String? email, String? password, String? password2});


  Future getUserInfo(String email);

  Future confirmOTP(String? otp);

  Future resendVerificationEmail(User user);

  Future<bool> verificationCheck(User user);

  Future<bool> checkVerification(User user);

  Future<bool?> resendOTP(String phoneNumber);

  Future<dynamic> uploadProfilePic({uid, required File url,});
}
