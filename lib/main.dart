import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _databaseReference = Firestore.instance;
final _dbCollection = "todo";
// final dbDocument = "EZcaJ0qyUWa2g2Pj7CMP";

void main() {
  runApp(ToDo());
}

class ToDo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getData();
    return MaterialApp(
      title: 'TO DO LIST by TKAY',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'TO DO LIST by TKAY'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _selectedTime;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: BodyLayout(),
      floatingActionButton: FloatingActionButton(
        // onPressed: _incrementCounter,
        onPressed: () async {
          await Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateTask()));
          setState(() {});
        },
        tooltip: 'Show date picker',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      // bottomNavigationBar: new BottomNavigationBar(),
    );
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

final List<String> _listTaskName = [];

// TODO: Make this function async
void getData() {
  _databaseReference
      .collection(_dbCollection)
      .getDocuments()
      .then((QuerySnapshot snapshot) {
    _listTaskName.clear();
    snapshot.documents.forEach(
        (element) => {_listTaskName.add(element.data['taskName'].toString())});
  });
}

void createRecord(_taskName) async {
  // await _databaseReference.collection(_dbCollection).document("1").setData({
  //   'taskName': _taskName,
  // });

  DocumentReference ref =
      await _databaseReference.collection(_dbCollection).add({
    'taskName': _taskName,
  });
  print(ref.documentID);
}

void deleteData(_taskName) {
  try {
    print("trying deleteData");
    _databaseReference
        .collection(_dbCollection)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((element) {
        if (element.data.containsValue(_taskName)) {
          print("found: " + element.data.values.toString());
          element.data.clear();
          // } else {
          //   print("no: " + element.data.values.toString());
        }
      });
    });
    // print("deleteData");
    // print(_taskName);
    // _databaseReference.collection(_dbCollection).document(_taskName).delete();
  } catch (e) {
    print(e.toString());
  }
}
// void deleteData(_taskName) async {
//   await Firestore.instance.runTransaction((Transaction myTransaction) async {
//     await myTransaction.delete(snapshot.data.documents[index].reference);
//   });
// }

class BodyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getData();
    // QuerySnapshot documents = await getData();
    // StreamBuilder<QuerySnapshot>(
    //     stream: Firestore.instance.collection(_dbCollection).snapshots(),
    //     builder: (context, snapshot) {
    //       if (!snapshot.hasData) {
    //         return CircularProgressIndicator();
    //       }
    //       // final documents = snapshot.data.documents;
    //       // documents.map((doc) => _listTaskName.add(doc.toString()));
    //       // print(documents);

    //       // return _myListView(context, documents);
    //       //   // return Expanded(
    //       //   //     child: ListView(
    //       //   //   children:
    //       //   //       documents.map((doc) =>

    //       //   //       _buildItemWidget(doc, context)).toList(),
    //       //   // ));
    //     });
    return _myListView(context);
  }
}

// Widget _buildItemWidget(DocumentSnapshot doc, BuildContext context) {
//   final taskName = doc['taskName'];
//   return Dismissible(
//     key: Key(taskName),
//     onDismissed: (direction) {
//       deleteData(taskName);
//       // _listTaskName.removeAt(index);
//       Scaffold.of(context)
//           .showSnackBar(SnackBar(content: Text("$taskName dismissed")));
//     },
//     background: Card(color: Colors.blueGrey),
//     child: Card(child: ListTile(title: Text(taskName))),
//   );
// }

Widget _myListView(BuildContext context) {
  print("_myListView");

  return ListView.builder(
    itemCount: _listTaskName.length,
    itemBuilder: (context, index) {
      final task = _listTaskName[index];
      return Dismissible(
        key: Key(task),
        onDismissed: (direction) {
          // _listTaskName.removeAt(index);
          // deleteData(task);
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text("$task dismissed")));
        },
        background: Card(color: Colors.blueGrey),
        child: Card(child: ListTile(title: Text(task))),
      );
    },
  );
}

// StreamBuilder<QuerySnapshot> (
//   stream: Firestore.instance.collection('todo').snapshots(),
//   builder: (context, snapshot) {
//     if (!snapshot.hasData) {
//       return CircularProgressIndicator();
//     }
//     final documents = snapshot.data.documents;
//     return Expanded(
//       child: documents.map((doc) =>
//       _buildItemWidget(doc)
//       )
//     );
//   }
// )
// (sstream: Firestore.instance.collection('todo').snapshots(),
// builder: )

// Widget _myListView(BuildContext context) {
//   return ListView.builder(
//     itemCount: _listTaskName.length,
//     itemBuilder: (context, index) {
//       final task = _listTaskName[index];
//       return Dismissible(
//         key: Key(task),
//         onDismissed: (direction) {
//           _listTaskName.removeAt(index);
//           Scaffold.of(context)
//               .showSnackBar(SnackBar(content: Text("$task dismissed")));
//         },
//         background: Card(color: Colors.blueGrey),
//         child: Card(child: ListTile(title: Text(task))),
//       );
//       // return Card(
//       //     child: ListTile(
//       //   title: Text(task),
//       // ));
//     },
//   );
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
            //controller: _take,
            // validator: (_formKey) {
            //   if (_formKey.isEmpty) {
            //     return 'You must enter at least a letter';
            //   }
            // },
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
                  print(_listTaskName);

                  createRecord(_myController.text);

                  Navigator.pop(context);
                }),
          ])
        ]));
  }
}

class TaskManager extends _MyHomePageState {
  // TaskManager() {};

  void addTask(String taskName, dueDate) {
    // void addTask() {
    // debugPrint(taskName);
    _listTaskName.clear();

    // this._listTaskName.add('2');
    _listTaskName.add(taskName);
    // _listDueDate.add(dueDate);
    // if (!dueDate) _listDueDate.add(DateTime.now());
    // else _listDueDate.add(dueDate);

    return;
  }
}
