import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:orbital_2020_usono_my_ver/Models/User.dart';
import 'package:orbital_2020_usono_my_ver/Services/database/UserDbService.dart';
import 'package:orbital_2020_usono_my_ver/Settings/AllSettingsPanel.dart';
import 'package:orbital_2020_usono_my_ver/Shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:orbital_2020_usono_my_ver/Services/auth.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';

class Home extends StatefulWidget {
  //SelectionPage({Key key, @required this.alias}) : super(key: key);
  @override
  State createState() =>
      new _HomeState(); // Framework calls createState() when the stateful element has been created
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  final Firestore firestoreInstance = Firestore.instance;
  bool loading = false;
  Position _position = Position(latitude: 0.0, longitude: 0.0);
  StreamSubscription<Position> _positionStream;
  Geoflutterfire geo = Geoflutterfire();
  Firestore _firestore = Firestore.instance;
  Stream<List<DocumentSnapshot>> stream;
  var radius = BehaviorSubject<double>.seeded(1.0);

  @override
  void initState() {
    super.initState();
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);
    _positionStream = Geolocator()
        .getPositionStream(locationOptions)
        .listen((Position position) {
      _position = position;
    });
  }

  Widget _roomList() {
    return StreamBuilder(stream: radius.switchMap((rad) {
      var collectionRef = _firestore.collection('Rooms');
      // print(_position.latitude);
      // print(_position.longitude);
      return geo.collection(collectionRef: collectionRef).within(
          center: geo.point(
              latitude: _position.latitude, longitude: _position.longitude),
          radius: 0.175,
          field: 'position',
          strictMode: false);
    }), builder: (BuildContext context,
        AsyncSnapshot<List<DocumentSnapshot>> snapshots) {
      if (snapshots.hasError) return new Text('Error; ${snapshots.error}');
      switch (snapshots.connectionState) {
        case ConnectionState.waiting:
          return new Text('Loading...');
        default:
          return new ListView(
            children: snapshots.data.map((document) {
              return _buildListWidget(Colors.blue[100],
                  document.data['roomName'], document.documentID);
            }).toList(),
          );
      }
    });
  }

  Widget _buildListWidget(Color color, String roomName, String roomID) {
    return Container(
        height: 150,
        child: Card(
            semanticContainer: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            margin: EdgeInsets.all(10),
            color: color,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                '/QuestionPage',
                arguments: {
                  "roomName": roomName,
                  "roomID": roomID,
                },
              ),
              child: Text('\n  $roomName',
                  style: TextStyle(color: Colors.white, fontSize: 25)),
            )));
  }

  @override
  Widget build(BuildContext context) {
    final fs = Firestore.instance;
    final user = Provider.of<User>(context);
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.teal[200],
            body: CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                leading: RaisedButton.icon(
                  label: Text("Create Room"), // Overflow error
                  icon: Icon(Icons.add),

                  onPressed: () => AllSettingsPanel()
                      .showSettingsPanel(context, SettingsPanel.chatRoom),
                ),
                expandedHeight: 200.0,
                floating: true,
                pinned: true,
                backgroundColor: Colors.red[200],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.black12,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new FutureBuilder(
                          future:
                              UserDbService(uid: user.uid).getNameFromUser(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return new Text(
                                'Hello there, ${snapshot.data}',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                                textAlign: TextAlign.left,
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          }),
                      const Text(
                        'These are the rooms around you\n\n\n',
                        style: (TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w400)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    // Beautify later
                    child: Text('Logout'),
                    onPressed: () async {
                      // print(_position.latitude);
                      // print(_position.longitude);
                      setState(() => loading = true);
                      await _auth.signOut();
                    },
                    splashColor: Colors.white,
                  ),
                ],
              ),
              SliverFixedExtentList(
                  itemExtent: 500,
                  delegate: SliverChildListDelegate([
                    _roomList(),
                  ])),
            ]),
          );
  }
}
