import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _databaseReference = Firestore.instance;
final _dbCollection = "todo";
final _userCollection = "users";
final _taskCollection = "tasks";

Future<void> getData(_listTaskName) async {
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

Future<void> findUserRecord(FirebaseUser user) async {
  _databaseReference
      .collection(_userCollection)
      .document(user.uid)
      .get()
      .then((doc) => {
            if (doc.exists)
              {print("Document data: "), print(doc.data)}
            else
              {
                // print("No such document! :" + user.uid)
                // print("Trying make new document")
                createUserRecord(user)
              }
          })
      .catchError((onError) => {print("Error getting document: " + onError)});
}

Future<void> createUserRecord(FirebaseUser user) async {
  // DocumentReference ref =
  await _databaseReference.collection(_userCollection).document(user.uid).setData({'displayName': user.displayName});
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

// Future<void> createRecord(_taskName) async {
//   DocumentReference ref = await _databaseReference.collection(_dbCollection).add({
//     'taskName': _taskName,
//   });
//   print(ref.documentID);
// }
