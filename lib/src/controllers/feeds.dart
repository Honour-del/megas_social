

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/core/utils/constants/exceptions.dart';
import 'package:megas/src/models/feeds.dart';
import 'package:megas/src/models/post.dart';
import 'package:megas/src/services/feeds/feeds.dart';

final feedProvider =
StateNotifierProvider.autoDispose.family<FeedController, AsyncValue<List<PostModel>>, String>((ref, id) {

  return FeedController(ref, id);
});
final feedProvider1 =
StateNotifierProvider<FeedController, AsyncValue<List<PostModel>>>(
        (ref) => FeedController(ref));

class FeedController extends StateNotifier<AsyncValue<List<PostModel>>>{
  final Ref? _ref;
  final String? uid;
  FeedController([this._ref, this.uid]) : super(const AsyncValue.data([])) {
    getFeeds(); /// this controller will automatically get available feeds
    // getLimitedFeeds();
    // TODO: implement getFeeds
  }

  // List<PostModel> feeds = [];
  Future<List<PostModel>> getFeeds() async {
    try {
      final feeds = await _ref?.read(feedServiceProvider).getFeeds(uid);
      state = AsyncValue.data(feeds!);
      return state.value!;
    } on FirebaseException catch (e, _) {
      throw e.message!;
    }
  }

  // FutureOr<void> getLimitedFeeds() async {
  //   try {
  //     final feeds = await _ref?.read(feedServiceProvider).getLimitedFeeds();
  //     state = AsyncValue.data(feeds!);
  //   } on CustomException catch (e, _) {
  //     state = AsyncValue.error([e], _);
  //   }
  // }

}