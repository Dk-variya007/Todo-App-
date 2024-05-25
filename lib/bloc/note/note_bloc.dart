import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_using_bloc/model/note_model.dart';
import 'package:todo_using_bloc/repository/note_repository.dart';
import 'note_event.dart';
import 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteRepository noteRepository;

  NoteBloc({required this.noteRepository}) : super(NoteState(noteList: [], filteredNoteList: [])) {
    on<AddNote>(_addNote);
    on<SearchNote>(_searchNote);
    on<DeleteNote>(_deleteNote);
    on<UpdateNote>(_updateNote);
    on<LoadNotes>(_loadNotes);
  }

  void _addNote(AddNote event, Emitter<NoteState> emit) async {
    final newNote = NoteModel(
      id: DateTime.now().toString(),
      title: event.title,
      description: event.description,
    );
    await noteRepository.addNote(newNote);
    final updatedList = await noteRepository.fetchNotes();
    emit(state.copyWith(noteList: updatedList, filteredNoteList: updatedList));
  }

  void _searchNote(SearchNote event, Emitter<NoteState> emit) {
    final query = event.query.toLowerCase();
    final filteredList = state.noteList.where((note) {
      final titleLower = note.title.toLowerCase();
      final descriptionLower = note.description.toLowerCase();
      return titleLower.contains(query) || descriptionLower.contains(query);
    }).toList();
    emit(state.copyWith(filteredNoteList: filteredList));
  }

  void _deleteNote(DeleteNote event, Emitter<NoteState> emit) async {
    await noteRepository.deleteNote(event.noteModel);
    final updatedList = await noteRepository.fetchNotes();
    emit(state.copyWith(noteList: updatedList, filteredNoteList: updatedList));
  }

  void _updateNote(UpdateNote event, Emitter<NoteState> emit) async {
    await noteRepository.updateNote(event.updateNote);
    final updatedList = await noteRepository.fetchNotes();
    emit(state.copyWith(noteList: updatedList, filteredNoteList: updatedList));
  }

  void _loadNotes(LoadNotes event, Emitter<NoteState> emit) async {
    final notes = await noteRepository.fetchNotes();
    emit(state.copyWith(noteList: notes, filteredNoteList: notes));
  }
}
