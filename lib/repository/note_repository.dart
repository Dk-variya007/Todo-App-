import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_using_bloc/model/note_model.dart';

class NoteRepository {
  final SharedPreferences _sharedPreferences;
  final String _key = 'notes';

  NoteRepository(this._sharedPreferences);

  Future<List<NoteModel>> fetchNotes() async {
    final String? notesJson = _sharedPreferences.getString(_key);
    if (notesJson != null) {
      final List<dynamic> notesList = json.decode(notesJson);
      return notesList.map((e) => NoteModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<void> addNote(NoteModel note) async {
    final List<NoteModel> notes = await fetchNotes();
    notes.add(note);
    await _saveNotes(notes);
  }

  Future<void> updateNote(NoteModel updatedNote) async {
    final List<NoteModel> notes = await fetchNotes();
    final index = notes.indexWhere((note) => note.id == updatedNote.id);
    if (index != -1) {
      notes[index] = updatedNote;
      await _saveNotes(notes);
    }
  }

  Future<void> deleteNote(NoteModel note) async {
    final List<NoteModel> notes = await fetchNotes();
    notes.removeWhere((n) => n.id == note.id);
    await _saveNotes(notes);
  }

  Future<void> _saveNotes(List<NoteModel> notes) async {
    final String notesJson = json.encode(notes.map((e) => e.toJson()).toList());
    await _sharedPreferences.setString(_key, notesJson);
  }
}
