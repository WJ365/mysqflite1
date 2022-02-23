// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mysqflite/db/notes_database.dart';
import 'package:mysqflite/model/note.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;
  const AddEditNotePage({Key? key, this.note}) : super(key: key);

  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF333e4a),
        actions: [
          ElevatedButton(
            onPressed: () {},
            child: Text('Save'),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF787678),
            ),
          ),
        ],
      ),
      body: Container(),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      final isUpdating = widget.note != null;
      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }
      Navigator.of(context).pop();
    }
  }

  Future updateNote() async {
    final note = widget.note!.copy(
      isImportan: isImportant,
      number: number,
      title: title,
      description: description,
    );
    await NotesDatabase.instance.update(note);
  }

  Future addNote() async {
    final note = Note(
      isImportan: true,
      number: number,
      title: title,
      description: description,
      createdTime: DateTime.now(),
    );
    await NotesDatabase.instance.create(note);
  }
}
