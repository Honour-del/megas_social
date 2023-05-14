
import 'package:objectbox/objectbox.dart';
// import 'objectbox.g.dart';

@Entity()
class Event {
  int? id;
  final String title;
  @Property(type: PropertyType.date)
  DateTime date;
  final String? imagePath;
  final String? repeat;
  String? note;
  final String? song;

  Event({
    this.id = 0,
    required this.title,
    required this.date,
    this.imagePath,
    this.repeat,
    this.note,
    this.song,
  });
}
