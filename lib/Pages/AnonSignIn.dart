import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:orbital_2020_usono_my_ver/Services/auth.dart';
import 'package:orbital_2020_usono_my_ver/Pages/SignIn.dart';
import 'package:orbital_2020_usono_my_ver/Shared/constants.dart';
import 'package:flutter/material.dart';

class AnonSignIn extends StatefulWidget {
  @override
  State createState() => new _AnonSignInState();
}

class _AnonSignInState extends State<AnonSignIn> {
  // new variables we adding for authentication
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final Firestore firestoreInstance = Firestore.instance;

  String error = '';
  String name = '';

  bool backToSignIn = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return backToSignIn
        ? SignIn()
        : loading
        ? Loading()
        : Scaffold(
      backgroundColor: Colors.teal[200],
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          //[<image widget to be inserted>
          //],
          new Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: SizedBox.expand(),
              ),
              FlutterLogo(
                // size: _iconAnimation.value * 100,
                size: 100,
              ),
              Flexible(
                flex: 4,
                child: new Form(
                  key: _formKey,
                  child: new Theme(
                    data: new ThemeData(
                      brightness: Brightness.dark,
                      primarySwatch: Colors.teal,
                      inputDecorationTheme: new InputDecorationTheme(
                        labelStyle: new TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    child: new Container(
                      padding: const EdgeInsets.all(40.0),
                      child: new Column(
                        children: <Widget>[
                          new Text('uSono'),
                          new TextFormField(
                              validator: (val) => val.length < 3
                                  ? 'Your name has to be at least 3 characters long.'
                                  : null,
                              decoration: new InputDecoration(
                                labelText:
                                "What would you like to be called?",
                              ),
                              // controller: _aliasController,
                              onChanged: (text) {
                                setState(() {
                                  name = text;
                                });
                              }),
                          Container(
                            height: 40,
                            child: Text(error),
                          ),
                          MaterialButton(
                            height: 40,
                            minWidth: 60,
                            color: Colors.white,
                            textColor: Colors.black,
                            child: new Text("Enter Anonymously!"),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                dynamic result =
                                await _auth.signInAnon();
                                if (result == null) {
                                  setState(() {
                                    error = 'Oops! There is an error';
                                  });
                                } else {
                                  firestoreInstance
                                      .collection("Users")
                                      .document(result.uid)
                                      .setData({
                                    "Name": name,
                                  });
                                } // no need for else block
                              }
                            },
                          ),
                          SizedBox(height: 18),
                          Text("or"),
                          SizedBox(height: 18),
                          MaterialButton(
                            height: 40,
                            minWidth: 60,
                            color: Colors.white,
                            textColor: Colors.black,
                            child: new Text("Return to Login Page"),
                            onPressed: () {
                              setState(() {
                                backToSignIn = true;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}