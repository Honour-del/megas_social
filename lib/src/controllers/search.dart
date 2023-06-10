
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/src/models/User.dart';

import '../services/search/interface.dart';


final searchProvider2 = StreamProvider.family<List<UserModel>, String>(
        (ref, text) {
          return ref.read(searchProvider.notifier).searchUsers(text);
        });
final searchProvider = StateNotifierProvider<SearchController, AsyncValue<List<UserModel>>>(
        (ref) => SearchController(ref));

/////changes needs to be made to filter the categories accordingly

class SearchController extends StateNotifier<AsyncValue<List<UserModel>>>{
  final Ref? _ref;
  SearchController([this._ref,]) : super(const AsyncValue.data([])) {
  }


  Stream<List<UserModel>> searchUsers(String query){
    return _ref!.read(searchServiceProvider).searchUser(query);
  }


  Future<void> getAllUsersList(searchedText) async {
    try {
      final trending = await _ref?.read(searchServiceProvider).getAllUsers(searchedText!);
      state = AsyncValue.data(trending!);
    } on FirebaseException catch (e, _) {
      state = AsyncValue.error([e], _);
    }
  }
}
