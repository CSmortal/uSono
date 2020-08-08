import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:orbital_2020_usono_my_ver/Services/database/RoomDbService.dart';
import 'package:orbital_2020_usono_my_ver/Shared/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class ChatRoomSettingsForm extends StatefulWidget {
  @override
  _ChatRoomSettingsFormState createState() => _ChatRoomSettingsFormState();
}

class _ChatRoomSettingsFormState extends State<ChatRoomSettingsForm> {
  String _currentRoomName = '';
  final _formKey = GlobalKey<FormState>();
  final RoomDbService _database = new RoomDbService();
  Position _location = Position(latitude: 0.0, longitude: 0.0);
  Geoflutterfire geo = Geoflutterfire();
  int _radius = 20;

  void _getCurrentLocation(String roomid) async {
    GeoFirePoint roomLocation;
    final location = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _location = location;
      roomLocation = geo.point(
          latitude: _location.latitude, longitude: _location.longitude);
    });

    Firestore.instance
        .collection('Rooms')
        .document(roomid)
        .setData({'position': roomLocation.data}, merge: true);
    Firestore.instance
        .collection('Rooms')
        .document(roomid)
        .setData({'Latitude': _location.latitude}, merge: true);
    Firestore.instance
        .collection('Rooms')
        .document(roomid)
        .setData({'Longitude': _location.longitude}, merge: true);
    Firestore.instance
        .collection('Rooms')
        .document(roomid)
        .setData({'Radius': _radius}, merge: true);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          new Text(
            "Room Name:",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          new SizedBox(
            height: 5,
          ),
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
          new SizedBox(
            height: 15,
          ),
          new Text(
            "Set the room radius: $_radius",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          new NumberPicker.integer(
              initialValue: _radius,
              minValue: 20,
              maxValue: 2000,
              onChanged: (newValue) => setState(() => _radius = newValue)),
          SizedBox(height: 15),
          RaisedButton(
            color: Colors.pink[400],
            child: Text("Let's create the room!",
                style: TextStyle(color: Colors.white)),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                String roomID =
                    await _database.createChatRoom(_currentRoomName);
                _getCurrentLocation(roomID);
                Navigator.pushNamed(context, '/QuestionPage', arguments: {
                  "roomName": _currentRoomName,
                  "roomID": roomID
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
