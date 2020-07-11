import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:orbital_2020_usono_my_ver/Services/authentication.dart';
import 'RegisterPage.dart';
import 'package:orbital_2020_usono_my_ver/Services/constants.dart';

class anonSignIn extends StatefulWidget {
  @override
  State createState() => new _anonSignInState();
}

class _anonSignInState extends State<anonSignIn> {
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

class Authenticate extends StatefulWidget {
  @override
  State createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  @override
  Widget build(BuildContext context) {
    // we will either return a signIn() widget or an anonSignIn() widget here
    void toggleView() {
      setState(() => showSignIn = !showSignIn);
    }

    if (showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}

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
            ? anonSignIn()
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

                  body: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
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
              );
  }
}
