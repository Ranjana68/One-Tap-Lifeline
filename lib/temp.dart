import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:signup_login_app/Home/Home.dart';
import 'size_conifg.dart';
import 'firebase_auth_utils.dart';

class Login extends StatefulWidget {

  AuthFunc auth;
  VoidCallback onSignedIn;
  @override
  _LoginState createState() => _LoginState();

  Login({this.auth, this.onSignedIn});
}

enum STATE{
  SIGNIN,SIGNUP
}

class _LoginState extends State<Login> {

  String _email, _password,_errorMessage;
  bool _autovalidate = false;

  STATE _formState = STATE.SIGNIN;
  bool _isIos, _isLoading;

  bool _validateAndSave(){
    final form = _formKey.currentState;
    if(form.validate())
    {
      form.save();
      return true;
    }
    return false;
  }

  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });

    if(_validateAndSave()){
      String userId = "";
      try{
        if(_formState == STATE.SIGNIN)
        {
          userId = await widget.auth.signIn(_email, _password);
        }
        else
        {
          userId = await widget.auth.signUp(_email, _password);
          widget.auth.sendEmailVerification();
          _showVerifyEmailSentDialog();
        }
        setState(() {
          _isLoading = false;
        });

        if(userId.length >0 && userId != null && _formState == STATE.SIGNIN)
          widget.onSignedIn();
      }catch(e){
        print(e);
        setState(() {
          _isLoading = false;
          if(_isIos)
            _errorMessage = e.details;
          else
            _errorMessage = e.message;
        });
      }
    }
  }

  final _scaffold = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _errorMessage = "";
    _isLoading = false;
  }

  void _changeFormToSignUp(){
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formState = STATE.SIGNUP;
    });
  }

  void _changeFormToSignIn(){
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formState = STATE.SIGNIN;
    });
  }

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffold,
      resizeToAvoidBottomPadding: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                left: SizeConfig.safeBlockHorizontal * 5,
                right: SizeConfig.safeBlockHorizontal * 5),

            // =====================Hello There. CONTAINER ========================

            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(
                      SizeConfig.safeBlockHorizontal * 5,
                      SizeConfig.safeBlockVertical * 15,
                      0.0,
                      0.0),
                  child: Text(
                    'Hello',
                    style: TextStyle(
                        fontSize: SizeConfig.safeBlockVertical * 10.6,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(
                      SizeConfig.safeBlockHorizontal * 5,
                      SizeConfig.safeBlockVertical * 23.5,
                      0.0,
                      0.0),
                  child: Text(
                    'There',
                    style: TextStyle(
                        fontSize: SizeConfig.safeBlockVertical * 10.6,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(
                      SizeConfig.safeBlockHorizontal * 62,
                      SizeConfig.safeBlockVertical * 23.5,
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
              child: Center(
                child: Container(
                  child: Form(
                    key: _formKey,
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
                                fontSize: SizeConfig.safeBlockVertical * 2.5,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue))),
                        validator: (val) => val.isEmpty? 'Please enter email ID!':null,
                        onSaved: (val)=> _email = val.trim(),
                      ),
                      SizedBox(height: SizeConfig.safeBlockVertical * 3.5),
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
                                fontSize: SizeConfig.safeBlockVertical * 2.5,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue))),
                        obscureText: true,
                        validator: (val) => val.isEmpty? 'Please enter password ID!':null,
                        onSaved: (val) => _password = val,
                      ),
                      SizedBox(height: SizeConfig.safeBlockVertical * 2),
                      Container(
                        alignment: Alignment(1.0, 0.0),
                        padding: EdgeInsets.only(
                            top: SizeConfig.safeBlockVertical * 2),
                        child: InkWell(
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                fontSize: SizeConfig.safeBlockVertical * 1.9,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                      SizedBox(height: SizeConfig.safeBlockVertical * 6),
                    ]),
                  ),
                ),
              )),
          Container(
            padding: EdgeInsets.only(
                left: SizeConfig.safeBlockHorizontal * 9.85,
                right: SizeConfig.safeBlockHorizontal * 9.85),
            child: Column(
              children: <Widget>[
                Container(
                  // ==================== Login Button ======================

                  height: SizeConfig.safeBlockVertical * 8,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical * 4),
                    ),
                    color: Colors.blue,
                    elevation: 7.0,
                    //onPressed:logIn,
                    child: Center(
                        child: _formState == STATE.SIGNIN
                            ? Text(
                          'SIGN IN',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.safeBlockVertical * 2,
                              fontFamily: 'Montserrat'),
                        )
                            : Text(
                          'SIGN UP',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.safeBlockVertical * 2,
                              fontFamily: 'Montserrat'),
                        )
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.safeBlockVertical * 3.5),
                Container(
                  height: SizeConfig.safeBlockVertical * 8,
                  color: Colors.transparent,
                  child: GestureDetector(
                    onTap: (){},
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
                        borderRadius:
                        BorderRadius.circular(SizeConfig.safeBlockVertical * 4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ImageIcon(AssetImage('assets/facebook.png')),
                          SizedBox(width: SizeConfig.safeBlockHorizontal * 3),
                          Text(
                            'Log in with facebook',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.safeBlockVertical * 1.9),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.safeBlockVertical * 3.5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'New to FDC ?',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: SizeConfig.safeBlockVertical * 2),
                    ),
                    SizedBox(width: SizeConfig.safeBlockHorizontal * 2),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed('/signup');
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                            color: Colors.blue,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),

        ],
      ),
    );
  }

  bool validateAndSave(){
    final formState = _formKey.currentState;
    if(formState.validate()){
      formState.save();
      return true;
    }
    return false;
  }

  /*Future<void> logIn() async{
    _autovalidate = true;
    if(validateAndSave()){
      try {
        final FirebaseUser user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password).user;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
      }catch(e){
        print(e.message);
        _scaffold.currentState.showSnackBar(new SnackBar(
          content: new Text(e),
        ));
      }
    }
  }
*/
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

  showCircularProgress(){
    if(_isLoading)
      return Center(child: CircularProgressIndicator(),);
    return Container(height: 0.0,width: 0.0,);
  }
}
