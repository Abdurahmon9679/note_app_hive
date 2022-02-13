import 'package:flutter/material.dart';
import 'package:note_app_hive/services/db_service.dart';

import '../models/note_models/note_model.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, this.note}) : super(key: key);

  static const String id = "/detail";

  ///for edit
  final Note? note;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  Future<void> _storeNote() async {
    if (widget.note == null) {
      String title = titleController.text.trim().toString();
      String content = contentController.text.trim().toString();
      if (content.isNotEmpty) {
        Note note = Note(
          id: title.hashCode,
          title: title,
          content: content,
          createTime: DateTime.now(),
        );
        List<Note> noteList = DBService.loadNotes();
        noteList.add(note);
        await DBService.storeNotes(noteList);
      }
    } else {
      String title = titleController.text.trim().toString();
      String content = contentController.text.trim().toString();
      List<Note> noteList = DBService.loadNotes();
      Note note = Note(
        id: widget.note!.id,
        title: title,
        content: content,
        createTime: widget.note!.createTime,
        editTime: DateTime.now(),
      );
      noteList.removeWhere((element) => element.id == note.id);
      if (content.isNotEmpty || title.isNotEmpty) {
        noteList.add(note);
        await DBService.storeNotes(noteList);
      }
    }
    Navigator.pop(context, true);
  }

  void loadNote(Note? note) {
    if (note != null) {
      setState(() {
        titleController.text = note.title;
        contentController.text = note.content;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadNote(widget.note);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        _storeNote();
        print("On will pop");
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
              onPressed: _storeNote,
              child: const Text(
                "Save",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ///title
            Container(
              alignment: Alignment.center,
              padding:  const EdgeInsets.symmetric(horizontal: 25,vertical: 15),
              child: TextField(
                controller: titleController,
                style:  const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: 'Title',
                ),
                cursorColor: Colors.orange,
                textAlignVertical: TextAlignVertical.center,
              ),
            ),
            ///content
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 25),
              child: TextField(
                controller: contentController,
                style: const TextStyle(
                  fontSize: 18,
                ),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  isCollapsed: true,
                  border: InputBorder.none,
                ),
                autofocus: true,
                showCursor: true,
                textAlignVertical: TextAlignVertical.center,
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
            )
          ],
        ),
      ),
    );
  }
}
