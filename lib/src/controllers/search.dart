// import 'package:collection/collection.dart' show IterableExtension;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/core/references/firestore.dart';
import 'package:megas/src/models/User.dart';
import 'package:megas/src/services/search/search_impl.dart';

import '../services/search/interface.dart';


final searchProvider2 = FutureProvider.family<List<UserModel>, String>(
        (ref, text) async{
          print('first: search');
          var data = await usersRef.where('username', isGreaterThanOrEqualTo: text).get();
          print('done with users list');
          final users = data.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
          print('users: $users');
          print('users: ${users.first.name}');
          return users;
        });

final searchProvider = StateNotifierProvider.autoDispose.family<SearchController, AsyncValue<List<UserModel>>, String>(
        (ref, text) => SearchController(ref, text));

//final filterProvider = StateProvider((ref) => Filter.issued);


/////changes needs to be made to filter the categories accordingly

class SearchController extends StateNotifier<AsyncValue<List<UserModel>>>{
  final Ref? _ref;
  final String? searchedText;
  SearchController([this._ref, this.searchedText]) : super(const AsyncValue.data([])) {
    // getTrendingPosts();
    getAllUsersList();
  }



  Future<void> getAllUsersList() async {
    try {
      final trending = await _ref?.read(searchServiceProvider).getAllUsers(searchedText!);
      state = AsyncValue.data(trending!);
    } on FirebaseException catch (e, _) {
      state = AsyncValue.error([e], _);
    }
  }


  // Future<void> getTrendingPosts() async {
  //   try {
  //     final trending = await _ref?.read(searchServiceProvider).getTrendingPosts();
  //     state = AsyncValue.data(trending!);
  //   } on FirebaseException catch (e, _) {
  //     state = AsyncValue.error([e], _);
  //   }
  // }
}
