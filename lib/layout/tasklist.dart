// class TaskList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//         stream: Firestore.instance.collection(_dbCollection).snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return CircularProgressIndicator();
//           }
//           final documents = snapshot.data.documents;
//           print("uID: " + _uID);
//           _listTaskName.clear();
//           documents.forEach(
//               (doc) => {_listTaskName.add(doc.data["taskName"].toString())});
//           return _myListView(context);
//         });
//   }
// }
