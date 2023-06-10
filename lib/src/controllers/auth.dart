import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth/interface.dart';



final authControllerProvider = StateNotifierProvider<AuthController, dynamic>(
      (ref) => AuthController(read: ref),/////
);

class AuthController extends StateNotifier{
  final Ref read;
  AuthController({
    required this.read
  }) : super(null);

  FutureOr<Either<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    required photoUrl,
  }) async {
    try {
      dynamic status = await read.read(authServiceProvider).register(
        email: email,
        password: password,
        name: name,
        url: photoUrl
      );
      return Right(status);
    } on FirebaseException catch (e) {
      return Left(e.message!);
    }

  }


  Future getUserInfo(String email) async{
    try{
      dynamic status = await read.read(authServiceProvider).getUserInfo(email);
      return Right(status);
    } on FirebaseException catch (e){
      return Left(e.message);
    }
  }

  FutureOr<bool?> resendOTP(String phoneNumber) async {
    try {
      bool? status = await read.read(authServiceProvider).resendOTP(phoneNumber);
      return status;
    } on FirebaseException {
      return false;
    }
  }

  FutureOr confirmOTP(String? otp) async {
    try {
      dynamic status = await read.read(authServiceProvider).confirmOTP(otp);
      return Right(status);
    }on FirebaseException catch (e) {
      return Left(e.message!);
    }
  }

  FutureOr login(
      String email, String password) async {
    try {
      final response = await read.read(authServiceProvider).attemptLogIn(
        email,
        password,
      );
      return response;
    } on FirebaseException catch (e) {
      return Left(e.message);
    }
  }

  FutureOr uploadProfilePic(
      File url, uid) async {
    try {
      final response = await read.read(authServiceProvider).uploadProfilePic(url: url, uid: uid);
      return response;
    } on FirebaseException catch (e) {
      return Left(e.message);
    }
  }


  Future forgetPassword(String email) async {
    try {
      final Map<String, dynamic>? response =
      await read.read(authServiceProvider).forgetPassword(email);
      return response;
    } on FirebaseException catch (e) {
      throw e.message!;
    }
  }



  Future<bool?> resetPassword(
      {String? email, String? password, String? password2}) async {
    try {
      final passwordChanged = await read.read(authServiceProvider)
          .resetPassword(email: email, password: password, password2: password2);
      return passwordChanged;
    } on FirebaseException {
      return false;
    }
  }

  Future resendVerificationEmail(User user) async{
    try {
      final bool? resend = await read.read(authServiceProvider).resendVerificationEmail(user);
      return resend;
    } on FirebaseException {
      return false;
    }
  }
  Future<bool> verificationCheck(User user)async{
    try {
      final bool? verificationCheck = await read.read(authServiceProvider).verificationCheck(user);
      return verificationCheck!;
    } on FirebaseException {
      return false;
    }
  }

  Future<bool> checkVerification(User user)async{
    try {
      final bool? checkVerification = await read.read(authServiceProvider).checkVerification(user);
      return checkVerification!;
    } on FirebaseException {
      return false;
    }
  }

  Future<bool?> logout() async {
    try {
      final bool? loggedOut = await read.read(authServiceProvider).logout();
      return loggedOut;
    } on FirebaseException {
      return false;
    }
  }
}

final filesProvider =
StateNotifierProvider<Files, List<File?>>((ref) => Files());

class Files extends StateNotifier<List<File?>> {
  Files() : super([]);

  addFile(File? file, int id) {
    if (id == 1) {
      state = [file, ...state].toList();
    } else {
      state = [...state, file].toList();
    }
  }
}
