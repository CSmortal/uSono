import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:orbital_2020_usono_my_ver/Models/User.dart';
import 'package:orbital_2020_usono_my_ver/Services/database/RoomDbService.dart';
import 'package:orbital_2020_usono_my_ver/Services/database/UserDbService.dart';
import 'package:orbital_2020_usono_my_ver/Settings/ChatRoomSettings.dart';
import 'package:orbital_2020_usono_my_ver/Shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:orbital_2020_usono_my_ver/Services/auth.dart';
import 'package:orbital_2020_usono_my_ver/Models/db_User.dart';


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


//  Future retrieveUserName() async {
//    userName = await UserDbService(uid: user.uid).getNameFromUser();
//  }

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
                '/ChatRoomPage',
                arguments: {
                  "roomName": roomName,
                  "roomID": roomID,
                },
              ),
              child: Text('\n  $roomName',
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
                Colors.blue[100], document.data['roomName'], document.documentID);
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    // final dbUserList = Provider.of<List<db_User>>(context);
    final fs =  Firestore.instance;
    final user = Provider.of<User>(context);


    // assert(dbUserList != null);

    // find the name of the user, by finding the document whose documentID = user.uid, where user is the User object whose uid is the same as the FirebaseUser instance's uid property

    //final userName = dbUserList.singleWhere((element) => element.user.uid == user.uid).name;
//    querySS.documents.forEach((doc) => print(doc.documentID));




    return loading
        ? Loading()
        : Scaffold(
      backgroundColor: Colors.teal[200],

      body:
      CustomScrollView(
          slivers: <Widget> [
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
                    new FutureBuilder(
                      future: UserDbService(uid: user.uid).getNameFromUser(),
                      builder: (context, snapshot) {

                        if (snapshot.connectionState == ConnectionState.done) {
                          return new Text('Hello there, ${snapshot.data}',
                            style: TextStyle(fontSize: 20,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.left,
                          );
                        } else {
                          return CircularProgressIndicator();
                        }

                      }
                    ),
                    //new Text(alias, style:
                    //  TextStyle(fontSize: 16,
                    //      fontStyle: FontStyle.italic),
                    //  textAlign: TextAlign.center,),
                    const Text('These are the rooms around you\n\n\n',
                      style:(TextStyle(fontSize: 12,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w400
                      )),
                      textAlign: TextAlign.center,),
                  ],
                ),
              ),

              actions: <Widget>[

                FlatButton( // Beautify later
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

              ],

            ),
            SliverFixedExtentList(
                itemExtent: 500,
                delegate: SliverChildListDelegate(
                    [
                      _roomList(),
//                          _buildListWidget(Colors.teal[100], 'CS1010X Lecture Room'),
//                          _buildListWidget(Colors.blue[100], 'CS2040C Lecture Chat'),
//                          _buildListWidget(Colors.teal[100], 'Random Seminar'),
                    ]
                )
            ),]
      ),
    );
  }
}


