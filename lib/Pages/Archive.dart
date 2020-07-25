import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:orbital_2020_usono_my_ver/Models/User.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:orbital_2020_usono_my_ver/Models/Message.dart';

class Archive extends StatefulWidget {
  @override
  State createState() =>
      new _ArchiveState(); // Framework calls createState() when the stateful element has been created
}

class _ArchiveState extends State<Archive> {
  @override
  Widget build(context) {
    CollectionReference archivedMessages =
        Firestore.instance.collection("Users");
    final user = Provider.of<User>(context);
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Archived Messages"),
          backgroundColor: Colors.red[200],
          elevation: 20,
          leading: FlatButton(
            child: Icon(Icons.arrow_back_ios),
            onPressed: () =>
                Navigator.pop(context), // navigates back to QuestionPage
          ),
        ),
        body: new Column(
          children: [
            new Flexible(
              flex: 10,
              child: StreamBuilder<QuerySnapshot>(
                stream: archivedMessages
                    .document(user.uid)
                    .collection("Archived Messages")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return Message(
                          text: snapshot.data.documents[index].data["text"],
                          sender: snapshot.data.documents[index].data["from"],
                          id: snapshot.data.documents[index].documentID
                              .toString(),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            new Divider(height: 1),
          ],
        ));
  }
}