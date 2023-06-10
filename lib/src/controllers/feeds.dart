

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/core/references/firestore.dart';
import 'package:megas/src/models/post.dart';
import 'package:megas/src/services/feeds/feeds.dart';





final newFeedProvider = StreamProvider<List<PostModel>>((ref) {
  _listenToFeeds();
  ref.onDispose(_cancelFeedSubscription);
  return getFeedsK();
});

final StreamController<List<PostModel>> _feedsController = StreamController<List<PostModel>>.broadcast();
Stream<List<PostModel>> getFeedsK (){
  return _feedsController.stream;
}
// TODO
void _listenToFeeds(){
  postsRef.snapshots().listen((querySnapshot) {
    final feeds = querySnapshot.docs.map((e) => PostModel.fromJson(e.data())).toList();
    _feedsController.add(feeds);
  });
}

void _cancelFeedSubscription(){
  _feedsController.close();
}


final shuffledItemsProvider = FutureProvider<List<dynamic>>((ref) async{
  final suggestedUsers = await ref.watch(feedServiceProvider).getUserSuggestions();
  print("Feeds length: ${suggestedUsers.length}");
  final feedPosts = ref.watch(newFeedProvider).value ?? [];
  print("Post length: ${feedPosts.length}");

  final shuffledItems = [...suggestedUsers, ...feedPosts];
  // final shuffledItems = List<dynamic>.from([...suggestedUsers, ...feedPosts]);
  // final shuffledItems = List<dynamic>.empty(growable: true);
  // shuffledItems.addAll(suggestedUsers.value!);
  // shuffledItems.addAll(feedPosts.value!);
  shuffledItems.shuffle();
  return shuffledItems;
});



