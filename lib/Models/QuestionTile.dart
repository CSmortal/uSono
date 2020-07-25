import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orbital_2020_usono_my_ver/Models/ExpandedQuestionTile.dart';
import 'package:orbital_2020_usono_my_ver/Models/Message.dart';

class QuestionTile extends StatefulWidget {
  final String text;
  final String
      roomName; // roomName and roomID needs to be passed around so that in ChatRoomPage, can add the message to the correct room.
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

  _QuestionTileState(this.text);

  void toggleExpansion() {
    setState(() => expand = !expand);
  }

  @override
  Widget build(BuildContext context) {
    return expand
        ? ExpandedQuestionTile(text, netVotes, toggleExpansion)
        : Card(
            child: new Column(
              children: <Widget>[
                new ListTile(
                  leading: Text(
                      "$netVotes"), // shows votes of this qn on the left of the tile
                  title: Text(text),
                  trailing: FlatButton(
                    child: Icon(Icons.expand_more),
                    onPressed: toggleExpansion,
                  ),
                  onTap: () =>
                      Navigator.pushNamed(context, "/ChatRoomPage", arguments: {
                    "question": widget.text,
                    "questionID": widget.questionID,
                    "roomName": widget.roomName,
                    "roomID": widget.roomID,
                  }),
                )
              ],
            ),
          );
  }
}
