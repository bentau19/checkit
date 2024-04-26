final String tableDates = 'dates';

class DatesFields {
  static final List<String> values = [
    /// Add all fields
    id, date, events
  ];
  static final String id = '_id';
  static final String date = 'title';
  static final String events = 'content';
}

class Date {
  dynamic id;
  String date;
  String events;

  Date({
    this.id,
    required this.date,
    this.events = "",
  });
  Date copy({
    int? id,
    String? date,
    String? events,
  }) =>
      Date(
        id: id ?? this.id,
        date: date ?? this.date,
        events: events ?? this.events,
      );

  static Date fromJson(Map<String, Object?> json) => Date(
        id: json[DatesFields.id] as int,
        date: json[DatesFields.date] as String,
        events: json[DatesFields.events] as String,
      );

  Map<String, Object?> toJson() => {
        DatesFields.id: id,
        DatesFields.date: date,
        DatesFields.events: events,
      };
}
