import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:orbital_2020_usono_my_ver/Models/Message.dart';
import 'package:orbital_2020_usono_my_ver/Models/QuestionDetails.dart';
import 'package:orbital_2020_usono_my_ver/Models/RoomDetails.dart';
import 'package:orbital_2020_usono_my_ver/Models/User.dart';
import 'package:orbital_2020_usono_my_ver/Services/database/RoomDbService.dart';
import 'package:orbital_2020_usono_my_ver/Services/database/UserDbService.dart';
import 'package:provider/provider.dart';

class ChatRoomPage extends StatefulWidget {
  final String question;
  final String questionID;
  final String roomName;
  final String roomID;

  ChatRoomPage(Map<String, String> map)
      : this.question = map["question"],
        this.questionID = map["questionID"],
        this.roomName = map["roomName"],
        this.roomID = map["roomID"];

  @override
  State createState() => new _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage>
    with TickerProviderStateMixin {
//   final String roomName;
//   final String roomID;
  final TextEditingController textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

//   _ChatRoomPageState(this.roomName, this.roomID);

//  final List<Message> _messages = <Message>[];
//  bool _isWriting = false;

  @override
  Widget build(BuildContext context) {

    final _controller = ScrollController();
    RoomDbService dbService = RoomDbService(widget.roomName, widget.roomID);
    // _controller.jumpTo(10);

    return MultiProvider(

      providers: [
        Provider<RoomDetails>.value(value: RoomDetails(widget.roomName, widget.roomID)),
        Provider<QuestionDetails>.value(value: QuestionDetails(widget.question, widget.questionID)),
      ],

      child: new Scaffold(
          appBar: new AppBar(
            title: new Text(widget.question),
            backgroundColor: Hexcolor('#A38FA3'),
            elevation: 20,
            leading: FlatButton(
              child: Icon(Icons.arrow_back_ios),
              onPressed: () =>
                  Navigator.pop(context), // navigates back to QuestionPage
            ),
          ),
          body: new Column(
            children: [
//            new Container(
//              color: Colors.red[200],
//              constraints: BoxConstraints.expand(width: 400.0, height: 100.0),
//              child: Align(
//                alignment: Alignment.center,
//                child: Text(
//                  roomName,
//                  style: (TextStyle(
//                    color: Colors.white,
//                    fontSize: 25,
//                    fontWeight: FontWeight.w300,
//                  )),
//                ),
//              ),
//            ),



              new Flexible(
                flex: 10,
                child: StreamBuilder<QuerySnapshot>(
                  stream: dbService.getQuestionMessages(widget.questionID),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
//                    print("Snapshot connectionState: " +
//                        "${snapshot.connectionState}");

                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {

                      Timer(
                        Duration(seconds: 1),
                            () => _controller.jumpTo(_controller.position.maxScrollExtent),
                      );

                      return ListView.builder(
                        controller: _controller,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          return Message(
                            text: snapshot.data.documents[index].data["text"],
                            sender: snapshot.data.documents[index].data["from"],
                            messageID: snapshot.data.documents[index].documentID
                                .toString(),
                          );
                        },
                      );
                    }
                  },
                ),
              ),

              new Divider(height: 1),

              new Flexible(
                // Input box
                flex: 1,
                child: _buildComposer(),
              )
            ],
          )),
    );
  }

  Widget _buildComposer() {
    final user = Provider.of<User>(context);

    RoomDbService dbService = RoomDbService(widget.roomName, widget.roomID);

    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: FutureBuilder<String>(
        future: UserDbService(uid: user.uid).getNameFromUser(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return new Container(
                // Input box
                margin: const EdgeInsets.symmetric(horizontal: 9.0),
                child: Form(
                  key: _formKey,
                  child: new Row(
                    children: [
                      new Flexible(
                        child: new TextFormField(
                          controller: textController,
                          validator: (val) =>
                              val.isEmpty ? "Your reply cannot be empty" : null,
//                        onSubmitted: (String msg) {
//                          dbService.sendMessage(
//                              msg, snapshot.data, widget.questionID);
//                          _cleanUp();
//                        },
                          // submitting message will add the message in the database
                          decoration: new InputDecoration.collapsed(
                              hintText:
                                  "Enter some text to send a message"), // ???
                        ),
                      ),
                      new Container(
                          margin: new EdgeInsets.symmetric(horizontal: 3.0),
                          child:
                              Theme.of(context).platform == TargetPlatform.iOS
                                  ? new CupertinoButton(
                                      child: new Text("Submit"),
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {
                                          dbService.sendMessage(
                                              textController.text,
                                              snapshot.data,
                                              widget.questionID);
                                          _cleanUp();
                                        }
                                      },
                                    )
                                  : new IconButton(
                                      icon: new Icon(Icons.message),
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {
                                          dbService.sendMessage(
                                              textController.text,
                                              snapshot.data,
                                              widget.questionID);
                                          _cleanUp();
                                        }
                                      },
                                    )),
                    ],
                  ),
                ),
                decoration: Theme.of(context).platform == TargetPlatform.iOS
                    ? new BoxDecoration(
                        border: new Border(
                            top: new BorderSide(color: Colors.brown[200])))
                    : null);
          }
        },
      ),
    );
  }

  void _cleanUp() {
    textController.clear(); // clear input box
//    setState(() {
//      _isWriting = false;
//    });
//    Message msg = new Message(
//      text: text,
//      animationController: new AnimationController(
//          vsync: this, duration: new Duration(milliseconds: 800)),
//    );

//    setState(() {
//      _messages.insert(0, msg);
//    });

//    msg.animationController.forward();
  }

  @override
  void dispose() {
    // dispose each Message's animation controller, then call super.dispose()
//    for (Message msg in _messages) {
//      msg.animationController.dispose();
//    }
    super.dispose();
  }
}
