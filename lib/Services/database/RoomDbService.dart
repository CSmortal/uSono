import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

<<<<<<< HEAD

class RoomDbService{ // manages the Rooms collection in the database, and thus all the messages in each room as well
=======
class RoomDbService {
  // manages the Rooms collection in the database, and thus all the messages in each room as well
>>>>>>> df30834a51b59e583e6f7a612b341dc501d050fb

  final String roomName;
  RoomDbService({this.roomName});
  final Firestore fs = Firestore.instance;

<<<<<<< HEAD

  Future createChatRoom(String roomName) async { // creates a chat room. The plan is to make each room a document in the Rooms collection, then there is a subcollection of messages in each room.
    CollectionReference collection = fs.collection("Rooms");
    await collection.add({"roomName": roomName});

=======
  Future createChatRoom(String roomName) async {
    // creates a chat room. The plan is to make each room a document in the Rooms collection, then there is a subcollection of messages in each room.
    try {
      CollectionReference collection = fs.collection("Rooms");
      dynamic result = await collection.add({"roomName": roomName});
      print(result);
      return result;
    } catch (e) {
      print(e.toString());
    }
>>>>>>> df30834a51b59e583e6f7a612b341dc501d050fb
  }

//  Future addMessage(String message) async {
//    CollectionReference messages = fs.collection("Messages");
//    await messages.add({""})
//
//  }
<<<<<<< HEAD
}
=======
}
>>>>>>> df30834a51b59e583e6f7a612b341dc501d050fb
