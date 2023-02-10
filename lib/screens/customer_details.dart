import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:owner/Animation/bottomAnimation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerDetail extends StatefulWidget {
  final String id;
  final String name;
  final String email;
  final String address;
  final String phone;
  final String image;
  final Timestamp date;

  const CustomerDetail({Key key, this.id, this.name, this.email, this.address, this.phone, this.image, this.date}) : super(key: key);
  @override
  _CustomerDetailState createState() => _CustomerDetailState();
}

class _CustomerDetailState extends State<CustomerDetail> {

  String name;
  List<String> times = [];

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
    getDate();
  }


  getDate(){
    Firestore.instance.collection("Users").document(widget.id).collection("Restaurants").where("name",isEqualTo: name).get().then((value){
      //print(value.documents);
      value.documents.forEach((element) {
        print(DateFormat('dd MMM y kk:mm a').format(element["time"].toDate()).toString());
        //print(DateTime.fromMillisecondsSinceEpoch(element["time"]).toString());
        //times.insert(0, DateFormat('dd MMM y, kk:mm a').format(element["time"].toDate()).toString());
        setState(() {
          times.add(DateFormat('dd MMM y kk:mm a').format(element["time"].toDate()).toString());
        });
      });
      print(times.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    print(times.length);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: ListView(
        children: [
          WidgetAnimator(
            Container(
                height: 300,
                child: Image.network(widget.image == null?"https://i0.wp.com/shahpourpouyan.com/wp-content/uploads/2018/10/orionthemes-placeholder-image-1.png?resize=1024%2C683&ssl=1":widget.image,fit: BoxFit.fitHeight,)),
          ),
          WidgetAnimator(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.phone,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                  ),
                ],
              ),
            ),
          ),
          WidgetAnimator(
            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.email)
                ],
              )
            ),
          ),
          WidgetAnimator(
            Padding(
                padding: const EdgeInsets.only(left:8.0,top: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.address)
                  ],
                )
            ),
          ),
          WidgetAnimator(
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text("Arrival Timings"),
              )
          ),
          WidgetAnimator(
            Padding(
              padding: const EdgeInsets.only(left:20.0),
              child: Container(
                child: Text(DateFormat('MMMM dd, yyyy \n hh:mm a').format(widget.date.toDate())),
              ),
            ),
          )
          // Container(
          //   height: MediaQuery.of(context).size.height,
          //   child: ListView.builder(
          //       itemCount: times.length,
          //       itemBuilder: (context,index) => WidgetAnimator(
          //         ListTile(
          //          title: Text(times[index]),
          //         ),
          //       )
          //   ),
          // )
        ],
      ),
    );
  }
}
