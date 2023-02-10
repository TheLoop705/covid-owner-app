import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_date_picker/dropdown_date_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:owner/Animation/bottomAnimation.dart';
import 'package:owner/models/restaurants.dart';
import 'package:owner/models/user.dart';
import 'package:owner/screens/alphabets.dart';
import 'package:owner/screens/customer_details.dart';
import 'package:owner/screens/timing.dart';
import 'package:owner/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Customer extends StatefulWidget {
  final String name;

  const Customer({Key key, this.name}) : super(key: key);
  @override
  _CustomerState createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  String name;
  List<Restaurant> restaurants = [];
  var items = List<Restaurant>();
  var filteredItems = List<Restaurant>();
  List<String> _locations = ['All'];
  List<String> _locations1 = ['All'];// Option 2
  String _selectedLocation; // Option 2

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
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

  getData() async{
    Firestore.instance.collection("Enteries").where("restaurant", isEqualTo: name).get().then((value){
       value.documents.forEach((element) {
         setState(() {
           _locations.add(element['time'].toDate().toString().split(" ")[0]);
           items.add(Restaurant(
               element.documentID,
               element['email'],
               element['name'],
               element['phone'],
               element['address'],
               element['restaurant'],
               element['image'],
               element['time']
           ));
         });
       });
       print(restaurants);
       _locations.forEach((item) {
         var i = _locations1.indexWhere((x) => x == item);
         if (i <= -1) {
           setState(() {
             _locations1.add(item);
           });
         }
       });
    });

    // final data = await Firestore.instance.collection("Users").where("restaurants",arrayContains: name).get();
    // data.documents.forEach((element) {
    //    print(element.documentID);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.name == "abc"? AppBar(
        title: Text("Customers"),
      ): null,
      body:items.length != null ? Column(
        children: [
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
              Container(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    border: Border.all(
                      color: primary,
                      width: 1,
                    ),
                  ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    hint: Text('Please choose a date'), // Not necessary for Option 1
                    value: _selectedLocation,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedLocation = newValue;
                        filterSearchResults(_selectedLocation);
                      });
                    },
                    items: _locations1.map((location) {
                      return DropdownMenuItem(
                        child: new Text(location),
                        value: location,
                      );
                    }).toList(),
                  ),
                 ),
                ),
              ],
            ),
          ),
         filteredItems.isEmpty ? Expanded(
             child: ListView.builder(
                 itemCount: items.length,
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
                               id: items[index].id,
                               name: items[index].name,
                               email: items[index].email,
                               phone: items[index].phone,
                               address: items[index].location,
                               image: items[index].image,
                               date: items[index].time,
                             )));
                           },
                           title: Text(items[index].name+" #00${index + 1}"),
                         ),
                       ),
                     ),
                   ),
                 )
             )
         ) : Expanded(
            child: ListView.builder(
                itemCount: filteredItems.length,
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
                              id: filteredItems[index].id,
                              name: filteredItems[index].name,
                              email: filteredItems[index].email,
                              phone: filteredItems[index].phone,
                              address: filteredItems[index].location,
                              image: filteredItems[index].image,
                              date: filteredItems[index].time,
                            )));
                          },
                          title: Text(filteredItems[index].name+" #00${index + 1}"),
                        ),
                      ),
                    ),
                  ),
                )
              )
            )
        ],
      ): Center(child: CircularProgressIndicator(backgroundColor: primary,))
    );
  }
  void filterSearchResults(String query) {
    List<Restaurant> dummySearchList = List<Restaurant>();
    dummySearchList.addAll(items);
    if(query.isNotEmpty) {
      List<Restaurant> dummyListData = List<Restaurant>();
      dummySearchList.forEach((item) {
        if(item.time.toDate().toString().split(" ")[0].contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        filteredItems.clear();
        filteredItems.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        filteredItems.clear();
        filteredItems.addAll(items);
      });
    }
  }
}
