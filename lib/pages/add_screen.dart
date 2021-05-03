import 'dart:ui';
import 'package:box_group/models/NotesOperation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String titleText;
    String descriptionText;
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        title: Text(
          'Notes',
          style: TextStyle(color: Colors.black, fontSize: 40),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                hintText: "Enter Title",
                hintStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              onChanged: (value) {
                titleText = value;
              },
            ),
            Divider(
              height: 10,
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter Description",
                  hintStyle: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                ),
                onChanged: (value) {
                  descriptionText = value;
                },
              ),
            ),
            TextButton(
              onPressed: () {
                Provider.of<NotesOperation>(context, listen: false)
                    .addNewNote(titleText, descriptionText);
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              child: Text(
                'Add Note',
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
