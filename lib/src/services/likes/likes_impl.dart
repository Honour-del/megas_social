

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:megas/core/references/firestore.dart';
import 'package:megas/src/models/User.dart';
import 'package:megas/src/models/post.dart';
import 'package:megas/src/services/likes/interface.dart';

class UpdateLikesImpl implements UpdateLikes{
  @override
  Future<void> addLike({required String postid, required String likerid, bool? liked}) async{
    // TODO: implement addLike
    try{
      final postRef = postsRef.doc();
      final _likesRef = await postRef;
      final likeRef = await _likesRef.get();

      List<String> likes = [];
      if((await postRef.get()).exists){
        // final documentRef = _likesRef.doc(likerid);
        // if(!(await documentRef.get()).exists){
        //   await documentRef.set({});
          print('snapshot exists');
          if(liked!){
            print('hh');
            likeRef.data()?.forEach((key, value) {
              likes.add(value);
            });
            // likeRef.docs.forEach((element) {
            //   likes.add(element.id);
            // });
            likes.add(likerid);
            print('liked');
          }else{
            // currentLikes.remove(likerid);
            likes.remove(likerid);
            print('unliked');
          // }
        }

        /// Update the like feed in the post document
        print('postref');
        // await _likesRef.doc(likerid).set({});
        // FieldValue.arrayUnion(likerid)
        await postRef.update({'likes': likes});
        /// Optionally update the local object to reveal the like
        // PostModel post = PostModel.fromJson(postRef);
        // post.likesCount = likes;
        print('hf');
      } else {
        // like the post
        print('Error: Likes ref does not exist');
      }
    } catch (e){
      throw e;
    }
  }

  @override
   getLikes({required String postid}) async{
    // TODO: implement getLikes
    try{
      /* return all likes under a post */
      final doc = await postsRef.doc(postid).get();
      final likes = doc.data()?['likes'];
      return likes ?? 0;
    } catch (e){
      throw e;
    }
  }
}