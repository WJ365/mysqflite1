// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mysqflite/db/notes_database.dart';
import 'package:mysqflite/model/note.dart';
import 'package:mysqflite/page/edit_note_page.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mysqflite/page/note_detail_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();
    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);
    notes = await NotesDatabase.instance.readAllNotes();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Notes',
            style: TextStyle(fontSize: 24),
          ),
        ),
        body: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : notes.isEmpty
                  ? Text('No Notes')
                  : buildNotes(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddEditNotePage()));
            refreshNotes();
          },
        ),
      );
  Widget buildNotes() => MasonryGridView.count(
        crossAxisCount: 4,
        itemBuilder: (contex, index) {
          final note = notes[index];
          return GestureDetector(
            onTap: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (contex) => NoteDetailPage(noteId: note.id!),
                ),
              );
              refreshNotes();
            },
            child: NoteCardWidget(
              notes: note,
              index: index,
            ),
          );
        },
      );
}

class NoteCardWidget extends StatelessWidget {
  final Note notes;
  final int index;
  const NoteCardWidget({Key? key, required this.notes, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(notes.title),
        subtitle: Text(notes.description),
        leading: Text(notes.id.toString()),
      ),
    );
  }
}
