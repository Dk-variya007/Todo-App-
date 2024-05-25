import 'package:equatable/equatable.dart';
import 'package:todo_using_bloc/model/note_model.dart';


class NoteState extends Equatable {
  final List<NoteModel> noteList;
  final List<NoteModel> filteredNoteList;

  const NoteState({
    required this.noteList,
    required this.filteredNoteList,
  });

  NoteState copyWith({
    List<NoteModel>? noteList,
    List<NoteModel>? filteredNoteList,
  }) {
    return NoteState(
      noteList: noteList ?? this.noteList,
      filteredNoteList: filteredNoteList ?? this.filteredNoteList,
    );
  }

  @override
  List<Object?> get props => [noteList, filteredNoteList];
}
