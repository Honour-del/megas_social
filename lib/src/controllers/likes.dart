//
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:megas/core/utils/constants/exceptions.dart';
// import 'package:megas/src/controllers/notification.dart';
// import 'package:megas/src/models/notification.dart';
// import 'package:megas/src/services/auth/auths_impl.dart';
//
// import '../services/likes/interface.dart';
//
//
// // var postID;
// final likesProvider = StateNotifierProvider.family.autoDispose((ref,String? postid) {
//   final uid = ref.watch(authProviderK).value?.uid;
//   return LikesController(ref, postid, uid!);
// });
//
// // final likesProvider2 =
// // StateNotifierProvider<LikesController, AsyncValue<List<dynamic>>>(
// //         (ref) => LikesController(ref));
//
//
// class LikesController extends StateNotifier<AsyncValue>{
//   final Ref? _ref;
//   final String? postId;
//   final String? uid;
//   LikesController([this._ref, this.postId, this.uid]) : super(const AsyncValue.loading()) {//const AsyncValue.data([])
//     // getNotifications();
//     getLikes();
//   }
//
//
//   Future<bool?> addLike({required String postid,}) async {
//     try {
//       await _ref?.read(likesUpdateServicesProvider).addLike(postid: postid, likerid: uid!);
//       return true;
//       // state = AsyncValue.data(trending!);
//     } on FirebaseException catch (e, _) {
//       return false;
//     }
//   }
//
//   // Future<bool?> removelike({required String uid, required String postid,}) async {
//   //   try {
//   //      await _ref?.read(likesUpdateServicesProvider).removelike( postid: postid, likerid: uid);
//   //     true;
//   //     // state = AsyncValue.data(trending!);
//   //   } on CustomException catch (e, _) {
//   //     return false;
//   //   }
//   //   return null;
//   // }
//
//   Future getLikes() async {
//     try {
//       final likes = await _ref?.read(likesUpdateServicesProvider).getLikes(postid: postId!,);
//       // return likes;
//       var result = AsyncValue.data(likes!);
//       return result;
//     } on FirebaseException catch (e, _) {
//       throw e.message!;
//     }
//   }
//
// }
