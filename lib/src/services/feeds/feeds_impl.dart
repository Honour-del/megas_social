import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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


class FeedsRepositoryImpl implements FeedRepository{
  // GetId _getId = GetId();
  @override
  /* get every available feeds */
  Future<List<PostModel>> getFeeds(uid) async{
    // TODO: implement getFeeds
    List<PostModel> model = [];
    try{
      print('getting catalogs from reference');
      final data = await postsRef.get();
      print('iterating over catalogs to convert it to Map<String, dynamic>');
      for (var snapshot in data.docs){
        model.add(
            PostModel.fromJson(snapshot.data())
        );
        print('done with iteration');
      }
      print('catalog returned as Map<String, dynamic>');
      return model;
    } on FirebaseException catch (e) {
      throw e;
    }
  }


  Stream<List<String>> getFollowingIds(uid){
    return usersRef.doc(uid).collection('followings').snapshots().map((following) {
      return following.docs.map((e) => e.id).toList();
    });
  }


  // @override
  /* get only my "mutual"s feed */
  Stream<QuerySnapshot> getLimitedFeeds(uid) {
    // TODO: implement getFeeds
    try{
      return usersRef.doc(uid).collection('followings').snapshots().asyncMap((following) async {
        List<String> followingIds = following.docs.map((e) => e.id).toList();
        List<QuerySnapshot> postsnapList = [];

        for(String followingId in followingIds){
          QuerySnapshot post = await usersRef.doc(followingId).collection('posts').orderBy("posted_at", descending: true).limit(10).get();

          postsnapList.add(post);
        }
        List<QueryDocumentSnapshot> postShots = [];
        for (QuerySnapshot querySnapshot in postsnapList){
          for(QueryDocumentSnapshot documentSnapshot in querySnapshot.docs){
            postShots.add(documentSnapshot);
          }
        }
        postShots.sort((a, b) => b['posted_at'].compareTo(a['posted_at']));
        return postShots as QuerySnapshot; // QuerySnapshot(postShots)
      });
    } catch (e) {
      throw e;
    }
  }
}
