import 'package:flutter/material.dart';
import 'package:orbital_2020_usono_my_ver/Models/QuestionDetails.dart';
import 'package:orbital_2020_usono_my_ver/Models/RoomDetails.dart';
import 'package:orbital_2020_usono_my_ver/Models/User.dart';
import 'package:orbital_2020_usono_my_ver/Services/database/RoomDbService.dart';
import 'package:orbital_2020_usono_my_ver/Services/database/UserDbService.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:async';

class Message extends StatefulWidget {
  final String text;
  final String sender;
  final String messageID;

  Message({this.text, this.sender, this.messageID});
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
//  final AnimationController animationController;
//  static String defaultUserName = "You";
  bool bookmarked = false;
  bool alreadyUpvoted = false;
  bool alreadyDownvoted = false;

  @override
  Widget build(BuildContext context) {
//    return new SizeTransition( // SizeTransition wraps around the widget that it wants to animate, in this case Container.
//        sizeFactor: new CurvedAnimation(
//          parent: animationController,
//          curve: Curves.bounceOut, // affects animation of newly submitted messages popping out in the flexible widget
//        ),

    final user = Provider.of<User>(context);
    final roomDetails = Provider.of<RoomDetails>(context);
    final questionDetails = Provider.of<QuestionDetails>(context);
    final dbService = RoomDbService(roomDetails.roomName, roomDetails.roomID);

    String displayName;

    return new Card(
      // color: Colors.teal[100],
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        elevation: 5,
        // affects the vertical gap between messages in the ListView
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                  return new Row(

                    children: [

                      Column(
                        // the stack overflow functionality
                        children: <Widget>[
                          InkWell(
                            child: alreadyUpvoted
                                ? Icon(Icons.arrow_drop_up,
                                color: Colors.blue[500])
                                : Icon(Icons.arrow_drop_up),
                            onTap: () {
                              dynamic result = dbService.upvoteMessage(
                                  widget.messageID, questionDetails.questionID,
                                  user.uid);
                              setState(() {
                                alreadyUpvoted = !alreadyUpvoted;
                                if (alreadyDownvoted) {
                                  alreadyDownvoted = false;
                                }
                              });
                            },
                          ),
                          StreamBuilder<DocumentSnapshot>(
                            stream: dbService.getMessageVotes(
                                questionDetails.questionID, widget.messageID),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                // print("Current Votes: " + "${snapshot.data.data["votes"]}");
                                return Text("${snapshot.data.data["votes"]}");
                              }
                            },
                          ),
                          InkWell(
                            child: alreadyDownvoted
                                ? Icon(Icons.arrow_drop_down,
                                color: Colors.red[500])
                                : Icon(Icons.arrow_drop_down),
                            onTap: () {
                              dbService.downvoteMessage(widget.messageID,
                                  questionDetails.questionID, user.uid);
                              setState(() {
                                alreadyDownvoted = !alreadyDownvoted;
                                if (alreadyUpvoted) {
                                  alreadyUpvoted = false;
                                }
                              });
                            },
                          ),
                        ],
                      ),

                      new Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            new Text(displayName,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .subtitle1),
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
                            await messages.document(widget.messageID).setData({
                              "text": widget.text,
                              "from": widget.sender,
                            });
                          } else if (bookmarked == false) {
                            await messages.document(widget.messageID).delete();
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
                  );
                }
              }),
        ));
//                      child: new CircleAvatar(
//                          backgroundColor: Hexcolor('#CDC3D5'),
//                          child: new Text(
//                            displayName[0],
//                            style: TextStyle(color: Colors.white),
//                          )),
//                    ),
//                    new Expanded(
//                      child: new Column(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: [
//                          new Text(displayName,
//                              style: Theme.of(context).textTheme.subtitle1),
//                          new Container(
//                            margin: const EdgeInsets.only(top: 6),
//                            child: new Text(widget.text),
//                          )
//                        ],
//                      ),
//                    ),
//                    new InkWell(
//                      onTap: () async {
//                        CollectionReference archivedCollection =
//                            Firestore.instance.collection("Users");
//                        CollectionReference messages = archivedCollection
//                            .document(user.uid)
//                            .collection("Archived Messages");
//                        setState(() {
//                          bookmarked = !bookmarked;
//                        });
//                        print(bookmarked);
//                        if (bookmarked == true) {
//                          await messages.document(widget.id).setData({
//                            "text": widget.text,
//                            "from": widget.sender,
//                          });
//                        } else if (bookmarked == false) {
//                          await messages.document(widget.id).delete();
//                        }
//                      },
//                      child: Container(
//                          height: 30,
//                          width: 30,
//                          alignment: Alignment.centerRight,
//                          decoration: BoxDecoration(color: Colors.white10),
//                          child: Icon(
//                              bookmarked
//                                  ? Icons.bookmark
//                                  : Icons.bookmark_border,
//                              color: (bookmarked == true)
//                                  ? Colors.red[200]
//                                  : null)),
//                    ),
//                  ],
//                );
//              }
//            }));
//    );
//  }
  }
}
