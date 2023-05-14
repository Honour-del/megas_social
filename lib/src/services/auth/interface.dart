import 'dart:io';

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
        // required String role,
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
      {String? otp, String? password, String? password2});


  Future getUserInfo(String email);

  Future confirmOTP(String? otp);

  Future<bool?> resendOTP(String phoneNumber);

  Future<dynamic> uploadProfilePic({uid, required File url,});
}
