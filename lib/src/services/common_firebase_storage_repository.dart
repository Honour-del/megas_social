
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/src/services/posts/posts_impl.dart';

final commonFirebaseStorageRepositoryProvider = Provider(
  (ref) => CreatePostImpl(
  ),
);
//
// class CommonFirebaseStorageRepository {
//   final FirebaseStorage firebaseStorage;
//   CommonFirebaseStorageRepository({
//     required this.firebaseStorage,
//   });
//
//   Future<String> storeFileToFirebase(String ref, File file) async {
//     UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
//     TaskSnapshot snap = await uploadTask;
//     String downloadUrl = await snap.ref.getDownloadURL();
//     return downloadUrl;
//   }
// }
