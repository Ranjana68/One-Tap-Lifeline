import 'dart:math';
import 'package:flutter/material.dart';
import 'package:signup_login_app/size_conifg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sms/sms.dart';

class SmsCRUDPage extends StatefulWidget {
  @override
  SmsCRUDPageState createState() {
    return SmsCRUDPageState();
  }
}

class SmsCRUDPageState extends State<SmsCRUDPage> {
  String id;
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();

  final message = TextEditingController();
  final name = TextEditingController();
  final number = TextEditingController();

  SmsSender send=new SmsSender();


  Card buildItem(DocumentSnapshot doc) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: (){
          number.text = doc.data['Phone Number'];
          send.sendSms(
              new SmsMessage(number.text ,message.text));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Icon(Icons.message,
                color: Colors.green,
                size: SizeConfig.safeBlockVertical * 5,),
              SizedBox(width: SizeConfig.safeBlockHorizontal * 3,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Name: ${doc.data['Name']}',
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: 8.0,),
                    Text(
                      'Number: ${doc.data['Phone Number']}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              IconButton(icon: Icon(Icons.delete,
                color: Colors.red,),
                onPressed: () => deleteData(doc),)
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildTextFieldMessage() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Message',
        fillColor: Colors.grey[300],
        filled: true,
      ),
      keyboardType: TextInputType.text,
      controller: message,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
        else{
          return null;
        }
      },
      onSaved: (value) => message.text = value,
    );
  }

  TextFormField buildTextFieldName() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Name',
        fillColor: Colors.grey[300],
        filled: true,
      ),
      keyboardType: TextInputType.text,
      controller: name,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
        else{
          return null;
        }
      },
      onSaved: (value) => name.text = value,
    );
  }

  TextFormField buildTextFieldNumber() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Ph. Number',
        fillColor: Colors.grey[300],
        filled: true,
      ),
      keyboardType: TextInputType.number,
      controller: number,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter a valid phone number.';
        }
        else{
          return null;
        }
      },
      onSaved: (value) => number.text = value,
    );
  }

  @override
  Widget build(BuildContext context) {
    message.text = "I'm in a trouble, please help !!!";
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('SMS'),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                buildTextFieldMessage(),
                SizedBox(height: SizeConfig.safeBlockVertical * 2,),
                buildTextFieldName(),
                buildTextFieldNumber()
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                onPressed: createData,
                child: Text('Create', style: TextStyle(color: Colors.white)),
                color: Colors.green,
              ),
            ],
          ),
          SizedBox(height: 20.0,width: 0.0,),
          StreamBuilder<QuerySnapshot>(
            stream: db.collection('CRUD').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(children: snapshot.data.documents.map((doc) => buildItem(doc)).toList());
              } else {
                return SizedBox();
              }
            },
          )
        ],
      ),
    );
  }

  void createData() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      DocumentReference ref = await db.collection('CRUD').add({'Name': name.text, 'Phone Number': number.text});
      setState(() => id = ref.documentID);
      print(ref.documentID);
    }
  }
/*
  void readData() async {
    DocumentSnapshot snapshot = await db.collection('CRUD').document(id).get();
    print(snapshot.data['name']);
  }

 */


  void deleteData(DocumentSnapshot doc) async {
    await db.collection('CRUD').document(doc.documentID).delete();
    setState(() => id = null);
  }

}
