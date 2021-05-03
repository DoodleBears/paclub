import 'package:box_group/models/Note.dart';
import 'package:box_group/models/NotesOperation.dart';
import 'package:box_group/pages/add_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Null> getRefresh() async {
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: new Scaffold(
        appBar: new AppBar(
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
          ],
          title: new Text("盒群"),
          bottom: new TabBar(
            tabs: <Widget>[Tab(text: "熱門"), Tab(text: "追蹤")],
          ),
        ),
        body: Consumer<NotesOperation>(
          builder: (context, NotesOperation data, child) {
            return TabBarView(
              children: <Widget>[
                RefreshIndicator(
                  onRefresh: getRefresh,
                  backgroundColor: Colors.blue,
                  color: Colors.black,
                  child: ListView.builder(
                      itemCount: data.getNotes.length,
                      itemBuilder: (context, index) {
                        return NotesCard(data.getNotes[index]);
                      }),
                ),
                RefreshIndicator(
                  onRefresh: getRefresh,
                  backgroundColor: Colors.blue,
                  color: Colors.black,
                  child: ListView.builder(
                      itemCount: data.getNotes.length,
                      itemBuilder: (context, index) {
                        return NotesCard(data.getNotes[index]);
                      }),
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddScreen()));
          },
          child: Icon(
            Icons.add,
            size: 30,
            color: Colors.white,
          ),
          backgroundColor: Colors.lightBlue,
        ),
      ),
    );
  }
}

class NotesCard extends StatelessWidget {
  final Note note;

  NotesCard(this.note);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(15),
      height: 150,
      decoration: BoxDecoration(
          color: Colors.pink[100], borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            note.title,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            note.description,
            style: TextStyle(fontSize: 17),
          )
        ],
      ),
    );
  }
}
