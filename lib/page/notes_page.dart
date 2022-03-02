// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:mysqflite/db/notes_database.dart';
import 'package:mysqflite/model/note.dart';
import 'package:mysqflite/page/edit_note_page.dart';
import 'package:mysqflite/page/note_detail_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  //late Note note;

  bool isLoading = false; //asdfghjk

  @override
  void initState() {
    super.initState();
    refreshNotes();
    setState(() {});
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
                  // : MiLista(notes: notes),
                  : myBuildNotes(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddEditNotePage()));
            //refreshNotes();
          },
        ),
      );

  Widget myBuildNotes() => ListView.builder(
        itemCount: notes.length,
        itemBuilder: (_, i) {
          return GestureDetector(
            child: Card(
              color: Colors.black12,
              child: ListTile(
                title: Text(notes[i].title),
                subtitle: Text(notes[i].description),
                leading: Text(notes[i].id.toString()),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(notes[i].number.toString()),
                    Text(notes[i].isImportan.toString()),
                  ],
                ),
              ),
            ),
            onTap: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (contex) => NoteDetailPage(noteId: notes[i].id!),
                ),
              );
            },
          );
        },
      );
}

// class MiLista extends StatelessWidget {
//   final List<Note> notes;
//   // final Note note;
//   const MiLista({Key? key, required this.notes}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: notes.length,
//       itemBuilder: (context, i) {
//         //return NoteCardWidget(notes: note);
//         return GestureDetector(
//           child: Card(
//             color: Colors.black12,
//             child: ListTile(
//               title: Text(notes[i].title),
//               subtitle: Text(notes[i].description),
//               leading: Text(notes[i].id.toString()),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(notes[i].number.toString()),
//                   Text(notes[i].isImportan.toString()),
//                 ],
//               ),
//             ),
//           ),
//           onTap: () async {
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (contex) => NoteDetailPage(noteId: notes[i].id!),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }


