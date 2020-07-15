import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  final String text;

  final AnimationController animationController;
  static String defaultUserName = "You";

  Message({this.text, this.animationController});

  @override
  Widget build(BuildContext context) {
    return new SizeTransition( // SizeTransition wraps around the widget that it wants to animate, in this case Container.
        sizeFactor: new CurvedAnimation(
          parent: animationController,
          curve: Curves.bounceOut, // affects animation of newly submitted messages popping out in the flexible widget
        ),
        axisAlignment: 0.0, // ??
        child: new Container(
            color: Colors.teal[100],
            margin: const EdgeInsets.symmetric(vertical: 8), // affects the vertical gap between messages in the ListView
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.start, // ??
              children: [
                new Container(
                  margin: const EdgeInsets.only(right: 18), // gap between Icon and the text
                  child: new CircleAvatar(
                      child: new Text(defaultUserName[0])),
                ),
                new Expanded(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        new Text(defaultUserName, style: Theme.of(context).textTheme.subtitle1),
                        new Container(
                          margin: const EdgeInsets.only(top: 6),
                          child: new Text(text),
                        )
                      ],
                    )
                ),
              ],
            )
        )
    );
  }
}