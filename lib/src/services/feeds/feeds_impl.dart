import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:megas/core/references/firestore.dart';
import 'package:megas/src/models/User.dart';
import 'package:megas/src/models/post.dart';
import 'package:megas/src/services/feeds/feeds.dart';
import 'package:megas/src/services/shared_prefernces.dart';




class FeedsRepositoryImpl implements FeedRepository{
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



  // @override
  /* get only my "mutual"s feed */
  Stream<List<PostModel>> getFollowingFeeds(uid) {
    // TODO: implement getFeeds
    try{
      /* Get all the following list of the current user */
      return usersRef.doc(uid).snapshots().asyncMap((following) {
        final _model = UserModel.fromJson(following.data()!);
        List<dynamic> followingIds = _model.followingCount.toList();
        List<PostModel> postsnapList = [];

        /* Iterate between the returned following Ids and get the posts by each Ids */
        for(var followingId in followingIds){
          final post = usersRef.doc(followingId).collection('posts').orderBy("posted_at", descending: true).limit(10).snapshots()
              .map((event) => event.docs.map((e) => PostModel.fromJson(e.data())).toList());

          postsnapList.add(post as PostModel);
        }
        return postsnapList;
        // List<dynamic> postShots = [];
        // for (var querySnapshot in postsnapList){
        //   for(var documentSnapshot in querySnapshot.docs){
        //     postShots.add(documentSnapshot);
        //   }
        // }
        // postShots.sort((a, b) => b['posted_at'].compareTo(a['posted_at']));
        // return postShots; // QuerySnapshot(postShots)
      });
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<List<UserModel>> getUserSuggestions() async{
   UserSuggestion _suggests = UserSuggestion();
   print("object: ${_suggests.getSuggestedUsers()}");
   return await _suggests.getSuggestedUsers();
  }
}


class UserSuggestion{
  static const String lastSuggestionKey = 'last_suggestion_timestamp';
  final Preferences _prefs = Preferences();

  Future<List<UserModel>> getSuggestedUsers() async{
    final lastSuggestionTime  = await _getLastSuggestionTime();

    if(!_enoughTimeHasPassed(lastSuggestionTime)){
      return [];
    }
    // TODO
    // final querySnapshot = await usersRef.orderBy('followersCount', descending: true)
    // .limit(10).get();
final querySnapshot = await usersRef.get();

    final suggestedUsers = querySnapshot.docs
    .map((e) => UserModel.fromJson(e.data())).toList();
print("this length: ${suggestedUsers.first.name}");
    await _updateLastSuggestionTime();

    return suggestedUsers;
  }

  Future<DateTime> _getLastSuggestionTime() async{
    final timeStampMilliseconds = await _prefs.getTime(lastSuggestionKey) ?? 0;
    return DateTime.fromMicrosecondsSinceEpoch(timeStampMilliseconds);
  }

  Future<void> _updateLastSuggestionTime() async{
    final currentTimestamp = DateTime.now().microsecondsSinceEpoch;
    await _prefs.setTime(lastSuggestionKey, currentTimestamp);
  }

  bool _enoughTimeHasPassed(DateTime lastSuggestionTime){
    final now = DateTime.now();
    final difference = now.difference(lastSuggestionTime);
    final dayPassed = difference.inDays;
    final minDaysBetweenSuggestions = 3;
    return dayPassed >= minDaysBetweenSuggestions;
  }
}