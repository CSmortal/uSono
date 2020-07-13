import 'package:flutter/material.dart';
import 'package:orbital_2020_usono_my_ver/Pages/ChatRoomPage.dart';


class RouteHandler{
  static Route<dynamic> generateRoute(RouteSettings settings){ // onGenerateRoute callback will create a RouteSettings object
    final args = settings.arguments;

    switch(settings.name) {
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
  static Route<dynamic> _errorRoute(){
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Text('Error'),
        ),
      );
    });
  }
}