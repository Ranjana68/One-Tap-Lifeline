import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signup_login_app/Login.dart';
import 'size_conifg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Signup(),
    );
  }
}

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String _email, _password, _name;
  bool _autovalidate = false;
  GoogleMapController mapController;
  final _regformkey = GlobalKey<FormState>();
  final _scaffold = GlobalKey<ScaffoldState>();

  final LatLng _center = const LatLng(30.7333, 76.7794);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      resizeToAvoidBottomPadding: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            // =====================Hello There. CONTAINER ========================
            padding: EdgeInsets.only(
                left: SizeConfig.safeBlockHorizontal * 5,
                right: SizeConfig.safeBlockHorizontal * 5),
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(SizeConfig.blockSizeVertical * 2),
                  child: Container(
                    height: SizeConfig.blockSizeVertical * 23,
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: _center,
                        zoom: 12.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(
                      SizeConfig.safeBlockHorizontal * 4,
                      SizeConfig.safeBlockVertical * 26,
                      0.0,
                      0.0),
                  child: Text(
                    'SignUp',
                    style: TextStyle(
                        fontSize: SizeConfig.safeBlockVertical * 10.6,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(
                      SizeConfig.blockSizeHorizontal * 74.65,
                      SizeConfig.safeBlockVertical * 26.5,
                      0.0,
                      0.0),
                  child: Text(
                    '.',
                    style: TextStyle(
                        fontSize: SizeConfig.safeBlockVertical * 10.6,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          Container(
            // ============================ Email & password Field ========================
            padding: EdgeInsets.only(
                top: SizeConfig.safeBlockVertical * 3,
                left: SizeConfig.safeBlockHorizontal * 9.85,
                right: SizeConfig.safeBlockHorizontal * 9.85),
            child: Form(
                key: _regformkey,
                autovalidate: _autovalidate,
                child: Column(children: <Widget>[
                  TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: 'EMAIL',
                        icon: Icon(
                          Icons.mail,
                          color: Colors.grey,
                        ),
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue))),
                    validator: (val) =>
                        val.isEmpty ? 'Email can\'t be empty!' : null,
                    onSaved: (val) => _email = val.trim(),
                  ),
                  SizedBox(height: SizeConfig.safeBlockVertical * 3),
                  TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: 'NICK NAME',
                        icon: Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue))),
                    validator: (val) =>
                        val.isEmpty ? 'Name can\'t be empty!' : null,
                    onSaved: (val) => _name = val.trim(),
                  ),
                  SizedBox(height: SizeConfig.safeBlockVertical * 3),
                  TextFormField(
                    maxLines: 1,
                    decoration: InputDecoration(
                        labelText: 'PASSWORD',
                        icon: Icon(
                          Icons.lock,
                          color: Colors.grey,
                        ),
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue))),
                    validator: (val) =>
                        val.isEmpty ? 'Password can\'t be empty!' : null,
                    onSaved: (val) => _password = val,
                    obscureText: true,
                  ),
                  SizedBox(height: SizeConfig.safeBlockVertical * 6),
                ])),
          ),
          Container(
              // ==================== Signup Button ======================
              padding: EdgeInsets.only(
                  left: SizeConfig.safeBlockHorizontal * 9.85,
                  right: SizeConfig.safeBlockHorizontal * 9.85),
              child: Column(
                children: <Widget>[
                  Container(
                      height: SizeConfig.safeBlockVertical * 8,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              SizeConfig.safeBlockVertical * 4),
                        ),
                        color: Colors.blue,
                        elevation: 7.0,
                        onPressed: signUp,

                  child: Center(
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.safeBlockVertical * 2,
                          fontFamily: 'Montserrat'),
                    ),
                  ))),
                  SizedBox(height: SizeConfig.safeBlockVertical * 3.5),
                  Container(
                    height: SizeConfig.safeBlockVertical * 8,
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: SizeConfig.safeBlockVertical * 0.3),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 7),
                            color: Colors.black38,
                            blurRadius: 10,
                          )
                        ],
                        borderRadius: BorderRadius.circular(
                            SizeConfig.safeBlockVertical * 4),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Center(
                          child: Text(
                            'Go Back',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Future<void> signUp() async{
    final formState = _regformkey.currentState;
    _autovalidate = true;
    if(formState.validate()){
      formState.save();
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        Navigator.of(context).pop();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
        _scaffold.currentState.showSnackBar(new SnackBar(
          content: new Text('SignIn with your new Account.'),
        ));
      }catch(e){
        print(e.message);
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text(e),
        ));
      }
    }
  }
}
