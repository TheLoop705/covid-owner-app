import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QrCode extends StatefulWidget {
  @override
  _QrCodeState createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  String name = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }
  Future<void> getUser() async{
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') == null ? "Your Username" :prefs.getString('name');
    });
    print(name);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: QrImage(
              data: name,
            ),
          ),
        ],
      ),
    );
  }
}
