import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:orbital_2020_usono_my_ver/Pages/AnonSignIn.dart';
import 'package:orbital_2020_usono_my_ver/Services/auth.dart';
import 'package:orbital_2020_usono_my_ver/Shared/constants.dart';


class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false; // show loading widget if true

  // text field state
  String email = '';
  String password = '';
  String error = '';

  bool anon = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : anon // checks if the user wants to sign in anoynymously or not
            ? AnonSignIn()
            : Theme(
                data: new ThemeData(
                  brightness: Brightness.light,
                  primarySwatch: Colors.teal,
                  inputDecorationTheme: new InputDecorationTheme(
                    labelStyle: new TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                child: Scaffold(
                  resizeToAvoidBottomInset: false, // Lazy way of avoiding bottom overflow when keyboard appears
                  // 2nd solution: https://medium.com/zipper-studios/the-keyboard-causes-the-bottom-overflowed-error-5da150a1c660
//                  backgroundColor: Colors.brown[100],
                  appBar: AppBar(
                    // leading: Container(width: 36, color: Colors.red),
//                    backgroundColor: Colors.brown[400],
                    elevation: 20.0,
                    title: Center(
                      child: Text("uSono"),
                    ),
                    actions: [
                      FlatButton.icon(
                          icon: Icon(Icons.person),
                          label: Text('Register'),
                          onPressed: () {
                            widget
                                .toggleView(); // widget is a property of the State class, that returns the corresponding StatefulWidget instance, in this case an instance of SignIn
                          })
                    ],

                    centerTitle: true,
                  ),

                  body: Column(
                    children: [
                      // Padding(padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0)),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                          child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  TextFormField(
                                      decoration: textInputDecoration.copyWith(
                                          hintText: 'Email'),
                                      validator: (val) =>
                                      val.isEmpty ? 'Enter an email' : null,
                                      onChanged: (val) {
                                        setState(() => email = val);
                                      }),
                                  SizedBox(height: 20),
                                  TextFormField(
                                      decoration: textInputDecoration.copyWith(
                                          hintText: 'Password'),
                                      obscureText: true,
                                      validator: (val) => val.length < 6
                                          ? 'Enter a password 6+ chars long'
                                          : null,
                                      onChanged: (val) {
                                        setState(() => password = val);
                                      }),
                                  SizedBox(height: 20),
                                  Column(children: [
                                    RaisedButton(
                                        color: Colors.pink[400],
                                        child: Text('Sign In',
                                            style: TextStyle(color: Colors.white)),
                                        onPressed: () async {
                                          if (_formKey.currentState.validate()) {
                                            // validates form based on form's state, using the validator properties in each FormField
                                            setState(() {
                                              // show loading widget if form is valid
                                              loading = true;
                                            });

                                            // entire Form is valid if all validators return null
                                            dynamic result =
                                            await _auth.signInWithEmailAndPassword(
                                                email, password);

                                            if (result == null) {
                                              print("No record of this user");
                                              setState(() {
                                                error =
                                                'COULD NOT SIGN IN WITH THOSE CREDENTIALS';
                                                loading =
                                                false; // no longer display loading widget if ...
                                              });
                                            }
                                          }
                                        }),
                                    SizedBox(height: 12),
                                    RaisedButton(
                                        color: Colors.pink[400],
                                        child: Text('Guest Sign In',
                                            style: TextStyle(color: Colors.white)),
                                        onPressed: () {
                                          setState(() {
                                            anon = true;
                                          });
                                        }),
                                  ]),
                                  SizedBox(height: 12),
                                  Text(
                                    error,
                                    style: TextStyle(color: Colors.red, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                        ),
                        ),
                    ],
                  ),
                ),
              );
  }
}
