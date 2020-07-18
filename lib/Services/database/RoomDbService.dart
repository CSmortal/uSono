import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:orbital_2020_usono_my_ver/Models/Message.dart';
import 'package:orbital_2020_usono_my_ver/Models/User.dart';

class RoomDbService {
  // manages the Rooms collection in the database, and thus all the messages in each room as well

  final String roomName;
  final String roomID;
  const RoomDbService([this.roomName, this.roomID]);
//  final Firestore Firestore.instance = Firestore.instance;

  Future createChatRoom(String roomName) async {
    // creates a chat room. The plan is to make each room a document in the Rooms collection, then there is a subcollection of messages in each room.
    CollectionReference collection = Firestore.instance.collection("Rooms");
    dynamic result = await collection.add({"roomName": roomName});
    return result
        .documentID; // calling this function will return the room's ID, which is used by the route handler to pass arguments
  }

  Future sendMessage(String msg, String sender) async {
    // adds the message to the database

    try {
      print(roomID);
      CollectionReference messages = Firestore.instance
          .collection("Rooms")
          .document('$roomID')
          .collection("Messages");
      print("sending message to the database...");

      dynamic result = await messages.add({
        "text": msg,
        "from": sender,
        "time": DateTime.now().millisecondsSinceEpoch,
      });

      if (result != null) {
        print(result.documentID);
      } else {
        print("Result is null");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<QuerySnapshot> getRoomMessages() {
    return Firestore.instance
        .collection('Rooms')
        .document(roomID)
        .collection('Messages')
        .orderBy("time")
        .snapshots();
  }
}
