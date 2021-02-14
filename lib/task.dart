import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _databaseReference = Firestore.instance;
final _dbCollection = "todo";
// final _userCollection = "users";
// final _taskCollection = "tasks";

Future<void> getTaskList(uID, listTaskName) async {
  print("+ getTaskList");
  // List<String> newTaskList;
  await getTaskSnapshot(uID).then((snapshot) => {
        listTaskName.clear(),
        snapshot.documents.forEach(
            (element) => listTaskName.add(element.data['taskName'].toString()))
      });

  // listTaskName = newTaskList;
  print("- getTaskList");
  // return listTaskName;
}

Future<QuerySnapshot> getTaskSnapshot(uID) async {
  return _databaseReference
      .collection("users")
      .document(uID)
      .collection("tasks")
      .getDocuments();
}

Future<CollectionReference> getTaskCollection(uID) async {
  return _databaseReference
      .collection("users")
      .document(uID)
      .collection("tasks");
}

// Future<void> getData(_listTaskName) async {
//   _databaseReference
//       .collection(_dbCollection)
//       .getDocuments()
//       .then((QuerySnapshot snapshot) {
//     _listTaskName.clear();
//     snapshot.documents.forEach(
//         (element) => {_listTaskName.add(element.data['taskName'].toString())});
//   });
// }

Future<void> addTask(uID, taskName) async {
  print("addTask");

  getTaskCollection(uID)
      .then((collection) => collection.add({'taskName': taskName}));
}

Future<void> createRecord(FirebaseUser _user, _taskName) async {
  print("createRecord");

  // print(_user.getUid());
  // DocumentReference ref = await _databaseReference.collection(_dbCollection).add({
  //   'taskName': _taskName,
  // });
  // print(ref.documentID);
}

Future<void> deleteData(_taskName, index) async {
  try {
    print("trying deleteData");
    _databaseReference
        .collection(_dbCollection)
        .getDocuments()
        .then((QuerySnapshot snapshot) async {
      var d = snapshot.documents[index];
      print(d);
      await Firestore.instance
          .runTransaction((Transaction myTransaction) async {
        await myTransaction.delete(d.reference);
      });
    });
  } catch (e) {
    print(e.toString());
  }
}

// Future<void> createRecord(_taskName) async {
//   DocumentReference ref = await _databaseReference.collection(_dbCollection).add({
//     'taskName': _taskName,
//   });
//   print(ref.documentID);
// }
