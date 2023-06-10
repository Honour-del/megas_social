import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:megas/core/references/firestore.dart';
import 'package:megas/src/models/User.dart';
import 'package:megas/src/models/post.dart';
import 'package:megas/src/services/posts/posts_impl.dart';
import 'package:megas/src/services/profile/interface.dart';

class ProfileServiceImpl implements ProfileService{

  CreatePostImpl _postImpl = CreatePostImpl();
  @override
  Stream<UserModel> getProfile(uid) {
    // TODO: implement getProfile
    try{
      final _profile = usersRef.doc(uid!).snapshots().map((event) => UserModel.fromJson(event.data() as Map<String, dynamic>));
      return _profile;
    } on FirebaseException catch (e){
      throw e;
    }
  }

  @override
  Future<bool?> updateProfile({Map<String, dynamic>? json, uid}) async{
    // TODO: implement updateProfile
    try{
       await usersRef.doc(uid).update(json!);
      return true;
    } catch (e){
      throw e;
    }
  }


  @override
  Stream<List<PostModel>> getUserPosts({String? id}) {
    // TODO: implement getUserPosts
    // List<PostModel> model = [];
    try{
      print('getting posts from reference');
      final data = postsRef.where('user_id', isEqualTo: id).orderBy('posted_at', descending: true).snapshots()
          .map((event) => event.docs
          .map((e) => PostModel.fromJson(
        e.data(),)
        ).toList(),
      );
      print('iterating over posts to convert it to Map<String, dynamic>');
      print('post returned as Map<String, dynamic>');
      return data;
    } on FirebaseException catch (e) {
      throw e;
    }
  }


  @override
  Future<bool?> uploadImage(File file, uid) async{
    // TODO: implement uploadImage
    try{
      /* The url of the uploaded image */
      String download = await _postImpl.uploadImage(file: file);
      await usersRef.doc(uid).collection('avatar_url').doc().update({
        "avatar_url": download
      });
      return true;
    } catch (e){
      throw e;
    }
  }

  @override
  Future follow(uid, userIdToFollow) async{
    // TODO: implement follow
    try{
      /* Add the userId to the followers list of the user being followed */
      await usersRef.doc(userIdToFollow).update({
        'followers_count': FieldValue.arrayUnion([uid])
      });

      /* Add the user being followed to the following list of the current user*/
      await usersRef.doc(uid).update({
        'following_count': FieldValue.arrayUnion([userIdToFollow])
      });
    } catch (e){
      throw e;
    }
  }

  @override
  Future unfollow(uid, userIdToUnfollow) async{
    // TODO: implement unfollow
    try{
      /* Add the userId to the followers list of the user being followed */
      await usersRef.doc(userIdToUnfollow).update({
        'followers_count': FieldValue.arrayRemove([uid])
      });

      /* Add the user being followed to the following list of the current user*/
      await usersRef.doc(uid).update({
        'following_count': FieldValue.arrayRemove([userIdToUnfollow])
      });
    } catch (e){
      throw e;
    }
  }
}