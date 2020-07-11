import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:orbital_2020_usono_my_ver/Services/authentication.dart';
import 'package:orbital_2020_usono_my_ver/Services/models.dart';
import 'package:orbital_2020_usono_my_ver/Services/constants.dart';

class Home extends StatefulWidget {
  //SelectionPage({Key key, @required this.alias}) : super(key: key);
  @override
  State createState() =>
      new _HomeState(); // Framework calls createState() when the stateful element has been created
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  final Firestore firestoreInstance = Firestore.instance;
  Position _location = Position(latitude: 0.0, longitude: 0.0);

  bool loading = false;

  void _showSettingsPanel() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
            child: ChatRoomSettingsForm(),
          );
        });
  }

  void _getCurrentLocation(var uid) async {
    final location = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _location = location;
    });

    firestoreInstance
        .collection("Users")
        .document(uid)
        .setData({"Coordinates": location});
  }

  Widget _buildListWidget(Color color, var text) {
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
                '/ChatRoomPage',
                arguments: text,
              ),
              child: Text('\n  $text',
                  style: TextStyle(color: Colors.white, fontSize: 25)),
            )));
  }

  Widget _roomList() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Rooms').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return new ListView(
          children: snapshot.data.documents.map((document) {
            return _buildListWidget(
                Colors.blue[100], document.data['roomName']);
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final querySS = Provider.of<QuerySnapshot>(context);
    final firestoreInstance = Firestore.instance;

    roomDBservice database = new roomDBservice();

    // find the name of the user, by finding the document whose documentID = user.uid, where user is the User object whose uid is the same as the FirebaseUser instance's uid property
    final userName = querySS.documents
        .singleWhere((doc) => doc.documentID == user.uid)
        .data["Name"];
//    querySS.documents.forEach((doc) => print(doc.documentID));

    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.teal[200],
            body: CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                leading: RaisedButton.icon(
                  label: Text("Create Room"), // Overflow error
                  icon: Icon(Icons.add),

                  onPressed: () => _showSettingsPanel(),
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
                      new Text(
                        'Hello there, ${userName}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.left,
                      ),
                      //new Text(alias, style:
                      //  TextStyle(fontSize: 16,
                      //      fontStyle: FontStyle.italic),
                      //  textAlign: TextAlign.center,),
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
                      setState(() => loading = true);
                      await _auth.signOut();

//                        if (result == null) {
//                          setState(() => {
//                            loading = false,
//                            print("Failed to logout. Please wait...") // Might need to change later
//                          });
//                        }
                    },
                    splashColor: Colors.white,
                  ),
                  FlatButton(
                    child: Text('Refresh'),
                    onPressed: () async {
                      _getCurrentLocation(user.uid);
                    },
                  )
                ],
              ),
              SliverFixedExtentList(
                  itemExtent: 500,
                  delegate: SliverChildListDelegate([
                    _roomList(),
//                          _buildListWidget(Colors.teal[100], 'CS1010X Lecture Room'),
//                          _buildListWidget(Colors.blue[100], 'CS2040C Lecture Chat'),
//                          _buildListWidget(Colors.teal[100], 'Random Seminar'),
                  ])),
            ]),
          );
  }
}

class ChatRoomSettingsForm extends StatefulWidget {
  @override
  _ChatRoomSettingsFormState createState() => _ChatRoomSettingsFormState();
}

class _ChatRoomSettingsFormState extends State<ChatRoomSettingsForm> {
  String _currentRoomName = '';
  final _formKey = GlobalKey<FormState>();
  final roomDBservice _database = new roomDBservice();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            validator: (value) => value.length < 4
                ? 'Room Names should be at least 4 characters long'
                : null,
            onChanged: (text) {
              setState(() {
                _currentRoomName = text;
              });
            },
            decoration: textInputDecoration,
          ),
          SizedBox(height: 15),
          RaisedButton(
            color: Colors.pink[400],
            child: Text("Let's create the room!",
                style: TextStyle(color: Colors.white)),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                // create a collection which is to be named after _currentRoomName
                dynamic result =
                    await _database.createChatRoom(_currentRoomName);

                Navigator.pushNamed(context, '/ChatRoomPage');

//                if (result = null) { // need to do testing
//                  print("if");
//                } else {
//                  print("else");
//                }

                // After creating the room, we want to enter the room, so use Navigator...
              }
            },
          ),
        ],
      ),
    );
  }
}
