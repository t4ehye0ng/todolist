import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:googleapis/people/v1.dart';

Future<FirebaseUser> googleSignIn() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount account = await googleSignIn.signIn();
  GoogleSignInAuthentication authentication = await account.authentication;
  AuthCredential credential = GoogleAuthProvider.getCredential(idToken: authentication.idToken, accessToken: authentication.accessToken);
  AuthResult authResult = await auth.signInWithCredential(credential);
  FirebaseUser user = authResult.user;
  print("AUTH COMPLETE");
  print(user);
  return user;
}

Future<void> googleSignOut() async {
  await GoogleSignIn().signOut();
  print("Signed out");
}

// useGoogleApi() async {
//   final _googleSignIn = new GoogleSignIn(
//     scopes: [
//       'email',
//       'https://www.googleapis.com/auth/contacts.readonly',
//     ],
//   );

//   await _googleSignIn.signIn();

//   final authHeaders = _googleSignIn.currentUser.authHeaders;

//   // custom IOClient from below
//   final httpClient = GoogleHttpClient(authHeaders);

//   data = await PeopleApi(httpClient).people.connections.list(
//         'people/me',
//         personFields: 'names,addresses',
//         pageToken: nextPageToken,
//         pageSize: 100,
//       );
// }
