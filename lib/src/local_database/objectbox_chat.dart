import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/objectbox.g.dart';
import 'package:megas/src/models/chat.dart';
import 'package:megas/src/models/message.dart';
import 'package:megas/src/models/previous.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';


/*
Local base repository for chat, messages and wallpaper
 */

final chatRepositoryProvider =
Provider<LocalChatRepository>((ref) => LocalChatRepository(ref));//ref.read

final storeProvider = FutureProvider<Store>((ref) async {
  Store _store = await getApplicationDocumentsDirectory().then((dir) {
    return Store(
      getObjectBoxModel(),
      directory: join(dir.path, "objectbox_chat"),
    );
  });
  return _store;
});

final currentDateProvider = Provider((_) => DateTime.now());
final localChatProvider = StreamProvider<List<PreviousMessageStructure>>((ref) { //
  final storeFuture = ref.watch(storeProvider);
  //final date = ref.watch(currentDateProvider);
  return storeFuture.when(data: (store) {

    return store.box<LocalChat>().query().watch(triggerImmediately: true).map(
          (query) => query.find() as List<PreviousMessageStructure>
      //   ..removeWhere(
      //           (event) => event.date.difference(DateTime.now()).inHours >= 1)
      // /// inSeconds <= 0
      //   ..sort(
      //         (a, b) => a.date.compareTo(b.date),
      //   ),
    );
  }, loading: () {

    return Stream.value([]);
  }, error: (e, s) {

    return Stream.error(e, s);
  });
});



final localMessageProvider = StreamProvider<List<PreviousMessageStructure>>((ref) {
  final storeFuture = ref.watch(storeProvider);
  return storeFuture.when(data: (store) {

    return store.box<LocalChat>().query().watch(triggerImmediately: true).map(
            (query) => query.find() as List<PreviousMessageStructure>
      //   ..removeWhere(
      //           (event) => event.date.difference(DateTime.now()).inHours >= 1)
      // /// inSeconds <= 0
      //   ..sort(
      //         (a, b) => a.date.compareTo(b.date),
      //   ),
    );
  }, loading: () {

    return Stream.value([]);
  }, error: (e, s) {

    return Stream.error(e, s);
  });
});



final localWallpaper = StreamProvider<ChatWallPaper?>((ref) {
  final storeFuture = ref.watch(storeProvider);
  //final date = ref.watch(currentDateProvider);
  return storeFuture.when(data: (store) {

    return store.box<ChatWallPaper>().query().watch(triggerImmediately: true).map(
            (query) => query.findFirst()
    );
  }, loading: () {
    return Stream.value(null);
  }, error: (e, s) {
    return Stream.error(e, s);
  });
});


class LocalChatRepository{
  LocalChatRepository([this._read, this.store]);
  final Ref? _read;
  final Store? store;


  addNewChat(LocalChat chat) { // void
    try{
      _read?.read(storeProvider).whenData((store) => store.box<LocalChat>().put(chat));
    } on PlatformException catch (e) {
      throw('Failed to add chat: $e');
    }
  }


  addNewMessage(LocalMessage message) { // void
    try{
      _read?.read(storeProvider).whenData((store) => store.box<LocalMessage>().put(message));
    } on PlatformException catch (e) {
      throw('Failed to add new message: $e');
    }
  }

  void deleteMessage(LocalMessage messageToDelete) {
    try {
      _read?.read(storeProvider)
          .whenData((store) => store.box<LocalMessage>().remove(messageToDelete.localId!));
    }on PlatformException catch (e) {
      throw('Failed to delete message: $e');
    }
  }

  void deleteChat(LocalChat chatToDelete) {
    _read?.read(storeProvider)
        .whenData((store) => store.box<LocalChat>().remove(chatToDelete.id!));
  }

  addNewWallpaper(ChatWallPaper wallPaper) { // void
    try{
      _read?.read(storeProvider).whenData((store) => store.box<ChatWallPaper>().put(wallPaper));
    } on PlatformException catch (e) {
      throw('Failed to set wallpaper: $e');
    }
  }

  void deleteWallpaper(ChatWallPaper wallPaperToDelete) {
    _read?.read(storeProvider)
        .whenData((store) => store.box<ChatWallPaper>().remove(wallPaperToDelete.id!));
  }
}