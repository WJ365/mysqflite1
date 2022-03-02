// ignore_for_file: prefer_const_constructors, duplicate_ignore, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysqflite/db/notes_database.dart';
import 'package:mysqflite/model/note.dart';
import 'package:mysqflite/page/edit_note_page.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;
  const NoteDetailPage({Key? key, required this.noteId}) : super(key: key);

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note note;
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    refreshNote();
    super.initState();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);
    notes = await NotesDatabase.instance.readAllNotes();
    setState(() => isLoading = false);
  }

  Future refreshNote() async {
    setState(() => isLoading = true);
    note = await NotesDatabase.instance.readNote(widget.noteId);
    setState(() => isLoading = false);
    //print(note.title);
    // print(note.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            refreshNotes();
          },
          icon: Icon(
            Icons.arrow_back_ios,
          ),
        ),
        elevation: 0,
        backgroundColor: Color(0xFF333e4a),
        actions: [
          editButton(),
          deleteButton(),
        ],
      ),
      backgroundColor: Color(0xFF333e4a),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(12),
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 8),
                children: [
                  Text(
                    note.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    DateFormat.yMMMMd().format(note.createdTime),
                    style: TextStyle(color: Colors.white38),
                  ),
                  SizedBox(height: 8),
                  Text(
                    note.description,
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                ],
              ),
            ),
    );
  }

  Widget editButton() => IconButton(
        icon: Icon(Icons.edit),
        onPressed: () async {
          //if (isLoading) return;
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddEditNotePage(note: note),
            ),
          );
          refreshNote();
        },
      );

  Widget deleteButton() => IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          await NotesDatabase.instance.delete(widget.noteId);
          Navigator.of(context).pop();
        },
      );
}
