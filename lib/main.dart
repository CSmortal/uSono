import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:orbital_2020_usono_my_ver/Pages/SignInPage.dart';
import 'package:orbital_2020_usono_my_ver/Pages/ChatRoomPage.dart';
import 'package:orbital_2020_usono_my_ver/Pages/SelectionPage(Home).dart';
import 'package:orbital_2020_usono_my_ver/Services/authentication.dart';
import 'Services/models.dart';
import 'package:orbital_2020_usono_my_ver/Services/models.dart';

void main() => runApp(ChatApp());

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(value: AuthService().user),
        StreamProvider<QuerySnapshot>.value(
            value: Firestore.instance.collection("Users").snapshots()),
//        StreamProvider<QuerySnapshot>.value(
//            value: Firestore.instance.collection("Rooms").snapshots()),
      ],
      child: MaterialApp(
        home: Wrapper(),
        onGenerateRoute: RouteHandler
            .generateRoute, // callback used when app is navigated to a named route
      ),
    );
  }
}

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}

class RouteHandler {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // onGenerateRoute callback will create a RouteSettings object
    final args = settings.arguments;

    switch (settings.name) {
//      case '/':
//        return MaterialPageRoute(builder: (_) => LoginPage());
//      case '/SelectionPage':
//        return MaterialPageRoute(builder: (_) => SelectionPage(args));

      // perhaps we could just use Navigator.pop(context) to return from the ChatRoomPage back to the Home() widget.
      case '/ChatRoomPage':
        print('Reached route handler...');
        return MaterialPageRoute(builder: (_) => ChatRoomPage());
      //MaterialPageRoute<T> replaces the entire screen with a platform
      //adaptive transition
      default:
        return _errorRoute();
    }
  }

  //Could be better accomplished with its own class
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Text('Error'),
        ),
      );
    });
  }
}
