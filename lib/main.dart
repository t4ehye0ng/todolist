import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:whendoi/layout/gradientAppBar.dart';
import 'package:whendoi/interface/CustomPicker.dart';
import 'package:whendoi/auth/login.dart';
import 'package:whendoi/firebase/task.dart';
import 'package:whendoi/firebase/user.dart';

// final _dbCollection = "users";
final String _dbCollection = "users";
List<String> _listTaskName = [];
String _uID = "";
String _displayName = "";

void main() {
  runApp(WhenDoI());
}

class WhenDoI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    googleSignIn().then((user) {
      findUserRecord(user).then((user2) {
        _uID = user2.uid;
        _displayName = user2.displayName;
        getTaskList(_uID, _listTaskName);
      });
    });

    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RootPage(title: 'whendoi'),
    );
  }
}

class RootPage extends StatefulWidget {
  RootPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  DateTime _selectedTime;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(children: <Widget>[
        new GradientAppBar("whendoi"),
        new Expanded(child: buildTaskListView(context)),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateTask()));
          setState(() {});
        },
        tooltip: 'Show date picker',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar:
          new BottomNavigationBar(items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: 'Business',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: 'Logout',
        ),
      ], onTap: _onItemTapped),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      googleSignOut();
    });
  }

  void alert() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Date selected'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('This is a alert dialog.'),
                    Text(
                        DateFormat('yyyy-MM-dd – kk:mm').format(_selectedTime)),
                    Text('Press OK button.'),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ]);
        });
  }
}

Widget buildTaskListView(BuildContext context) {
  print("buildTaskListView");
  print(_listTaskName);
  // await getTaskList(_uID, _listTaskName);
  return ListView.builder(
    itemCount: _listTaskName.length,
    itemBuilder: (context, index) {
      final task = _listTaskName[index];
      return Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) async {
          await deleteData(task, index);
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text("$task dismissed")));
        },
        background: Card(color: Colors.blueGrey),
        child: Card(child: ListTile(title: Text(task))),
      );
    },
  );
}

// class BuildTaskList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//         stream: Firestore.instance.collection(_dbCollection).snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return CircularProgressIndicator();
//           }
//           print("builder works");
//           //     builder: (context, snapshot) {
//           //       if (!snapshot.hasData) {
//           //         return CircularProgressIndicator();
//           //       }
//           //       final documents = snapshot.data.documents;
//           //       print("uID: " + _uID);
//           //       _listTaskName.clear();
//           //       documents.forEach(
//           //           (doc) => {_listTaskName.add(doc.data["taskName"].toString())});
//           //       return _myListView(context);
//         });
//   }
// }

class CreateTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _myController = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          title: Text('Create a new task'),
        ),
        body: Column(children: <Widget>[
          TextField(
            controller: _myController,
            decoration: InputDecoration(labelText: 'Enter a task name'),
          ),
          Row(children: [
            RaisedButton(
                child: Text('Time'),
                onPressed: () async {
                  PopUpTaskCreator(context);
                }),
          ]),
          Row(children: [
            RaisedButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            RaisedButton(
                child: Text('OK'),
                onPressed: () async {
                  print("before getTaskList");
                  addTask(_uID, _myController.text).then((value) =>
                      getTaskList(_uID, _listTaskName)
                          .then((value) => {Navigator.pop(context)}));
                }),
          ]),
        ]));
  }
}
