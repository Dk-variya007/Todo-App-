import 'package:equatable/equatable.dart';

class NoteModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime date;

  NoteModel({
    required this.id,
    required this.title,
    required this.description,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  NoteModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
    };
  }

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
    );
  }

  @override
  List<Object> get props => [id, title, description, date];
}
