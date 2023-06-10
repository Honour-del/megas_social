

import 'dart:io';
// import 'package:image/image.dart' as ImD;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:megas/core/references/firestore.dart';
import 'package:megas/core/utils/constants/images.dart';
import 'package:megas/core/utils/constants/uuid.dart';
import 'package:megas/main.dart';
import 'package:megas/src/services/posts/interface.dart';


class CreatePostImpl implements CreatePost{

  /* Can upload both images and videos */
  @override
  Future<String> uploadImage({required file, //String? postId,
    directoryName, uid, fileName
  }) async{
    try{
      final _file = await compressImage(file);
      debugPrint('$_file is successfully compressed');
      final String imageFileName = '$directoryName/$uid/${DateTime.now().microsecondsSinceEpoch}_$fileName';
      final _storage = storageRef.child(imageFileName);

      UploadTask uploadTask = _storage.putFile(_file);

      TaskSnapshot taskSnapshot = await uploadTask;

      String download = await taskSnapshot.ref.getDownloadURL();

      return download;
    } catch (e){
      throw e;
    }
  }


  // compressingPhoto() async {
  //   final tDirectory = await getTemporaryDirectory();
  //   final path = tDirectory.path;
  //   ImD.Image? nImageFile = ImD.decodeImage(file.readAsBytesSync());
  //   final compressedImageFile = File('$path/img_$postId.jpg')
  //     ..writeAsBytesSync(ImD.encodeJpg(nImageFile, quality: 75));//this can be increased and decreased later
  //   // setState(() {                                                // it depends on the space of the cloud use bvy the app
  //     file = compressedImageFile;
  //   // });
  // }


  @override
  Future<void> uploadPost({
  required String uid,
  required String caption,
  required File url,
  required String username,
  required String name,
  required String avatarUrl,
    // List<CommentModel>? comments
}) async{
    // TODO: implement uploadPost
    try{
      var postId = uuid.v1();
      String download = await uploadImage(file: url, uid: uid, directoryName: 'posts',);
      Map<String, dynamic> toJson() {
        final data = <String, dynamic>{};
        data['post_id'] = postId;
        data['post_image_url'] = download;
        data['caption'] = caption;
        data['user_id'] = uid;
        data['posted_at'] = dateTime;
        data['comments'] = [];
        data['likes'] = [];
        data['username'] = username;
        data['name'] = name;
        data['avatar_url'] = avatarUrl;
        return data;
      }
      // await usersRef.doc(uid).collection('posts').add(toJson());
      await postsRef.doc(postId).set(toJson());
    } on FirebaseException catch (e){
      throw e;
    }
  }

  /* delete a specific post */
  @override
  Future<bool> deletePost({required String uId, required String postId}) async{
    // TODO: implement deletePost
    try{
      // await usersRef.doc(uId).collection('posts').doc(postId).delete();
      await postsRef.doc(postId).delete();
      return true;
    } catch (e){
      throw e;
    }
  }

  @override
  Future<void> uploadTextPost({required String uid, required String caption,
    required String username, required String name, required String avatarUrl}) async{
    // TODO: implement uploadTextPost
    var postId = uuid.v1();
    Map<String, dynamic> toJson() {
      final data = <String, dynamic>{};
      data['post_id'] = postId;
      data['caption'] = caption;
      data['user_id'] = uid;
      data['posted_at'] = dateTime;
      data['comments'] = [];
      data['likes'] = [];
      data['username'] = username;
      data['name'] = name;
      data['avatar_url'] = avatarUrl;
      return data;
    }
    // await usersRef.doc(uid).collection('posts').add(toJson());
    await postsRef.doc(postId).set(toJson());
  }
}