import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:orbital_2020_usono_my_ver/Models/Message.dart';
import 'package:orbital_2020_usono_my_ver/Models/User.dart';
import 'package:orbital_2020_usono_my_ver/Settings/AllSettingsPanel.dart';


class RoomDbService { // manages the Rooms collection in the database, and thus all the messages in each room as well

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
      // print("roomID: " + "$roomID");
      await questions.add({
        "text": qn,
        "from": sender,
        "time": DateTime.now().millisecondsSinceEpoch,
        "votes": 0,
        "voteMap": new Map<String,dynamic>(),
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

//    Future<void> upvoteQuestion(String questionID) {
//      roomsCollection.document(roomID).collection('Questions').document(questionID).updateData({"votes": })
//    }

    Stream<DocumentSnapshot> getQuestionVotes(String questionID) {
      return roomsCollection.document(roomID).collection('Questions').document(questionID).snapshots();
    }


    // To implement voting, we will have to add a Map<String, bool> to each question in the database. Create a function
    // that will add the user's uid and the bool false as a kv pair to the question's map in the db, if the entry doesnt exist
    // This is done everytime for the question that the user clicks on the upvote or downvote button for.

    Future upvoteQuestion(String userID, String questionID) async {
//
      DocumentReference relevantQn = roomsCollection.document(roomID).collection('Questions').document(questionID);
//
      int currVotes;
      bool keyExists;
      String voteStatus;

      await relevantQn.get().then((docSS) => {
        keyExists = docSS.data["voteMap"].containsKey(userID),
        if (keyExists) {
          voteStatus = docSS.data["voteMap"][userID],
          currVotes = docSS.data["votes"],
        }
      });

      if (!keyExists) {
        await relevantQn.get().then((docSS) => {
          currVotes = docSS.data["votes"],
          // print("currVotes: $currVotes"),
          relevantQn.updateData({"votes": currVotes += 1})
        });
        relevantQn.setData({"voteMap": {userID: "Upvoted"}, }, merge: true);

      } else {
        if (voteStatus == "Upvoted") { // revoke upvote
          await relevantQn.updateData({"voteMap": {userID: "Neutral"}, "votes": currVotes -= 1});
        } else if (voteStatus == "Neutral") {
          // print("currVotes: $currVotes");
          await relevantQn.updateData({"voteMap": {userID: "Upvoted"}, "votes": currVotes += 1});
        } else { // this user downvoted this qn previously
          // print("currVotes: $currVotes");
          await relevantQn.updateData({"voteMap": {userID: "Upvoted"}, "votes": currVotes += 2});
        }
      }
    }

  Future downvoteQuestion(String userID, String questionID) async {
//
    DocumentReference relevantQn = roomsCollection.document(roomID).collection('Questions').document(questionID);
//
    int currVotes;
    bool keyExists;
    String voteStatus;

    await relevantQn.get().then((docSS) => {
      keyExists = docSS.data["voteMap"].containsKey(userID),
      if (keyExists) {
        voteStatus = docSS.data["voteMap"][userID],
        currVotes = docSS.data["votes"],
      }
    });

    if (!keyExists) {
      await relevantQn.get().then((docSS) => {
        currVotes = docSS.data["votes"],
        // print("currVotes: $currVotes"),
        relevantQn.updateData({"votes": currVotes -= 1})
      });
      relevantQn.setData({"voteMap": {userID: "Downvoted"}, }, merge: true);

    } else {
      if (voteStatus == "Downvoted") {
        await relevantQn.updateData({"voteMap": {userID: "Neutral"}, "votes": currVotes += 1});
      } else if (voteStatus == "Neutral") {
        // print("currVotes: $currVotes");
        await relevantQn.updateData({"voteMap": {userID: "Downvoted"}, "votes": currVotes -= 1});
      } else { // this user downvoted this qn previously
        // print("currVotes: $currVotes");
        await relevantQn.updateData({"voteMap": {userID: "Downvoted"}, "votes": currVotes -= 2});
      }
    }
  }

}