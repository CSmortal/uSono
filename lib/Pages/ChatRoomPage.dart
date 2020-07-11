import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ChatRoomPage extends StatefulWidget {
//  final String text;
//  ChatRoomPage(this.text);
  @override
  State createState() => new _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage>
    with TickerProviderStateMixin {
//  final String text;
//   _ChatRoomPageState(this.text);

  final List<Message> _messages = <Message>[];
  final TextEditingController textController = new TextEditingController();
  bool _isWriting = false;

  @override
  Widget build(BuildContext context) {
    final querySS = Provider.of<QuerySnapshot>(context);

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
              // remove this???
              "Placeholder text", // we need to change this to the chatroom name, by accessing firestore
              style: (TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w300,
              )),
            ),
          ),
        ),
        new Flexible(
          // default fit is FlexFit.loose. Use flexible widgets if you want children widgets to change their size relative to the parent widget
          child: new ListView.builder(
            itemBuilder: (_, int index) => _messages[
                index], // each widget in the list is a Message from _messages
            itemCount: _messages.length,
            reverse: true,
            padding: new EdgeInsets.all(6),
          ),
        ),
        new Divider(height: 1),
        new Container(
          // Input box
          child: _buildComposer(),
          decoration: new BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
        )
      ],
    ));
  }

  Widget _buildComposer() {
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
                  onChanged: (String text) {
                    setState(() {
                      _isWriting = text.length > 0;
                    });
                  },
                  onSubmitted: _submitMsg,
                  decoration: new InputDecoration.collapsed(
                      hintText: "Enter some text to send a message"), // ???
                ),
              ),
              new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 3.0),
                  child: Theme.of(context).platform == TargetPlatform.iOS
                      ? new CupertinoButton(
                          child: new Text("Submit"),
                          onPressed: _isWriting
                              ? () => _submitMsg(textController.text)
                              : null // ???
                          )
                      : new IconButton(
                          icon: new Icon(Icons.message),
                          onPressed: _isWriting
                              ? () => _submitMsg(textController.text)
                              : null, // ???
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

  void _submitMsg(String text) {
    textController.clear(); // clear input box
    setState(() {
      _isWriting = false;
    });

    Message msg = new Message(
      text: text,
      animationController: new AnimationController(
          vsync: this, duration: new Duration(milliseconds: 800)),
    );

    setState(() {
      _messages.insert(0, msg);
    });

    msg.animationController.forward();
  }

  @override
  void dispose() {
    // dispose each Message's animation controller, then call super.dispose()
    for (Message msg in _messages) {
      msg.animationController.dispose();
    }
    super.dispose();
  }
}

class Message extends StatelessWidget {
  final String text;
  final AnimationController animationController;
  static String defaultUserName = "You";

  Message({this.text, this.animationController});

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
        // SizeTransition wraps around the widget that it wants to animate, in this case Container.
        sizeFactor: new CurvedAnimation(
          parent: animationController,
          curve: Curves
              .bounceOut, // affects animation of newly submitted messages popping out in the flexible widget
        ),
        axisAlignment: 0.0, // ??
        child: new Container(
            color: Colors.teal[100],
            margin: const EdgeInsets.symmetric(
                vertical:
                    8), // affects the vertical gap between messages in the ListView
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.start, // ??
              children: [
                new Container(
                  margin: const EdgeInsets.only(
                      right: 18), // gap between Icon and the text
                  child: new CircleAvatar(child: new Text(defaultUserName[0])),
                ),
                new Expanded(
                    child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    new Text(defaultUserName,
                        style: Theme.of(context).textTheme.subtitle1),
                    new Container(
                      margin: const EdgeInsets.only(top: 6),
                      child: new Text(text),
                    )
                  ],
                )),
              ],
            )));
  }
}
