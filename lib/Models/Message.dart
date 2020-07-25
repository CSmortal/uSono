import 'package:flutter/material.dart';
import 'package:orbital_2020_usono_my_ver/Models/User.dart';
import 'package:orbital_2020_usono_my_ver/Services/database/UserDbService.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class Message extends StatefulWidget {
  final String text;
  final String sender;
  final String id;

  Message({this.text, this.sender, this.id});
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
//  final AnimationController animationController;
//  static String defaultUserName = "You";
  bool bookmarked = false;

  @override
  Widget build(BuildContext context) {
//    return new SizeTransition( // SizeTransition wraps around the widget that it wants to animate, in this case Container.
//        sizeFactor: new CurvedAnimation(
//          parent: animationController,
//          curve: Curves.bounceOut, // affects animation of newly submitted messages popping out in the flexible widget
//        ),

    final user = Provider.of<User>(context);
    String displayName;

    return new Container(
        // color: Colors.teal[100],
        margin: const EdgeInsets.symmetric(vertical: 8),
        // affects the vertical gap between messages in the ListView
        child: FutureBuilder<String>(
            future: UserDbService(uid: user.uid).getNameFromUser(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              } else {
                String userName = snapshot.data;
                userName == widget.sender
                    ? displayName = "You"
                    : displayName = widget.sender;

<<<<<<< HEAD
                return new Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // ??
                  children: [
                    new Container(
                      margin: const EdgeInsets.only(
                          right: 18), // gap between Icon and the text

                      child: new CircleAvatar(child: new Text(displayName[0])),
                    ),
                    new Expanded(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          new Text(displayName,
                              style: Theme.of(context).textTheme.subtitle1),
                          new Container(
                            margin: const EdgeInsets.only(top: 6),
                            child: new Text(widget.text),
                          )
                        ],
                      ),
                    ),
                    new InkWell(
                      onTap: () async {
                        CollectionReference archivedCollection =
                            Firestore.instance.collection("Users");
                        CollectionReference messages = archivedCollection
                            .document(user.uid)
                            .collection("Archived Messages");
                        setState(() {
                          bookmarked = !bookmarked;
                        });
                        print(bookmarked);
                        if (bookmarked == true) {
                          await messages.document(widget.id).setData({
                            "text": widget.text,
                            "from": widget.sender,
                          });
                        } else if (bookmarked == false) {
                          await messages.document(widget.id).delete();
                        }
                      },
                      child: Container(
                          height: 30,
                          width: 30,
                          alignment: Alignment.centerRight,
                          decoration: BoxDecoration(color: Colors.teal[100]),
                          child: Icon(
                              bookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: (bookmarked == true)
                                  ? Colors.red[200]
                                  : null)),
                    ),
                  ],
=======
                return Card(
                  elevation: 5,
                  child: new Row(
                    // crossAxisAlignment: CrossAxisAlignment.start, // ??
                    children: [


                      new Container(
                        margin: const EdgeInsets.only(right: 18), // gap between Icon and the text

                        child: new CircleAvatar(child: new Text(displayName[0])),
                      ),

                      new Expanded(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              new Text(displayName, style: Theme.of(context).textTheme.subtitle1),
                              new Container(
                                margin: const EdgeInsets.only(top: 6),
                                child: new Text(text),
                              )
                            ],
                          )
                      ),
                    ],
                  ),
>>>>>>> 2a472ba9646aa1cdabbde3216c2e3d2fa4dbc053
                );
              }
            }));
//    );
  }
}
