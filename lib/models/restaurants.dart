import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant{
  final String id;
  final String email;
  final String name;
  final String phone;
  final String location;
  final String restaurant;
  final String image;
  final Timestamp time;

  Restaurant(this.id, this.email, this.name, this.phone, this.location, this.restaurant, this.image, this.time);
}