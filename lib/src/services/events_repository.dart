import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/core/entities/entities.dart';
import 'package:megas/objectbox.g.dart';
// import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

//final eventsBox = Hive.box('events');
final eventRepositoryProvider =
    Provider<EventRepository>((ref) => EventRepository(ref));//ref.read

final storeProvider = FutureProvider<Store>((ref) async {
  // final store = await openStore();
  Store _store = await getApplicationDocumentsDirectory().then((dir) {
    return Store(
      getObjectBoxModel(),
      directory: join(dir.path, "objectbox"),
    );
  });
  return _store;
});

final currentDateProvider = Provider((_) => DateTime.now());
final eventsProvider = StreamProvider<List<Event>>((ref) {
  final storeFuture = ref.watch(storeProvider);
  //final date = ref.watch(currentDateProvider);
  return storeFuture.when(data: (store) {
   
    return store.box<Event>().query().watch(triggerImmediately: true).map(
          (query) => query.find()
            ..removeWhere(
              // 1 TODO: //
                (event) => event.date.difference(DateTime.now()).inHours >= 1)
            /// inSeconds <= 0
            ..sort(
              (a, b) => a.date.compareTo(b.date),
            ),
        );
  }, loading: () {

    return Stream.value([]);
  }, error: (e, s) {

    return Stream.error(e, s);
  });
});


/* this will only show expired events */
final expiredEventsProvider = StreamProvider<List<Event>>((ref) {
  final storeFuture = ref.watch(storeProvider);
  //final date = ref.watch(currentDateProvider);
  return storeFuture.when(data: (store) {

    return store.box<Event>().query().watch(triggerImmediately: true).map(
          (query) => query.find()
        ..where(
          // 1 TODO: //
                (event) => event.date.difference(DateTime.now()).inHours >= 1)
      /// inSeconds <= 0
        ..sort(
              (a, b) => a.date.compareTo(b.date),
        ),
    );
  }, loading: () {

    return Stream.value([]);
  }, error: (e, s) {

    return Stream.error(e, s);
  });
});

class EventRepository {
  EventRepository([this._read, this.store]);
  final Ref? _read;
  final Store? store;

   addNewEvent(Event event) { // void
    try{
      _read?.read(storeProvider).whenData((store) => store.box<Event>().put(event));
    } on PlatformException catch (e) {
      throw('Failed to add event: $e');
    }
  }

  updateCard({int? index,Event? event}) async{ // String? note, DateTime? date,
    // Event? event,
    // Hive.box('events').putAt(index, event);
    // final Store store;
    // store = await openStore();
    Box<Event>? update = store?.box<Event>();
    Event? events = await update?.get(index!);
    // events?.note = event?.note;
    // events?.date = event!.date;
    // events?.note = note;
    // events?.date = date!;
    events?.note = event?.note;
    // event = events?.id as Event;
    _read?.read(storeProvider).whenData((store) => store.box<Event>().put(events!));

  }

  void deleteCard(Event eventToDelete) {
    _read?.read(storeProvider)
        .whenData((store) => store.box<Event>().remove(eventToDelete.id!));
  }
}
