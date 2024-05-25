import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_using_bloc/bloc/note/note_bloc.dart';
import 'package:todo_using_bloc/bloc/note/note_event.dart';
import 'package:todo_using_bloc/bloc/note/note_state.dart';

import 'package:todo_using_bloc/component/new_note.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  void _onSearchChanged() {
    context.read<NoteBloc>().add(SearchNote(_searchController.text));
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    context.read<NoteBloc>().add(LoadNotes());
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("build");
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xffFFA62F),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.black),
              )
            : const Text('To-dos'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            iconSize: 35,
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  context.read<NoteBloc>().add(const SearchNote(''));
                }
              });
            },
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: !_isSearching,
        child: FloatingActionButton(
          backgroundColor: const Color(0xffFFC96F), //Colors.amber[800],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddNoteScreen()));
          },
          child: const Icon(Icons.add, size: 30),
        ),
      ),
      body: Center(
        child: BlocBuilder<NoteBloc, NoteState>(
          builder: (context, state) {
            final todoList =
                _isSearching ? state.filteredNoteList : state.noteList;
            return ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                final todo = todoList[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNoteScreen(note: todo),
                        ),
                      );
                    },
                    child: Card(
                      color: const Color(0xffFFE8C8),
                      child: ListTile(
                        trailing: IconButton(
                          onPressed: () {
                            context
                                .read<NoteBloc>()
                                .add(DeleteNote(noteModel: todo));
                          },
                          icon: const Icon(Icons.delete),
                        ),
                        title: Text(
                          todo.title,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(todo.description),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
