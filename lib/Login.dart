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

enum STATE { SIGNIN, SIGNUP }

class _LoginState extends State<Login> {
  String _email, _password, _errorMessage;
  bool _autovalidate = false;

  STATE _formState = STATE.SIGNIN;
  bool _isIos, _isLoading;

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
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

    if (_validateAndSave()) {
      String userId = "";
      try {
        if (_formState == STATE.SIGNIN) {
          userId = await widget.auth.signIn(_email, _password);
        } else {
          userId = await widget.auth.signUp(_email, _password);
          widget.auth.sendEmailVerification();
          _showVerifyEmailSentDialog();
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null && _formState == STATE.SIGNIN)
          widget.onSignedIn();
      } catch (e) {
        print(e);
        setState(() {
          _isLoading = false;
          if (_isIos)
            _errorMessage = e.details;
          else
            _errorMessage = e.message;
        });
      }
    }
    else
      _isLoading = false;
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

  void _changeFormToSignUp() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formState = STATE.SIGNUP;
    });
  }

  void _changeFormToSignIn() {
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
      body: Stack(
        children: <Widget>[
          showBody(),
          showCircularProgress(),
        ],
      ),
    );
  }

  bool validateAndSave() {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      return true;
    }
    return false;
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thank You!'),
            content: Text('Verify link has been sent to your email.'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  _changeFormToSignIn();
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              )
            ],
          );
        });
  }

  showCircularProgress() {
    if (_isLoading)
      return Center(
        child: CircularProgressIndicator(),
      );
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  showBody() {
    return Container(
      padding: EdgeInsets.all(32.0),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            _showText(),
            _showEmailInput(),
            _showPasswordInput(),
            _showButton(),
            _showAskQuestion(),
            _showErrorMessage(),
          ],
        ),
      ),
    );
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return Text(
        _errorMessage,
        style: TextStyle(
            fontSize: SizeConfig.safeBlockVertical * 2.5,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return Container(
        height: 0.0,
        width: 0.0,
      );
    }
  }

  Widget _showAskQuestion() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, SizeConfig.safeBlockVertical * 1.5, 0.0, 0.0),
      child: FlatButton(
          onPressed: _formState == STATE.SIGNIN
              ? _changeFormToSignUp
              : _changeFormToSignIn,
          child: _formState == STATE.SIGNIN
              ? Text('Create an accont',
              style: TextStyle(fontSize: SizeConfig.safeBlockVertical * 2.5, fontWeight: FontWeight.w400))
              : Text(
            'Have an account? Sign In',
            style: TextStyle(fontSize: SizeConfig.safeBlockVertical * 2.5, fontWeight: FontWeight.w400),
          )),
    );

  }

  Widget _showButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, SizeConfig.safeBlockVertical * 8, 0.0, 0.0),
      child: Container(
        // ==================== Login Button ======================

        height: SizeConfig.safeBlockVertical * 8,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical * 4),
          ),
          color: Colors.blue,
          elevation: 7.0,
          onPressed:_validateAndSubmit,
          child: Center(
              child: _formState == STATE.SIGNIN
                  ? Text(
                'SIGN IN',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.safeBlockVertical * 2.5,
                    fontFamily: 'Montserrat'),
              )
                  : Text(
                'SIGN UP',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.safeBlockVertical * 2.5,
                    fontFamily: 'Montserrat'),
              )
          ),
        ),
      ),
    );
  }

  _showPasswordInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, SizeConfig.safeBlockVertical * 4, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        decoration: InputDecoration(
            labelText: 'PASSWORD',
            icon: Icon(
              Icons.lock,
              color: Colors.grey,
              size: SizeConfig.safeBlockVertical * 4,
            ),
            labelStyle: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.safeBlockVertical * 3.0,
                color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue))),
        validator: (val) =>
        val.isEmpty ? 'Password can\'t be empty!' : null,
        onSaved: (val) => _password = val,
        obscureText: true,
      ),
    );
  }

  _showEmailInput(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, SizeConfig.safeBlockVertical * 8.5, 0, 0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            labelText: 'EMAIL',
            icon: Icon(
              Icons.mail,
              size: SizeConfig.safeBlockVertical * 4,
              color: Colors.grey,
            ),
            labelStyle: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.safeBlockVertical * 3.0,
                color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue))),
        validator: (val) =>
        val.isEmpty ? 'Email can\'t be empty!' : null,
        onSaved: (val) => _email = val.trim(),
      ),
    );
  }

  _showText(){
    return Hero(
      tag: 'here',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: _formState == STATE.SIGNIN
            ? Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(
                  SizeConfig.safeBlockHorizontal * 2,
                  SizeConfig.safeBlockVertical * 8.0,
                  0.0,
                  0.0),
              child: Text(
                'Hello',
                style: TextStyle(
                    fontSize: SizeConfig.safeBlockVertical * 11,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                  SizeConfig.safeBlockHorizontal * 2,
                  SizeConfig.safeBlockVertical * 17.5,
                  0.0,
                  0.0),
              child: Text(
                'There',
                style: TextStyle(
                    fontSize: SizeConfig.safeBlockVertical * 11,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                  SizeConfig.safeBlockHorizontal * 61,
                  SizeConfig.safeBlockVertical * 17.5,
                  0.0,
                  0.0),
              child: Text(
                '.',
                style: TextStyle(
                    fontSize: SizeConfig.safeBlockVertical * 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
          ],
        )
            :Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(
                  SizeConfig.safeBlockHorizontal * 2,
                  SizeConfig.safeBlockVertical * 11,
                  0.0,
                  0.0),
              child: Text(
                'SignUp',
                style: TextStyle(
                    fontSize: SizeConfig.safeBlockVertical * 11,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                  SizeConfig.blockSizeHorizontal * 72.65,
                  SizeConfig.safeBlockVertical * 12.5,
                  0.0,
                  0.0),
              child: Text(
                '.',
                style: TextStyle(
                    fontSize: SizeConfig.safeBlockVertical * 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
