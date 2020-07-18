import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:orbital_2020_usono_my_ver/Models/Message.dart';
import 'package:orbital_2020_usono_my_ver/Models/User.dart';
import 'package:orbital_2020_usono_my_ver/Services/database/RoomDbService.dart';
import 'package:orbital_2020_usono_my_ver/Services/database/UserDbService.dart';
import 'package:provider/provider.dart';

class ChatRoomPage extends StatefulWidget {
  final String roomName;
  final String roomID;

  ChatRoomPage(Map<String,String> map) : this.roomName = map["roomName"], this.roomID = map["roomID"];

  @override
  State createState() => new _ChatRoomPageState(roomName, roomID);
}

class _ChatRoomPageState extends State<ChatRoomPage> with TickerProviderStateMixin {
   final String roomName;
   final String roomID;
   final TextEditingController textController = TextEditingController();

   _ChatRoomPageState(this.roomName, this.roomID);

//  final List<Message> _messages = <Message>[];
//  bool _isWriting = false;

  @override
  Widget build(BuildContext context) {

    RoomDbService dbService = RoomDbService(roomName, roomID);
    print("building ChatRoomPage()...");
    return new Scaffold(
        //appBar: new AppBar(
        //  title: new Text(text),
        // elevation: Theme.of(context).platform =
        //),

        body: new Column(
          children: [
            new Container(
              color: Colors.red[200],
              constraints: BoxConstraints.expand(width: 400.0, height: 100.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  roomName, // we need to change this to the chatroom name, by accessing firestore
                  style: (TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w300,
                  )),
                ),
              ),
            ),

            new Flexible(
              flex: 8,
              child: StreamBuilder<QuerySnapshot>(
                stream: dbService.getRoomMessages(),
                builder: (context, snapshot) {

                  if (!snapshot.hasData) {
                    print("Snapshot connectionState: " + "${snapshot.connectionState}");

                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return Message(
                            text: snapshot.data.documents[index].data["text"],
                            animationController: new AnimationController( // still need to do the animation
                                vsync: this,
                                duration: new Duration(milliseconds: 800))
                        );
                      },

                    );
                  }

                },
              ),
            ),

//            new Flexible(
//              // default fit is FlexFit.loose. Use flexible widgets if you want children widgets to change their size relative to the parent widget
//              child: new ListView.builder(
//                itemBuilder: (_, int index) => _messages[
//                    index], // each widget in the list is a Message from _messages
//                itemCount: _messages.length,
//                reverse: true,
//                padding: new EdgeInsets.all(6),
//              ),
//            ),

            new Divider(height: 1),

            new Flexible(
              // Input box
              flex: 1,
              child: _buildComposer(),
//              decoration: new BoxDecoration(
//                color: Theme.of(context).cardColor,
//              ),
            )
          ],
    ));
  }

  Widget _buildComposer() {

    final user = Provider.of<User>(context);
    String userName = '';
    UserDbService(uid: user.uid).getNameFromUser().then((result) => userName = result);

    RoomDbService dbService = RoomDbService(roomName, roomID);


    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
          // Input box
          margin: const EdgeInsets.symmetric(horizontal: 9.0),
          child: new Row(
            children: [
              new Flexible(
                child: new TextField(
                  controller: textController,

//                  onChanged: (String text) {
//                    setState(() {
//                      _isWriting = text.length > 0;
//                      currentText = text;
//                    });
//                  },

                  onSubmitted: (String msg) {
                    dbService.sendMessage(msg, userName);
                    _cleanUp();
                  },
                  // submitting message will add the message in the database
                  decoration: new InputDecoration.collapsed(
                      hintText: "Enter some text to send a message"), // ???
                ),
              ),

              new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 3.0),
                  child: Theme.of(context).platform == TargetPlatform.iOS
                      ? new CupertinoButton(
                          child: new Text("Submit"),
                          onPressed: () {
                            dbService.sendMessage(textController.text, userName);
                            _cleanUp();
//                            if (_isWriting) {
//
//                            } else {
//                              return null;
//                            }
                          },
                        )
                      : new IconButton(
                          icon: new Icon(Icons.message),

                          onPressed: () {
                            dbService.sendMessage(textController.text, userName);
                            _cleanUp();
//                            if (_isWriting) {
//
//                            } else {
//                              return null;
//                            }
                          },
                        )),
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? new BoxDecoration(
                  border:
                      new Border(top: new BorderSide(color: Colors.brown[200])))
              : null),
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


