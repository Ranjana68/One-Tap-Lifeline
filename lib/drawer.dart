import 'package:flutter/material.dart';
import 'size_conifg.dart';
import 'Home/call.dart';
import 'Home/sms.dart';
import 'firebase_auth_utils.dart';
import 'main.dart';

class MyDrawer extends StatefulWidget{
  _MyDrawerState createState() => _MyDrawerState();
  AuthFunc auth;
}

class _MyDrawerState extends State<MyDrawer>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('One Tap Lifeline',style: TextStyle(fontSize: 25,color: Colors.white),),
              decoration: BoxDecoration(
                color: Colors.blue[800],
              ),
            ),
            ListTile(
                title: Text('Guide'),
                leading: IconButton(
                  icon: Icon(Icons.receipt,color: Colors.pink[600]),
                ),
                onTap: () {
                  Navigator.pop(context);
                }
            ),
            ListTile(
                title: Text('Call'),
                leading: IconButton(
                  icon: Icon(Icons.call,color: Colors.pink[600]),
                ),

                onTap: (){
                  // Navigator.pushNamed(context, "/second");
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=>new CallPage()),
                  );
                }
            ),
            ListTile(
                title: Text('Sms'),
                leading: IconButton(
                  icon: Icon(Icons.sms,color: Colors.pink[600]),
                ),
                onTap: (){
                  // Navigator.pushNamed(context, "/second");
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=>new SmsPage()),
                  );
                }
            ),
            ListTile(
              title: Text('Track Location'),
              leading: IconButton(
                icon: Icon(Icons.location_on,color: Colors.pink[600]),
              ),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('About'),
              leading: IconButton(
                icon: Icon(Icons.help,color: Colors.pink[600]),
              ),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            SizedBox(height: SizeConfig.safeBlockVertical * 32.0,width: 0.0,),
            ListTile(
              title: Text('LOGOUT'),
              leading: IconButton(
                icon: Icon(Icons.exit_to_app,color: Colors.pink[600]),
              ),
              onTap: (){
                _signOut();
              },
            ),
          ],
        ),
      );
  }

  void _signOut() async {
    try {
      await widget.auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}