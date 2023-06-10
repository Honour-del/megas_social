import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/core/utils/constants/consts.dart';
import 'package:megas/core/utils/constants/uuid.dart';
import 'package:megas/main.dart';
import 'package:megas/src/models/User.dart';
import 'package:megas/src/models/post.dart';
import 'package:megas/src/services/auth/auths_impl.dart';
import 'package:megas/src/services/notification/notification_impl.dart';
import 'package:megas/src/services/profile/interface.dart';

import '../services/notification/interface.dart';

final profileControllerProvider = StateNotifierProvider.family<ProfileController, AsyncValue<UserModel>, String>((ref, id) {
  return ProfileController(ref, id);
});

final getProfile = StreamProvider.family((ref, String uid) {
  return ref.read(profileControllerProvider(uid).notifier).getProfile();
});

final getUsersPostProvider = StreamProvider.family((ref, String uid) {
    return ref.read(profileControllerProvider(uid).notifier).getUsersPosts();
 });

// TODO:
//  argument to seperate current user profile from another persons profile

class ProfileController extends StateNotifier<AsyncValue<UserModel>> {
  final Ref _read;
  final String? uid;
  ProfileController(this._read, this.uid) : super(const AsyncValue.loading()){

  }
  // {getProfile();}


  ProfileService get profileServices => _read.read(profileServiceProvider);
  /* uidk = current user's id */
  String? get  uidk => _read.watch(authProviderK).value?.uid;

  Stream<UserModel> getProfile() {
    try {
      print("UId here under get profile = $uid");
      final profile = profileServices.getProfile(uid);
      return profile;
    } on FirebaseException catch (e, _) {
      state = AsyncValue.error(e,_);
      throw e;
    }
  }

  Future<bool?> uploadImage(File file,) async {
    try {
      final uploaded = await profileServices.uploadImage(file, uidk);
      return uploaded;
    } on FirebaseException {
      return false;
    }
  }

  Future<bool?> updateProfile({Map<String, dynamic>? json,}) async {
    try {
      final uploaded = await profileServices.updateProfile(json: json, uid: uidk);
      return uploaded;
    } on FirebaseException {
      return false;
    }
  }

  Stream<List<PostModel>> getUsersPosts(){
    try {
      final posts =  profileServices.getUserPosts(id: uid);
      return posts;
    } on FirebaseException catch (E) {
      return Stream.error(E);
    }
  }

  Future<bool?> follow (owner) async {
    NotificationServiceImpl notify = NotificationServiceImpl();
    try {
      // UserModel? liker = await _read.watch(getProfile(likerId)).value;
      final follow = await profileServices.follow(uidk, uid);
      final notified = _read.read(notificationServiceProviderK);
      final userdata = _read.read(userDetailProvider).value;

      notify.sendFcmNotification(
        title: 'Follow notification',
        body: "${userdata!.name} just followed",
        token: owner!.fcm_token,
      );
      // Todo
      String notificationId = uuid.v1();
      Map<String, dynamic> toJson() {
        var data = <String, dynamic>{};
        data['notification_id'] = notificationId;
        data['body'] = handleNotification(TypeN.Follower, userdata.username);
        data['_type'] = TypeN.Follower.toString();
        data['time_at'] = dateTime;
        data['isRead'] = false;
        data['name'] = userdata.username;
        data['avatar_url'] = userdata.avatarUrl;
        return data;
      }
      await notified.sendNotification(toJson: toJson(), userToReceiveNotificationId: owner.userId);
      return follow;
    } on FirebaseException {
      return false;
    }
  }

  Future<bool?> unfollow () async {
    try {
      final follow = await profileServices.unfollow(uidk, uid);
      return follow;
    } on FirebaseException {
      return false;
    }
  }

//     Future<bool> deletePost({required String uid, required String postid}) async {
//       try {
//         await _ref?.read(createpostServiceProvider).deletePost(uId: uid, postId: postid,);
//         return true;
//         // state = AsyncValue.data(likes!);
//       } on FirebaseException catch (e, _) {
//         return false;
//         // state = AsyncValue.error([e], _);
//       }
//     }  }
}
