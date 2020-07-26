import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:orbital_2020_usono_my_ver/Models/User.dart';


class UserDbService {
  final String uid;
  UserDbService({this.uid});
  CollectionReference userCollection = Firestore.instance.collection('Users');

  Future updateUserData(String name) async {
    await userCollection.document(uid).setData({"Name": name});
  }


  Future<String> getNameFromUser() async { // since User objects don't have a name attribute
    // await userCollection.document(uid).get().then((doc) => doc.data["Name"]);
    DocumentSnapshot docSS = await userCollection.document(uid).get();
    return docSS.data["Name"];
  }
}