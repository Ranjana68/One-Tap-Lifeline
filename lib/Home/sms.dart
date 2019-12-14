import 'package:flutter/material.dart';
import 'package:sms/sms.dart';

class SmsPage extends StatefulWidget {
  createState()
  {
    return Mysms();
  }
}


class Mysms extends State<SmsPage> {

  final no =TextEditingController();
  final msg=TextEditingController();
  SmsSender send=new SmsSender();


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
            appBar: AppBar(title: Text('SMS'),),
            body: Column(
                children: [
                  TextField(
                    controller: no ,
                    keyboardType: TextInputType.number,

                    decoration: InputDecoration(
                      labelText: 'Enter the number',
                    ),
                  ),
                  TextField(
                    controller: msg,
                    decoration: InputDecoration(
                      labelText: 'Enter the message',
                    ),

                  ),
                  RaisedButton(
                    onPressed: () {
                      send.sendSms(
                          new SmsMessage(no.text ,msg.text));
                    },
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xFF0D47A1),
                            Color(0xFF1976D2),
                            Color(0xFF42A5F5),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: const Text(
                          'SEND SMS',
                          style: TextStyle(fontSize: 20,color: Colors.white)
                      ),
                    ),

                  ),
                ]
            )
        );
  }

}