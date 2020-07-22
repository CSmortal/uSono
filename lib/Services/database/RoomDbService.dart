import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:orbital_2020_usono_my_ver/Models/Message.dart';
import 'package:orbital_2020_usono_my_ver/Models/User.dart';
import 'package:orbital_2020_usono_my_ver/Settings/AllSettingsPanel.dart';


class RoomDbService{ // manages the Rooms collection in the database, and thus all the messages in each room as well

  final String roomName;
  final String roomID;
  RoomDbService([this.roomName, this.roomID]);
  CollectionReference roomsCollection = Firestore.instance.collection("Rooms");

  Future createChatRoom(String roomName) async { // creates a chat room. The plan is to make each room a document in the Rooms collection, then there is a subcollection of messages in each room.
    dynamic result = await roomsCollection.add({"roomName": roomName});
    return result.documentID; // calling this function will return the room's ID, which is used by the route handler to pass arguments
  }

  Future sendMessage(String msg, String sender, String questionID) async { // adds the message to the database

    try {
      CollectionReference messages = roomsCollection.document(roomID).collection("Questions").document(questionID).collection("Messages");
      dynamic result = await messages.add({
        "text": msg,
        "from": sender,
        "time": DateTime.now().millisecondsSinceEpoch,
      });

    } catch(e) {
      print(e.toString());
    }
  }

  Future createQuestion(BuildContext context, String roomName, String roomID) { // will call sendQuestion
    try {
//      print("roomID in createQuestion: " + roomID);
      AllSettingsPanel(roomName, roomID).showSettingsPanel(context, SettingsPanel.question);

    } catch(e) {
      print(e.toString);
    }
  }

  Future sendQuestion(String qn, String sender) async {
    try {
      CollectionReference questions = roomsCollection.document(roomID).collection("Questions");
      print("roomID: " + "$roomID");
      await questions.add({
        "text": qn,
        "from": sender,
        "time": DateTime.now().millisecondsSinceEpoch,
        "votes": 0,
        // additional features like tags?
      });
    } catch(e) {
      print(e.toString());
    }
  }

    Stream<QuerySnapshot> getQuestionMessages(String questionID) {
      return roomsCollection.document(roomID).collection('Questions').document(questionID).collection('Messages').orderBy("time").snapshots(); // will change order to votes later
    }

    Stream<QuerySnapshot> getRoomQuestions() {
      return roomsCollection.document(roomID).collection('Questions').orderBy("time").snapshots(); // change to order by votes later
    }

}