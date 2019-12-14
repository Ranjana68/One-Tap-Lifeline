import 'package:flutter/material.dart';
import 'package:signup_login_app/Home/Home.dart';
import 'package:signup_login_app/firebase_auth_utils.dart';
import 'Login.dart';

// Horizontal 1 % = 3.55
// Vertical   1 % = 7.75

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "One Tap Lifeline",
      debugShowCheckedModeBanner: false,
      home: MyAppHome(auth: MyAuth()),
    );
  }
}

class MyAppHome extends StatefulWidget {
  MyAppHome({this.auth});
  AuthFunc auth;

  @override
  State<StatefulWidget> createState() => _MyAppHomeState();
}

enum AuthStatus { NOT_LOGIN, NOT_DETERMINED, LOGIN }

class _MyAppHomeState extends State<MyAppHome> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "", _userEmail = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
          _userEmail = user?.email;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGIN : AuthStatus.LOGIN;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return _showLoading();
        break;
      case AuthStatus.NOT_LOGIN:
        return Login(auth: widget.auth, onSignedIn: _onSignedIn);
        break;
      case AuthStatus.LOGIN:
        if (_userId.length > 0 && _userId != null) {
          return Home(
              userId: _userId,
              userEmail: _userEmail,
              auth: widget.auth,
              onSignOut: _onSignOut);
        } else
          return _showLoading();
        break;
      default:
        return _showLoading();
        break;
    }
  }

  void _onSignOut() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGIN;
      _userId = _userEmail = "";
    });
  }
  void out(){
    _onSignOut();
  }

  void _onSignedIn() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
        _userEmail = user.email.toString();
      });

      setState(() {
        authStatus = AuthStatus.LOGIN;
      });
    });
  }
}

Widget _showLoading() {
  return Scaffold(
    body: Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    ),
  );
}
