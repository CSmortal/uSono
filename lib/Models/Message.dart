import 'package:flutter/material.dart';
import 'package:orbital_2020_usono_my_ver/Models/User.dart';
import 'package:orbital_2020_usono_my_ver/Services/database/UserDbService.dart';
import 'package:provider/provider.dart';

class Message extends StatelessWidget {
  final String text;
  final String sender;

//  final AnimationController animationController;
//  static String defaultUserName = "You";

  Message({this.text, this.sender});

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
        color: Colors.teal[100],
        margin: const EdgeInsets.symmetric(vertical: 8),
        // affects the vertical gap between messages in the ListView
        child: FutureBuilder<String>(
            future: UserDbService(uid: user.uid).getNameFromUser(),
            builder: (context, snapshot) {

              if (!snapshot.hasData) {
                return Container();
              } else {
                String userName = snapshot.data;

                userName == sender ? displayName = "You" : displayName = sender;

                return new Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // ??
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
                );
              }

            }
        )
    );
//    );
  }
}