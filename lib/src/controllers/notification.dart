// // import 'package:collection/collection.dart' show IterableExtension;
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:megas/core/utils/constants/exceptions.dart';
// import 'package:megas/src/models/notification.dart';
//
// import '../services/notification/interface.dart';
//
// //// to filter notifications list based on time
// enum nFilter{Old,New}
//
// final notificationProvider =
// StateNotifierProvider<NotificationController, AsyncValue<List<NotificationModel>>>(
//         (ref) => NotificationController(ref));
//
// //final filterProvider = StateProvider((ref) => Filter.issued);
//
//
// /////changes needs to be made to filter the categories accordingly
//
// class NotificationController extends StateNotifier<AsyncValue<List<NotificationModel>>>{
//   final Ref? _ref;
//   NotificationController([this._ref]) : super(const AsyncValue.data([])) {
//     getNotifications();
//   }
//
//
//   /// get users notification from the backend
//   /// it doesn't requires an id since token will be used to return user data
//   Future<void> getNotifications() async {
//     try {
//
//       final trending = await _ref?.read(notificationServiceProvider).getNotifications();
//       // return trending;
//       state = AsyncValue.data(trending!);  /// return notification from the backend as async data
//     } on FirebaseException catch (e, _) {
//       state = AsyncValue.error(e,_);
//     }
//   }
// }
