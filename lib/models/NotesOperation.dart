import 'package:box_group/models/Note.dart';
import 'package:flutter/material.dart';

class NotesOperation extends ChangeNotifier {
  // ignore: deprecated_member_use
  List<Note> _notes = new List<Note>();

  List<Note> get getNotes {
    return _notes;
  }

  //NotesOperation() {addNewNote('Note', 'Note Description');}

  void addNewNote(String title, String description) {
    Note note = Note(title, description);
    _notes.add(note);
    notifyListeners();
  }
}
