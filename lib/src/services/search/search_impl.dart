import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:megas/core/references/firestore.dart';
import 'package:megas/src/models/User.dart';
import 'package:megas/src/models/post.dart';
import 'package:megas/src/services/search/interface.dart';

class SearchImpl implements Search{
  @override
  Future<List<PostModel>> getTrendingPosts() {
    // TODO: implement getTrendingPosts
    throw UnimplementedError();
  }

  @override
  Future<List<UserModel>> getAllUsers(String searchedText) async{
    // TODO: implement getUsers
    try{
      print('first: search');
      var data = await usersRef.where('username', isGreaterThanOrEqualTo: searchedText).get();
      Map<String, dynamic> map = {};
      List<UserModel> users = [];
      print('declared postModel');
      // if(res.docs.isNotEmpty){
      data.docs.forEach((element) {
        map =  element.data();
        print('getting users list');
        final data = UserModel.fromJson(map);
        // return res.map((e) => PostModel.fromJson(e)).toList();
        print('added result to model');
        return users.add(data);
      });
      print('done with users list');
      return users;
    } on FirebaseException catch (e){
      throw e;
    }
  }
}