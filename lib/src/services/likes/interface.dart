import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/src/models/User.dart';
import 'package:megas/src/services/api_client.dart';
import 'package:megas/src/services/likes/likes_impl.dart';
// import 'package:social_media/logger.dart';

// import '../logger.dart';

final likesUpdateServicesProvider = Provider<UpdateLikes>((ref) {
  return UpdateLikes();
});
abstract class UpdateLikes {

  factory UpdateLikes()=> UpdateLikesImpl();

  ///update likes on every clicks
  Future<void> addLike({required String postid, required String likerid, bool? liked});

  // Future<void> removelike({required String postid, required String likerid});

  // Stream<QuerySnapshot>
  getLikes({required String postid});

}