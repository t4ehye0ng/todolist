import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _databaseReference = Firestore.instance;
final _userCollection = "users";

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