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
                backgroundColor: Colors.white,
                body: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(children: <Widget>[
                          new SizedBox(
                            height: 80,
                          ),
                          Container(
                              margin: const EdgeInsets.fromLTRB(
                                  0.0, 50.0, 0.0, 0.0),
                              height: 325.0,
                              width: 375.0,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                'images/ivox_logo3.PNG',
                              )))),
                          new Form(
                            key: _formKey,
                            child: new Theme(
                              data: new ThemeData(
                                brightness: Brightness.light,
                                primarySwatch: Colors.blueGrey,
                                inputDecorationTheme: new InputDecorationTheme(
                                  labelStyle: new TextStyle(
                                    fontSize: 20,
                                    color: Colors.black26,
                                  ),
                                ),
                              ),
                              child: new Container(
                                padding: const EdgeInsets.fromLTRB(
                                    40.0, 0.0, 40.0, 0.0),
                                child: new Column(
                                  children: <Widget>[
                                    new TextFormField(
                                        validator: (val) => val.length < 3
                                            ? 'Your name has to be at least 3 characters long.'
                                            : null,
                                        decoration: new InputDecoration(
                                            labelText:
                                                "What would you like to be called?",
                                            labelStyle: TextStyle(
                                                color: Colors.black54)),
                                        // controller: _aliasController,
                                        onChanged: (text) {
                                          setState(() {
                                            name = text;
                                          });
                                        }),
                                    Container(
                                      height: 30,
                                      child: Text(error),
                                    ),
                                    MaterialButton(
                                      height: 40,
                                      minWidth: 60,
                                      color: Colors.grey[100],
                                      textColor: Colors.black,
                                      child: new Text(
                                        "Enter Anonymously!",
                                        style: TextStyle(color: Colors.black54),
                                      ),
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
                                    SizedBox(height: 5.0),
                                    Text("or",
                                        style:
                                            TextStyle(color: Colors.black54)),
                                    SizedBox(height: 5.0),
                                    MaterialButton(
                                      height: 40,
                                      minWidth: 60,
                                      color: Colors.grey[100],
                                      textColor: Colors.black,
                                      child: new Text("Return to Login Page",
                                          style:
                                              TextStyle(color: Colors.black54)),
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
                        ]),
                      ),
                    ),
                  ],
                ),
              );
  }
}
