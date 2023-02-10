import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:owner/Animation/bottomAnimation.dart';
import 'package:owner/models/user.dart';
import 'package:owner/screens/customer_details.dart';
import 'package:owner/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Timings extends StatefulWidget {
  @override
  _TimingsState createState() => _TimingsState();
}

class _TimingsState extends State<Timings> {
  String name;
  List<Users> users = [];

  @override
  void initState() {
    // TODO: implement initState
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
    super.initState();
    getUser();
  }

  Future<void> getUser() async{
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') == null ? "Your Username" :prefs.getString('name');
    });
    print(name);
    getData();
  }

  getData() async {
    final data = await Firestore.instance.collection("Users").where(
        "restaurants", arrayContains: name).get();
    data.documents.forEach((element) {
      setState(() {
        users.add(Users(
          element.documentID,
          element["Name"],
          element["Email"],
          element["Address"],
          element["image"],
          element["Phone"],
          element["times"][0]
        ));
      });

    });
    users.sort((a, b) => a.date.compareTo(b.date));
    users.forEach((element) {
      print(element.name);
    });
    print(users);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Timings"),
      ),
      body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context,index) => WidgetAnimator(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.only(left:8.0,right: 8.0),
                  child: ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerDetail(
                        id: users[index].id,
                        name: users[index].name,
                        email: users[index].email,
                        phone: users[index].phone,
                        address: users[index].location,
                        image: users[index].image,
                      )));
                    },
                    leading: CircleAvatar(
                      radius: 50,
                      backgroundColor: primary,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50,
                        backgroundImage: NetworkImage(users[index].image == null ? 'https://www.w3schools.com/howto/img_avatar.png' : users[index].image),
                      ),
                    ),
                    title: Text(users[index].name),
                    subtitle: Text(users[index].location),
                  ),
                ),
              ),
            ),
          )
      ),
    );
  }
}
