import 'dart:math';
import 'package:flutter/material.dart';
import 'package:signup_login_app/size_conifg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:call_number/call_number.dart';

class CallCRUDPage extends StatefulWidget {
  @override
  CallCRUDPageState createState() {
    return CallCRUDPageState();
  }
}

class CallCRUDPageState extends State<CallCRUDPage> {
  String id;
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final number = TextEditingController();

  bool add = false;

  void setAdd(){
    setState(() {
      add = true;
    });
  }

  Card buildItem(DocumentSnapshot doc) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: (){
          number.text = doc.data['Phone Number'];
          CallNumber().callNumber(number.text);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Icon(Icons.call,
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
  /*
  Container fields(){
    if(add)
      return Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: SizeConfig.safeBlockVertical * 1,),
              buildTextFieldName(),
              buildTextFieldNumber(),
              SizedBox(height: SizeConfig.safeBlockVertical * 1,),
            ],
          ),
        ),
      );

  }
   */


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Contacts'),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          buildTextFieldName(),
          buildTextFieldNumber(),
          /*
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: SizeConfig.safeBlockVertical * 1,),
                buildTextFieldName(),
                buildTextFieldNumber(),
                SizedBox(height: SizeConfig.safeBlockVertical * 1,),
              ],
            ),
          ),
           */

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                onPressed: createData,
                child: Text('Create', style: TextStyle(color: Colors.white)),
                color: Colors.green,
              ),
              RaisedButton(
                onPressed: id != null ? readData : null,
                child: Text('Read', style: TextStyle(color: Colors.white)),
                color: Colors.blue,
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
      /*
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        onPressed: setAdd,
      ),
       */
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

  void readData() async {
    DocumentSnapshot snapshot = await db.collection('CRUD').document(id).get();
    print(snapshot.data['name']);
  }


  void deleteData(DocumentSnapshot doc) async {
    await db.collection('CRUD').document(doc.documentID).delete();
    setState(() => id = null);
  }

}
