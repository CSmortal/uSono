import 'package:flutter/material.dart';
import 'package:orbital_2020_usono_my_ver/Services/database/RoomDbService.dart';
import 'package:orbital_2020_usono_my_ver/Shared/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomSettingsForm extends StatefulWidget {
  @override
  _ChatRoomSettingsFormState createState() => _ChatRoomSettingsFormState();
}

class _ChatRoomSettingsFormState extends State<ChatRoomSettingsForm> {
  String _currentRoomName = '';
  final _formKey = GlobalKey<FormState>();
  final RoomDbService _database = new RoomDbService();
  Position _location = Position(latitude: 0.0, longitude: 0.0);

  void _getCurrentLocation(String roomid) async {
    final location = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _location = location;
    });

    Firestore.instance.collection('Rooms').document(roomid).setData({
      'Latitude': _location.latitude,
      'Longitude': _location.longitude,
    }, merge: true);
  }

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
                _getCurrentLocation(result.documentID);
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
