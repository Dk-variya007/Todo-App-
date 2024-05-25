import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_using_bloc/bloc/note/note_bloc.dart';
import 'package:todo_using_bloc/bloc/note/note_event.dart';
import 'package:todo_using_bloc/model/note_model.dart';

class AddNoteScreen extends StatelessWidget {
  final NoteModel? note;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  AddNoteScreen({this.note, Key? key}) : super(key: key) {
    if (note != null) {
      _titleController.text = note!.title;
      _descriptionController.text = note!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = note != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Note' : 'Add Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * .8,
            height: MediaQuery.of(context).size.height * .4,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        hintText: 'Title',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: 'Description',
                        ),
                        maxLines: null, // Allow multiple lines for description
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () {
                          final title = _titleController.text;
                          final description = _descriptionController.text;
                          if (isEditing) {
                            final updatedNote = note!.copyWith(
                              title: title,
                              description: description,
                            );
                            context
                                .read<NoteBloc>()
                                .add(UpdateNote(updateNote: updatedNote));
                          } else {
                            context.read<NoteBloc>().add(AddNote(
                                  title,
                                  description,
                                ));
                          }
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Background color
                          foregroundColor: Colors.white, // Text color
                        ),
                        child: Text(isEditing ? 'Update' : 'Save'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
