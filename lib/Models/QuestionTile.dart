import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orbital_2020_usono_my_ver/Models/ExpandedQuestionTile.dart';
import 'package:orbital_2020_usono_my_ver/Models/User.dart';

import 'package:orbital_2020_usono_my_ver/Services/database/RoomDbService.dart';
import 'package:provider/provider.dart';

class QuestionTile extends StatefulWidget {
  final String text;
  final String roomName; // roomName and roomID needs to be passed around so that in ChatRoomPage, can add the message to the correct room.
  final String roomID; // might have trouble if changing roomName
  final String questionID; //

  QuestionTile({this.questionID, this.text, this.roomName, this.roomID});

  @override
  _QuestionTileState createState() => _QuestionTileState(text);
}

class _QuestionTileState extends State<QuestionTile> {
  final String text;
  int netVotes = 0;
  bool expand = false;
  bool alreadyUpvoted = false;
  bool alreadyDownvoted = false;

  _QuestionTileState(this.text);

  void toggleExpansion() {
    setState(() => expand = !expand);
  }

  @override
  Widget build(BuildContext context) {

    RoomDbService dbService = RoomDbService(widget.roomName, widget.roomID);
    final user = Provider.of<User>(context);

    return expand
        ? ExpandedQuestionTile(text, netVotes, toggleExpansion)
        : Card(
      elevation: 10,

      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 7, 15, 7),
        child: GestureDetector(
          onTap: () => {
            Navigator.pushNamed(context, "/ChatRoomPage", arguments: {
            "question": widget.text,
            "questionID": widget.questionID,
            "roomName": widget.roomName,
            "roomID": widget.roomID,
            })
          },
          child: new Row(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

              Column( // the stack overflow functionality
                children: <Widget>[

                  InkWell(
                    child: alreadyUpvoted
                        ? Icon(Icons.arrow_drop_up, color: Colors.blue[500])
                        : Icon(Icons.arrow_drop_up),
                    onTap: () {
                      dynamic result = dbService.upvoteQuestion(user.uid, widget.questionID);
                      setState(() {
                        alreadyUpvoted = !alreadyUpvoted;
                      });
                    },
                  ),


                  StreamBuilder<DocumentSnapshot>(
                    stream: dbService
                        .getQuestionVotes(widget.questionID),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        // print("Current Votes: " + "${snapshot.data.data["votes"]}");
                        return Text("${snapshot.data.data["votes"]}");
                      }
                    },
                  ),
                  InkWell(
                    child: alreadyDownvoted
                        ? Icon(Icons.arrow_drop_down, color: Colors.red[500])
                        : Icon(Icons.arrow_drop_down),
                    onTap: () {
                      dbService.downvoteQuestion(user.uid, widget.questionID);
                      setState(() {
                        alreadyDownvoted = !alreadyDownvoted;
                      });
                    },
                  ),
                ],
              ),


              SizedBox(width: 20),

              Container(
                 // color: Colors.red[100],
                width: 290,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(text, style: TextStyle(fontSize: 18),)
                ),
              ),

              Spacer(),

              GestureDetector(
                child: Icon(Icons.expand_more),
                onTap: toggleExpansion,
              ),


//                new ListTile(
//                  leading: Column(
//                    children: <Widget>[
//                      FlatButton(
//                        child: Icon(Icons.arrow_drop_up),
//                        onPressed: () {},
//                      ),
//                      StreamBuilder<DocumentSnapshot>(
//                        stream: RoomDbService(widget.roomName, widget.roomID)
//                            .getQuestionVotes(widget.questionID),
//                        builder: (context, snapshot) {
//                          if (!snapshot.hasData) {
//                            return Center(child: CircularProgressIndicator());
//                          } else {
//                            print(snapshot.data.data["votes"]);
//                            return Text("${snapshot.data.data["votes"]}");
//                          }
//                        },
//                      ),
//                      FlatButton(
//                        child: Icon(Icons.arrow_drop_down),
//                        onPressed: () {},
//                      ),
//                    ],
//                  ), // shows votes of this qn on the left of the tile
//                  title: Text(text),
//                  trailing: FlatButton(
//                    child: Icon(Icons.expand_more),
//                    onPressed: toggleExpansion,
//                  ),
//                  onTap: () =>
//                      Navigator.pushNamed(context, "/ChatRoomPage", arguments: {
//                    "question": widget.text,
//                    "questionID": widget.questionID,
//                    "roomName": widget.roomName,
//                    "roomID": widget.roomID,
//                  }),
//                )
            ],
          ),
        ),
      ),
    );
  }
}
