// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
//import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysqflite/db/notes_database.dart';
import 'package:mysqflite/model/note.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;
  const AddEditNotePage({Key? key, this.note}) : super(key: key);

  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  late TextEditingController text1;
  late TextEditingController text2;
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;
  @override
  void initState() {
    super.initState();
    text1 = TextEditingController();
    text2 = TextEditingController();
    isImportant = false;
    number = 9;
    title = 'amigo';
    description = 'maquina';
  }

  @override
  void dispose() {
    super.dispose();
    text1.dispose();
  }

  final TextStyle myStyle = TextStyle(
    color: Colors.white,
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );
  @override
  Widget build(BuildContext context) {
    //final Note note;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF333e4a),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (_formKey1.currentState!.validate() &&
                  _formKey2.currentState!.validate()) {
                addOrUpdateNote();
              }
            },
            child: Text('Save'),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF787678),
            ),
          ),
        ],
      ),
      body: Container(
        color: Color(0xFF333e4a),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Column(
            children: [
              Form(
                key: _formKey1,
                child: TextFormField(
                  controller: text1,
                  autofocus: false,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Campo sin datos';
                    }
                    return null;
                  },
                  style: myStyle,
                  cursorHeight: 30,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.note?.title ?? 'Title',
                    hintStyle: myStyle,
                  ),
                ),
              ),
              Form(
                key: _formKey2,
                child: TextFormField(
                  controller: text2,
                  style: TextStyle(color: Colors.white54),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Campo sin datos';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.note?.description ?? 'Description',
                    hintStyle: TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey1.currentState!.validate();
    print(isValid);
    if (isValid) {
      final isUpdating = widget.note != null;
      print(isUpdating);
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
      title: text1.text,
      description: text2.text,
    );
    await NotesDatabase.instance.update(note);
  }

  Future addNote() async {
    final note = Note(
      isImportan: true,
      number: number,
      title: text1.text,
      description: text2.text,
      createdTime: DateTime.now(),
    );
    await NotesDatabase.instance.create(note);
  }
}

class MyForm extends StatelessWidget {
  final bool isImportan;
  final int number;
  final String title;
  final String description;
  final DateTime dateTime;
  const MyForm(
      {Key? key,
      required this.isImportan,
      required this.number,
      required this.title,
      required this.description,
      required this.dateTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: TextFormField(),
    );
  }
}

class MyEdit extends ConsumerStatefulWidget {
  final Note? note;
  const MyEdit(this.note, {Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyEditState();
}

class _MyEditState extends ConsumerState<MyEdit> {
  late TextEditingController text1;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
