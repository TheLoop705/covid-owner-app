import 'package:cloud_firestore/cloud_firestore.dart';

class Users{
  final String id;
  final String name;
  final String email;
  final String location;
  final String image;
  final String phone;
  final Timestamp date;

  Users(this.id, this.name, this.email, this.location, this.image, this.phone, this.date);
}
