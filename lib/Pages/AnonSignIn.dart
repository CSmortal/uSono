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
<<<<<<< HEAD
                backgroundColor: Colors.white,
=======
                backgroundColor: Colors.teal[200],
>>>>>>> 441afef62367a279c37266b11eb51c1a598e4e13
                body: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(children: <Widget>[
                          new SizedBox(
                            height: 80,
                          ),
<<<<<<< HEAD
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
=======
                          FlutterLogo(
                            // size: _iconAnimation.value * 100,
                            size: 100,
                          ),
>>>>>>> 441afef62367a279c37266b11eb51c1a598e4e13
                          new Form(
                            key: _formKey,
                            child: new Theme(
                              data: new ThemeData(
<<<<<<< HEAD
                                brightness: Brightness.light,
                                primarySwatch: Colors.blueGrey,
                                inputDecorationTheme: new InputDecorationTheme(
                                  labelStyle: new TextStyle(
                                    fontSize: 20,
                                    color: Colors.black26,
=======
                                brightness: Brightness.dark,
                                primarySwatch: Colors.teal,
                                inputDecorationTheme: new InputDecorationTheme(
                                  labelStyle: new TextStyle(
                                    fontSize: 20,
>>>>>>> 441afef62367a279c37266b11eb51c1a598e4e13
                                  ),
                                ),
                              ),
                              child: new Container(
<<<<<<< HEAD
                                padding: const EdgeInsets.fromLTRB(
                                    40.0, 0.0, 40.0, 0.0),
                                child: new Column(
                                  children: <Widget>[
=======
                                padding: const EdgeInsets.all(40.0),
                                child: new Column(
                                  children: <Widget>[
                                    new Text('uSono'),
>>>>>>> 441afef62367a279c37266b11eb51c1a598e4e13
                                    new TextFormField(
                                        validator: (val) => val.length < 3
                                            ? 'Your name has to be at least 3 characters long.'
                                            : null,
                                        decoration: new InputDecoration(
<<<<<<< HEAD
                                            labelText:
                                                "What would you like to be called?",
                                            labelStyle: TextStyle(
                                                color: Colors.black54)),
=======
                                          labelText:
                                              "What would you like to be called?",
                                        ),
>>>>>>> 441afef62367a279c37266b11eb51c1a598e4e13
                                        // controller: _aliasController,
                                        onChanged: (text) {
                                          setState(() {
                                            name = text;
                                          });
                                        }),
                                    Container(
<<<<<<< HEAD
                                      height: 30,
=======
                                      height: 40,
>>>>>>> 441afef62367a279c37266b11eb51c1a598e4e13
                                      child: Text(error),
                                    ),
                                    MaterialButton(
                                      height: 40,
                                      minWidth: 60,
<<<<<<< HEAD
                                      color: Colors.grey[100],
                                      textColor: Colors.black,
                                      child: new Text(
                                        "Enter Anonymously!",
                                        style: TextStyle(color: Colors.black54),
                                      ),
=======
                                      color: Colors.white,
                                      textColor: Colors.black,
                                      child: new Text("Enter Anonymously!"),
>>>>>>> 441afef62367a279c37266b11eb51c1a598e4e13
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
<<<<<<< HEAD
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
=======
                                    SizedBox(height: 18),
                                    Text("or"),
                                    SizedBox(height: 18),
                                    MaterialButton(
                                      height: 40,
                                      minWidth: 60,
                                      color: Colors.white,
                                      textColor: Colors.black,
                                      child: new Text("Return to Login Page"),
>>>>>>> 441afef62367a279c37266b11eb51c1a598e4e13
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
