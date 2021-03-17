import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:googleapis/people/v1.dart';

Future<FirebaseUser> googleSignIn() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount account = await googleSignIn.signIn();
  GoogleSignInAuthentication authentication = await account.authentication;
  AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: authentication.idToken, accessToken: authentication.accessToken);
  AuthResult authResult = await auth.signInWithCredential(credential);
  FirebaseUser user = authResult.user;
  print("AUTH COMPLETE");
  print(user.uid);
  print(user.displayName);
  return user;
}

Future<void> googleSignOut() async {
  await GoogleSignIn().signOut();
  // print("Signed out");
}
