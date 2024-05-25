import 'package:equatable/equatable.dart';
import 'package:todo_using_bloc/model/note_model.dart';


abstract class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object> get props => [];
}

class AddNote extends NoteEvent {
  final String title;
  final String description;

  const AddNote(this.title, this.description);

  @override
  List<Object> get props => [title, description];
}

class SearchNote extends NoteEvent {
  final String query;

  const SearchNote(this.query);

  @override
  List<Object> get props => [query];
}

class DeleteNote extends NoteEvent {
  final NoteModel noteModel;

  const DeleteNote({required this.noteModel});

  @override
  List<Object> get props => [];
}

class UpdateNote extends NoteEvent {
  final NoteModel updateNote;

  const UpdateNote({required this.updateNote});

  @override
  List<Object> get props => [updateNote];
}

class LoadNotes extends NoteEvent {}
