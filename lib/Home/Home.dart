import 'package:flutter/material.dart';
import 'package:signup_login_app/Home/LiveLocation.dart';
import 'package:signup_login_app/Home/subHome.dart';
import '../firebase_auth_utils.dart';
import 'package:signup_login_app/size_conifg.dart';
import 'call.dart';
import 'sms.dart';
import 'package:lamp/lamp.dart';
import 'package:permission/permission.dart';
import 'CallCrud.dart';

class Home extends StatefulWidget {
  AuthFunc auth;
  VoidCallback onSignOut;
  String userId, userEmail;

  Home({Key key, this.auth, this.onSignOut, this.userId, this.userEmail})
      : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isEmailVerified = false;

  requestCameraPermission() async {
    final res = await Permission.requestPermissions([PermissionName.Camera,]);
    res.forEach((permission) {
      String a = '${permission.permissionStatus}';
      setState(() {
        if (a == 'PermissionStatus.allow') {
          Lamp.turnOn();
        }
        else {
          Permission.openSettings;
        }
      });
    });
  }
  //int _selectedIndex = 1;

  /*

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  List<Widget> _widgetOptions=<Widget>[
    Text('WORK PAGE HERE',style: TextStyle(fontSize: 36.0),),
    SubHome(),
    Text('SETTINGS',style: TextStyle(fontSize: 36.0),),
    /*
    HomePage(),
    WorkPage(),
    SettingsPage(),
    */
  ];
  */

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkEmailVerification();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(title: Text('Home'),),
      body: SubHome(),
        /*
        actions: <Widget>[
          FlatButton(
              child: Row(
                children: <Widget>[
                  Icon(Icons.exit_to_app),
                  Text('Logout')
                ],
              ),
              onPressed: _signOut),
        ],
         */

        /*
      body: _widgetOptions.elementAt(_selectedIndex),
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text('Hello ' + widget.userEmail),
          ),
          Center(
            child: Text('Your ID: ' + widget.userId),
          ),
        ],
      ),
       */

      /*
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              title: Text('Map')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Me')
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pink[600],
        onTap: _onItemTapped,
      ),

      */

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: <Widget>[
                  SizedBox(height: SizeConfig.safeBlockVertical* 0.5,),
                  Text('One Tap Lifeline',style: TextStyle(fontSize: SizeConfig.safeBlockVertical* 4,color: Colors.white),),
                  Icon(Icons.timeline,
                  size: SizeConfig.safeBlockVertical * 13.0,
                  color: Colors.white,)
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.blue[600],
              ),
            ),
            ListTile(
                title: Text('Guide',style: TextStyle(fontSize: SizeConfig.safeBlockVertical* 2.5),),
                leading: Icon(
                  Icons.receipt,color: Colors.pink[600],
                size: SizeConfig.safeBlockVertical * 5,),
                onTap: () {}
            ),
            ListTile(
                title: Text('Call',style: TextStyle(fontSize: SizeConfig.safeBlockVertical* 2.5)),
                leading: Icon(
                  Icons.call,color: Colors.pink[600],
                  size: SizeConfig.safeBlockVertical * 5,),
                onTap: (){
                  // Navigator.pushNamed(context, "/second");
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CallCRUDPage()));
                }
            ),
            ListTile(
                title: Text('SMS',style: TextStyle(fontSize: SizeConfig.safeBlockVertical* 2.5)),
                leading: Icon(
                  Icons.sms,color: Colors.pink[600],
                  size: SizeConfig.safeBlockVertical * 5,),
                onTap: (){
                  // Navigator.pushNamed(context, "/second");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=>new SmsPage()),
                  );
                }
            ),
            ListTile(
              title: Text('Track/Share Location',style: TextStyle(fontSize: SizeConfig.safeBlockVertical* 2.5)),
              leading: Icon(
                Icons.location_on,color: Colors.pink[600],
                size: SizeConfig.safeBlockVertical * 5,),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => LiveLocation()));
              },
            ),
            ListTile(
              title: Text('About',style: TextStyle(fontSize: SizeConfig.safeBlockVertical* 2.5)),
              leading: Icon(
                Icons.help,color: Colors.pink[600],
                size: SizeConfig.safeBlockVertical * 5,),
              onTap: (){
                //Navigator.pop(context);
              },
            ),
            SizedBox(height: SizeConfig.safeBlockVertical * 32.0,width: 0.0,),
            Container(height: SizeConfig.safeBlockVertical * 0.2,width: SizeConfig.safeBlockHorizontal * 10,
              color: Colors.grey,),
            ListTile(
                title: Text('LOGOUT',style: TextStyle(fontSize: SizeConfig.safeBlockVertical* 3)),
                leading: Icon(
                    Icons.exit_to_app,color: Colors.pink[600],
                  size: SizeConfig.safeBlockVertical * 5,),
                onTap: (){
                  _signOut();
                },
              ),
          ],
        ),
      ),

    );
  }

  void _checkEmailVerification() async {
    _isEmailVerified = await widget.auth.isEmailVerified();
    if (!_isEmailVerified) _showVerifyEmailDialog();
  }

  void _showVerifyEmailDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Please verify your email'),
            content: Text('We need you to verify your email to continue.'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _sendVerifyEmail();
                },
                child: Text('Send me!'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Dismiss'),
              )
            ],
          );
        });
  }

  void _sendVerifyEmail() {
    widget.auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thank You'),
            content: Text('Verifying link has been sent to your email'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              )
            ],
          );
        });
  }

  void _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignOut();
    } catch (e) {
      print(e);
    }
  }
}
