import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth
      .instance; // via this object, we call different Firebase_Auth methods

  // Anonymously signing in
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      print("signing in");
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(user.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email,
          password:
              password); // when successful, it signs the user into the app and thus updates the onAuthStateChanged stream
      FirebaseUser user = result.user;

      // create a new document for the user, with its uid
      await userDBservice(user.uid).updateUserData(name);

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth
          .signOut(); // _auth.signOut is the signOut() method in the FirebaseAuth library
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

class roomDBservice {
  final String roomName;
  roomDBservice({this.roomName});
  final Firestore fs = Firestore.instance;

  Future createChatRoom(String roomName) async {
    // creates a chat room. The plan is to make each room a document in the Rooms collection, then there is a subcollection of messages in each room.
    CollectionReference collection = fs.collection("Rooms");
    await collection.add({"roomName": roomName});
  }
}

class userDBservice {
  final String uid;
  userDBservice(this.uid);
  CollectionReference userCollection = Firestore.instance.collection('Users');

  Future updateUserData(String name) async {
    await userCollection.document(uid).setData({"Name": name});
  }
}
