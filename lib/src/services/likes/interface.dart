
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/src/services/likes/likes_impl.dart';

final likesUpdateServicesProvider = Provider<UpdateLikesImpl>((ref) {
  return UpdateLikesImpl(ref);
});
// abstract class UpdateLikes {
//   ProviderRef? ref;
//   // factory UpdateLikes()=> UpdateLikesImpl(ref);
//
//   Stream<PostModel> getLikes({required String postid});
//
//   Future<void> likePost({required String postid, required String likerid, PostModel? postModel, bool? liked,post_owner});
// }