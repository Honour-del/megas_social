
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/src/models/User.dart';
import 'package:megas/src/models/post.dart';
import 'package:megas/src/services/profile/profile_impl.dart';

final profileServiceProvider = Provider((ref) {
  return ProfileService();
});


abstract class ProfileService {

  factory ProfileService()=> ProfileServiceImpl();

  Stream<UserModel> getProfile(uid);

  Stream<List<PostModel>> getUserPosts({String? id});

  Future follow(uid, userIdToFollow);
  Future unfollow(uid, userIdToUnfollow);

  Future<bool?> uploadImage(File file, uid);

  Future<bool?> updateProfile({Map<String, dynamic>? json, uid});
}