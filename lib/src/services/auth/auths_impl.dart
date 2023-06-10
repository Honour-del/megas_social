import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/core/references/firestore.dart';
import 'package:megas/core/utils/constants/consts.dart';
import 'package:megas/main.dart';
import 'package:megas/src/models/User.dart';
import 'package:megas/src/services/auth/interface.dart';
import 'package:megas/src/services/posts/posts_impl.dart';
import 'package:megas/src/services/shared_prefernces.dart';


final authProviderK = StreamProvider<User?>((ref) {
  final AuthServiceImpl _serviceImpl = AuthServiceImpl();
  return _serviceImpl.authStateChange;
});
// final authProviderK = FutureProvider<User?>((ref) async{
//   return FirebaseAuth.instance.authStateChanges().first;
// });

/* This returns the every details of the user from firebase */
final userDetailProvider = StreamProvider<UserModel?>((ref) {
  String? uid = ref.watch(authProviderK).value?.uid;
  final data = usersRef.doc(uid!).snapshots().map((event) => UserModel.fromJson(event.data() as Map<String, dynamic>));
  print('getting user details from the backend');
  return data;
});



// final userDetailProvider = FutureProvider<UserModel?>((ref) async{
//   String? uid = ref.watch(authProviderK).value?.uid;
//   // final uid = FirebaseAuth.instance.currentUser?.uid;
//   // this was returning type 'Null'  is not subtype of Map<String, dynamic>
//   final data = await usersRef.doc(uid!).get();
//   // if(data.exists)
//   print('getting user details from the backend');
//   // data.data();
//   print('User details is parsed into json');
//   UserModel userData = UserModel.fromJson(data.data()!);
//   print('____${userData.username}____');
//   return userData;
// });

class AuthServiceImpl implements AuthService {
   final FirebaseAuth _auth = FirebaseAuth.instance;
   final Preferences? _prefs = Preferences();
  String verificationId ='';
  String? userId;

  Stream<User?> get authStateChange => _auth.authStateChanges();
  // authStateChanges() => _auth.authStateChanges().listen((user) {
  //   if(user != null){
  //     userId = user.uid;
  //   }else {
  //     userId = null;
  //   }
  // });
  // User? get currentUser => _auth.currentUser;
  User? currentUser;

   CreatePostImpl impl = CreatePostImpl();
  // dynamic my;
  @override
  Future register({required String email, required String name, required String password, required url}) async{
    // TODO: implement register
    try{
       // final creator =
       await _auth.createUserWithEmailAndPassword(email: email, password: password);
       currentUser = _auth.currentUser;
      print("saving user info");
      print("save0");
      /* Save user info after a new user is created */
      // await creator.user?.sendEmailVerification();
      final data = await _saveUser(currentUser?.uid, name, url, email);
      print("save1");
      return data;
    } catch (e){
      print(e.toString());
      throw e;
    }
  }


  /* Save user info as soon as they successfully registered */
  Future _saveUser(uid, name, url, email) async{
    try{
      if(currentUser == null) return null;
      print('The error is here 1');
      String download = await impl.uploadImage(file: url, uid: uid, directoryName: 'userProfile',);
      // String? email = currentUser!.email;
      // String username = '@${email.split('@')[0]}';
      String username = await getUsername(id: currentUser!.uid, name: name);
      Map<String, dynamic> toJson() {
        final data = <String, dynamic>{};
        data['id'] = currentUser!.uid;
        data['username'] = username;
        data['name'] = name;
        data['email'] = email;
        data['bio'] = 'Edit profile to update your bio';
        data['avatar_url'] = download;
        data['followers_count'] = [];
        data['following_count'] = [];
        data['posts_count'] = [];
        data['created_at'] = dateTime;
        data['fcm_token'] = '';
        return data;
      }
      /* [uid] of the reference is the id of the registered user */
      await usersRef.doc(uid).set(
        toJson()
      );
    } catch (e){
      print("Error saving user data: $e");
      throw e;
    }
  }


  /* get User data from backend after login */
  Future getUserInfo(String email) async{
    QuerySnapshot snap = await usersRef.where('email', isEqualTo: email).get();
    return snap;
  }

  @override
  Future attemptLogIn(String email, String password) async{
    // TODO: implement attemptLogIn
    try{
      final logins =  await _auth.signInWithEmailAndPassword(email: email, password: password);
      // currentUser = logins.user;
      print("UID: ${logins.user!.uid}");
      await _prefs?.setToken(logins.user!.uid);
      print('done');
      return Right(logins);
    }catch (e){
      print("error: $e");
      throw e;
    }
  }


  /* Confirm otp */
  @override
  Future confirmOTP(String? otp) async{
    // TODO: implement confirmOTP
    if(otp==null || otp=='') return null;
      try{
        final AuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId,
            smsCode: otp);
        final user = await _auth.signInWithCredential(credential);
        assert(user.user!.uid == currentUser!.uid);
      } catch (e){

      }
  }

  /* Forget password function */
  @override
  Future<Map<String, dynamic>?> forgetPassword(String email) async{
    // TODO: implement forgetPassword
    try{
      _auth.sendPasswordResetEmail(email: email);
    } catch (e){
      throw e;
    }
    return null;
  }


  /* Logout and delete uid/token from local preferences */
  @override
  Future<bool?> logout() async{
    // TODO: implement logout
    await _auth.signOut();
    _prefs?.deleteToken();
    return true;
  }


  /* Request for otp */
  @override
  Future<bool?> resendOTP(String phoneNumber) async{
    // TODO: implement resendOTP
    final smsOTPSent = (String verId, [int? forceCodeResend]){
      verificationId = verId;
    };
    await  _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential){},
        verificationFailed: (FirebaseAuthException e){throw e.toString();},
        codeSent: smsOTPSent,
        timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout:  (String ok){
        verificationId = ok;
        resendOTP(verificationId);
      });
    return true;
  }

  @override
  Future<bool?> resetPassword({String? email, String? password, String? password2}) async{
    // TODO: implement resetPassword
    try{
      await _auth.sendPasswordResetEmail(email: email!);
      return true;
    } on FirebaseAuthException catch (e){
      throw e;
    }
  }

  @override
  Future<void> refreshToken() {
    // TODO: implement refreshToken
    throw UnimplementedError();
  }

  @override
  Future uploadProfilePic({uid,required File url,}) async{
    try{
      // var postId = uuid.v1();
      String download = await impl.uploadImage(file: url, uid: uid, directoryName: 'userProfile',);
      await usersRef.doc(uid).update({
        'avatar_url' : download
      });
      return download;
    } on FirebaseException catch (e){
      throw e;
    }
  }

  @override
  Future resendVerificationEmail(User user) async{
    // TODO: implement verifyEmail
    try{
      await user.sendEmailVerification();
    } on FirebaseAuthException catch(e){
      throw e;
    }
  }

  @override
  Future<bool> verificationCheck(User user) async{
    // TODO: implement verificationCheck
    try{
      await user.reload();
      await user.getIdToken(true);
      await user.reload();
      var flag = user.emailVerified;
      return flag;
    } on FirebaseAuthException catch(e){
      throw e;
    }
  }

  @override
  Future<bool> checkVerification(User user) async{
    // TODO: implement checkVerification
    try{
      return user.emailVerified;
    } on FirebaseAuthException catch(e){
      throw e;
    }
  }
}
