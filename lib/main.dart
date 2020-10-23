import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whendoi/gradientAppBar.dart';
import 'package:whendoi/login.dart';

final _databaseReference = Firestore.instance;
final _dbCollection = "todo";

void main() {
  runApp(WhenDoI());
}

class WhenDoI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    googleSignIn().then((user) {
      return getData().then((data) {
        return MaterialApp(
          title: 'TO DO LIST by TKAY',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: HomePage(title: 'whendoi'),
        );
      });
    });

    return MaterialApp(
      title: 'TO DO LIST by TKAY',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(title: 'whendoi'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedTime;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(children: <Widget>[new GradientAppBar("whendoi"), new Expanded(child: BodyLayout())]),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTask()));
          setState(() {});
        },
        tooltip: 'Show date picker',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: new BottomNavigationBar(items: const <BottomNavigationBarItem>[
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
                    Text(DateFormat('yyyy-MM-dd – kk:mm').format(_selectedTime)),
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

final List<String> _listTaskName = [];

Future<void> getData() async {
  _databaseReference.collection(_dbCollection).getDocuments().then((QuerySnapshot snapshot) {
    _listTaskName.clear();
    snapshot.documents.forEach((element) => {_listTaskName.add(element.data['taskName'].toString())});
  });
}

Future<void> createRecord(_taskName) async {
  DocumentReference ref = await _databaseReference.collection(_dbCollection).add({
    'taskName': _taskName,
  });
  print(ref.documentID);
}

Future<void> deleteData(_taskName, index) async {
  try {
    print("trying deleteData");
    _databaseReference.collection(_dbCollection).getDocuments().then((QuerySnapshot snapshot) async {
      var d = snapshot.documents[index];
      print(d);
      await Firestore.instance.runTransaction((Transaction myTransaction) async {
        await myTransaction.delete(d.reference);
      });
    });
  } catch (e) {
    print(e.toString());
  }
}

class BodyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection(_dbCollection).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          final documents = snapshot.data.documents;
          _listTaskName.clear();
          documents.forEach((doc) => {_listTaskName.add(doc.data["taskName"].toString())});
          return _myListView(context);
        });
  }
}

Widget _myListView(BuildContext context) {
  return ListView.builder(
    itemCount: _listTaskName.length,
    itemBuilder: (context, index) {
      final task = _listTaskName[index];
      return Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) async {
          await deleteData(task, index);
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("$task dismissed")));
        },
        background: Card(color: Colors.blueGrey),
        child: Card(child: ListTile(title: Text(task))),
      );
    },
  );
}

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
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            RaisedButton(
                child: Text('OK'),
                onPressed: () async {
                  _listTaskName.add(_myController.text);
                  createRecord(_myController.text);
                  Navigator.pop(context);
                }),
          ])
        ]));
  }
}

class TaskManager extends _HomePageState {
  void addTask(String taskName, dueDate) {
    _listTaskName.clear();
    _listTaskName.add(taskName);

    return;
  }
}
