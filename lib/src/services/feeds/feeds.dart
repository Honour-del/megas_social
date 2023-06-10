import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/src/models/User.dart';
import 'package:megas/src/models/post.dart';
import 'package:megas/src/services/feeds/feeds_impl.dart';


final feedServiceProvider = Provider<FeedRepository>((ref) {
  // Client client = Client();
  return FeedRepository(); //client.init()
});

abstract class FeedRepository{
  factory FeedRepository ()=> FeedsRepositoryImpl(); /// factory to call the implementation of the subclass
  Future<List<PostModel>> getFeeds(uid);
  Stream<List<PostModel>> getFollowingFeeds(uid);

  Future<List<UserModel>> getUserSuggestions();
}