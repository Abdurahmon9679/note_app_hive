import 'package:flutter/material.dart';
import 'package:note_app_hive/pages/detail_page.dart';
import 'package:note_app_hive/services/db_service.dart';
import '../models/note_models/note_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String id = "/home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Note> listNote;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadNoteList();
  }

  void loadNoteList() {
    setState(() {
      listNote = DBService.loadNotes();
    });
  }

  void _openDetailPage() async {
    var result = await Navigator.pushNamed(context, DetailPage.id);
    if (result != null && result == true) {
      loadNoteList();
    }
  }

  void _openDetailForEdit(Note note) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPage(
                  note: note,
                )));

    if (result != null && result == true) {
      loadNoteList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Note"),
        actions: [
          IconButton(
            onPressed: () {
              DBService.storeMode(!DBService.loadMode());
            },
            icon:
                Icon(DBService.loadMode() ? Icons.dark_mode : Icons.light_mode),
          ),
        ],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
          ),
          itemCount: listNote.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                _openDetailForEdit(listNote[index]);
              },
              child: buildNotes(index),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _openDetailPage,
        child: const Icon(Icons.add),
      ),
    );
  }
///grid items
  Card buildNotes(index) {
    return Card(
      elevation: 20,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                listNote[index].title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                listNote[index].content,
                style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                listNote[index].createTime.toString().substring(0,16),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
