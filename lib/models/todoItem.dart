import './locationData.dart';

class TodoItem {
  final String id;
  final String title;
  final String note;
  final DateTime start;
  final DateTime end;
  final bool completed;
  final LocationData locationData;

  TodoItem(this.id, this.title, this.note, this.start, this.end, this.completed, this.locationData);
}
