import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/src/models/User.dart';
import 'package:megas/src/models/post.dart';
import 'package:megas/src/services/search/search_impl.dart';

final searchServiceProvider = Provider<Search>((ref) {
  return Search();
});

abstract class Search {
  factory Search() => SearchImpl();
  Future<List<UserModel>> getAllUsers(String searchedText);

  Future<List<PostModel>> getTrendingPosts();
}