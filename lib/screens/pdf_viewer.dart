import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:owner/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
class PdfView extends StatefulWidget {
  _PdfViewState createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  bool _isLoading = true;
  PDFDocument _document;
  String email;
  String url;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  Future<void> getUser() async{
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email') == null ? "Your Username" :prefs.getString('email');
    });
    print(email);
    loadDocument();
  }

  loadDocument() async {
    Firestore.instance.collection("Restaurants").where("email",isEqualTo: email).get().then((value){
      value.documents.forEach((element) {
        url = element["pdf"];
        print(element["pdf"]);
      });
    }).then((value){
      getPDF();
    });
  }

  getPDF() async{
    final document = await PDFDocument.fromURL(url);
    setState((){
      _document = document;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pdf Viewer"),
      ),
      body: Center(
          child: _isLoading
              ? Center(child: CircularProgressIndicator(backgroundColor: primary,))
              : PDFViewer(document: _document)),
    );
  }
}
