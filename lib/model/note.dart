const String tableNotes = 'notes';

class NoteFields {
  static const List<String> values = [
    id,
    isImportan,
    number,
    title,
    description,
    time
  ];
  static const String id = '_id';
  static const String isImportan = 'isImportan';
  static const String number = 'number';
  static const String title = 'title';
  static const String description = 'description';
  static const String time = 'time';
}

//model
class Note {
  final int? id;
  final bool isImportan;
  final int number;
  final String title;
  final String description;
  final DateTime createdTime;

  Note({
    this.id,
    required this.isImportan,
    required this.number,
    required this.title,
    required this.description,
    required this.createdTime,
  });
  Note copy({
    int? id,
    bool? isImportan,
    int? number,
    String? title,
    String? description,
    DateTime? createdTime,
  }) =>
      Note(
          id: id ?? this.id,
          isImportan: isImportan ?? this.isImportan,
          number: number ?? this.number,
          title: title ?? this.title,
          description: description ?? this.description,
          createdTime: createdTime ?? this.createdTime);
  static Note fromJson(Map<String, Object?> json) => Note(
        id: json[NoteFields.id] as int?,
        isImportan: json[NoteFields.isImportan] == 1,
        number: json[NoteFields.number] as int,
        title: json[NoteFields.title] as String,
        description: json[NoteFields.description] as String,
        createdTime: DateTime.parse(json[NoteFields.time] as String),
      );

  Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.title: title,
        NoteFields.isImportan: isImportan ? 1 : 0,
        NoteFields.number: number,
        NoteFields.description: description,
        NoteFields.time: createdTime.toIso8601String(),
      };
}
