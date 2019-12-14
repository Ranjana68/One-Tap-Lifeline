import 'package:flutter/material.dart';
import 'package:lamp/lamp.dart';
import 'package:permission/permission.dart';
import 'package:signup_login_app/Home/CallCrud.dart';
import 'package:signup_login_app/Home/SmsCrud.dart';
import 'package:signup_login_app/size_conifg.dart';
import 'WebView.dart';
import 'LiveLocation.dart';
import 'package:call_number/call_number.dart';

class SubHome extends StatefulWidget {
  createState()
  {
    return _Home1();
  }

}


class _Home1 extends State<SubHome> {
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
  final number = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body:
        GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          crossAxisCount: 2,
          children: <Widget>[
            RaisedButton(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),),
              elevation: 8.0,
              color:Colors.blue[400],
              child: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: SizeConfig.safeBlockVertical* 4,),
                    Icon(Icons.offline_bolt,size: SizeConfig.safeBlockVertical* 5,),
                    SizedBox(height: SizeConfig.safeBlockVertical* 1,),
                    Text('Emergency numbers',style: TextStyle(fontSize: SizeConfig.safeBlockVertical* 3,color: Colors.black),),
                  ],
                ),
              ),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => WebView()));

              },
            ),
            RaisedButton(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),),
              elevation: 8.0,
              child: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: SizeConfig.safeBlockVertical* 4,),
                    Icon(Icons.message,size: SizeConfig.safeBlockVertical* 5,),
                    SizedBox(height: SizeConfig.safeBlockVertical* 1,),
                    Text('SMS',style: TextStyle(fontSize: SizeConfig.safeBlockVertical* 3,color: Colors.black),),
                  ],
                ),
              ),
              color:Colors.blue[200],
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => SmsCRUDPage()));
              },
            ),

            /*
            RaisedButton(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),),
                elevation: 8.0,
                child: Text('Flash alert',style: TextStyle(fontSize: 20,color: Colors.black),),
                color:Colors.blue[400],
                onPressed:()async
                {
                  var get = '';
                  List permissions = await Permission.getPermissionsStatus(
                      [PermissionName.Camera,]);
                  permissions.forEach((permission) {
                    get += '${permission.permissionName}: ${permission.permissionStatus}';
                    if (get != "PermissionName.Camera: PermissionStatus.allow") {
                      requestCameraPermission();
                    } else {
                      Lamp.turnOn();
                    }
                  });
                }
              //async=>await Lamp.flash(new Duration(seconds: 2)),
              /*{
                Lamp.flash(new Duration(seconds: 2));
                if(i==0) {
                  Lamp.turnOn();
                  i=1;
                }
                else {
                  Lamp.turnOff();
                  i=0;
                }
              },*/
            ),
             */
            RaisedButton(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),),
              elevation: 8.0,
              child: Column(
                children: <Widget>[
                  SizedBox(height: SizeConfig.safeBlockVertical* 4,),
                  Icon(Icons.contacts,size: SizeConfig.safeBlockVertical* 5,),
                  SizedBox(height: SizeConfig.safeBlockVertical* 1,),
                  Text('Personal Contacts',style: TextStyle(fontSize: SizeConfig.safeBlockVertical* 3,color: Colors.black,),),
                ],
              ),
              color:Colors.blue[200],
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => CallCRUDPage()));
              },
            ),
            RaisedButton(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),),
              elevation: 8.0,
              child: Column(
                children: <Widget>[
                  SizedBox(height: SizeConfig.safeBlockVertical* 4,),
                  Icon(Icons.my_location,size: SizeConfig.safeBlockVertical* 5,),
                  SizedBox(height: SizeConfig.safeBlockVertical* 1,),
                  Text('My Location',style: TextStyle(fontSize: SizeConfig.safeBlockVertical* 2.9,color: Colors.black),),
                ],
              ),
              color:Colors.blue[500],
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => LiveLocation()));
              },

              //google_maps_flutter: ^0.5.21+7

            ),
            RaisedButton(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),),
              elevation: 8.0,
              child: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: SizeConfig.safeBlockVertical* 4,),
                    Icon(Icons.accessibility_new,size: SizeConfig.safeBlockVertical* 5,),
                    SizedBox(height: SizeConfig.safeBlockVertical* 1,),
                    Text('Disaster',style: TextStyle(fontSize: SizeConfig.safeBlockVertical* 3,color: Colors.black),),
                  ],
                ),
              ),
              color:Colors.blue[500],
              onPressed: (){
                number.text = '108';
                CallNumber().callNumber(number.text);
              },
            ),
            RaisedButton(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),),
              elevation: 8.0,
              child: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: SizeConfig.safeBlockVertical* 4,),
                    Icon(Icons.contact_phone,size: SizeConfig.safeBlockVertical* 5,),
                    SizedBox(height: SizeConfig.safeBlockVertical* 1,),
                    Text('SOS',style: TextStyle(fontSize: SizeConfig.safeBlockVertical* 3,color: Colors.black),),
                  ],
                ),
              ),
              color:Colors.blue[200],
              onPressed: (){
                number.text = '112';
                CallNumber().callNumber(number.text);
              },
            ),
            RaisedButton(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),),
              elevation: 8.0,
              child: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: SizeConfig.safeBlockVertical* 4,),
                    Icon(Icons.flash_on ,size: SizeConfig.safeBlockVertical* 5,),
                    SizedBox(height: SizeConfig.safeBlockVertical* 1,),
                    Text('Fire',style: TextStyle(fontSize: SizeConfig.safeBlockVertical* 3,color: Colors.black),),
                  ],
                ),
              ),
              color:Colors.blue[200],
              onPressed: (){
                number.text = '101';
                CallNumber().callNumber(number.text);
              },
            ),
            RaisedButton(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),),
              elevation: 8.0,
              child: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: SizeConfig.safeBlockVertical* 4,),
                    Icon(Icons.add_circle_outline,size: SizeConfig.safeBlockVertical* 5,),
                    SizedBox(height: SizeConfig.safeBlockVertical* 1,),
                    Text('Ambulance',style: TextStyle(fontSize: SizeConfig.safeBlockVertical* 3,color: Colors.black),),
                  ],
                ),
              ),
              color:Colors.blue[500],
              onPressed: (){
                number.text = '102';
                CallNumber().callNumber(number.text);
              },
            ),
          ],
        ),
      );
  }

}
