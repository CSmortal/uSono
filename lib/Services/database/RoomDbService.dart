import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class RoomDbService{ // manages the Rooms collection in the database, and thus all the messages in each room as well

  final String roomName;
  RoomDbService({this.roomName});
  final Firestore fs = Firestore.instance;


  Future createChatRoom(String roomName) async { // creates a chat room. The plan is to make each room a document in the Rooms collection, then there is a subcollection of messages in each room.
    CollectionReference collection = fs.collection("Rooms");
    await collection.add({"roomName": roomName});

  }

//  Future addMessage(String message) async {
//    CollectionReference messages = fs.collection("Messages");
//    await messages.add({""})
//
//  }
}