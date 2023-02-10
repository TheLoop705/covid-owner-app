import 'dart:io';
import 'package:owner/utils/theme.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PdfUploader extends StatefulWidget {
  final String abc;

  const PdfUploader({Key key, this.abc}) : super(key: key);
  @override
  _PdfUploaderState createState() => _PdfUploaderState();
}

class _PdfUploaderState extends State<PdfUploader> {
  File _image;
  String _uploadedFileURL;
  bool progress = false;
  bool progress1 = false;
  String email;

  @override
  void initState() {
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
      email = prefs.getString('id') == null ? "Your Username" :prefs.getString('id');
    });
    print(email);
  }


  Widget _imagebox() {
    Future chooseFile() async {
      await FilePicker.getFile(type: FileType.custom).then((image) {
        setState(() {
          _image = image;
        });
      });
    }
    Future uploadFile() async {
      setState(() {
        progress = true;
      });
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('pdfs/${Path.basename(_image.path)}');
      StorageUploadTask uploadTask = storageReference.putFile(_image);
      await uploadTask.onComplete;
      print('File Uploaded');
      storageReference.getDownloadURL().then((fileURL) {
        print(fileURL + "afnan");
        setState(() {
          _uploadedFileURL = fileURL;
          progress = false;
        });
      });
    }
    return Column(
      children: [
        _image == null
            ?
        GestureDetector(
            onTap: (){
              chooseFile();
            },
            child:
            Padding(
              padding: EdgeInsets.only(left:MediaQuery.of(context).size.width * 0.1,right: MediaQuery.of(context).size.width * 0.1),
              child: Card(
                elevation: 5,
                shadowColor: Colors.deepPurple,
                child: Column(
                  children: [
                    SizedBox(height: 5.0,),
                    Center(child: Text("Upload Menu",style: TextStyle(),)),
                    Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top:10.0,bottom:10),
                          child: Image.asset("assets/images/pdf.png",height: 80.0,width: 80.0,),
                        )
                    )
                  ],
                ),
              ),
            )
        )
            : Container(),
        _image != null
            ? Container(
          child: progress == true? SpinKitRipple(color: Colors.deepPurple,):RaisedButton(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.25,right: MediaQuery.of(context).size.width * 0.25),
            child: Text('Upload File',style: TextStyle(color: Colors.white),),
            onPressed: uploadFile,
            color: primary,
          ),
        )
            : Container(),
        // Container(height:80,width:120,color:Colors.green,child: Icon(Icons.person,color: Colors.white,size: 70,),),
        _uploadedFileURL != null
            ? Container(
          width: 270,
          child: Card(
            elevation: 5,
            shadowColor: Colors.deepPurple,
            child: Image.asset(
              "assets/images/pdftick.png",
              height: 150,
            ),
          ),
        )
            : Container(),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left:20.0,right: 20.0,bottom: 10.0,top: 30.0),
        child: Container(
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: Form(
            autovalidate: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Upload Or Update Your Menu",style: TextStyle(fontSize: 20),),
                Flexible(child: SizedBox(height: 20.0,)),
                _imagebox(),
                progress1 == true? SpinKitRipple(color: primary,): RaisedButton(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.25,right: MediaQuery.of(context).size.width * 0.25),
                  color: primary,
                  elevation: 5.0,
                  onPressed: () {
                    setState(() {
                      progress1 = true;
                    });
                    AddBook();
                  },
                  child: Text(
                    'Save Menu',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void AddBook() async {
    if( _uploadedFileURL == null) {
      print("Invalid Credentials");
    }
    else{
      try{
        setState(() {
          progress1 = true;
        });
        DocumentReference documentReference = Firestore.instance.collection("Restaurants").document(email);
        Map<String, dynamic> users = {
          "pdf": _uploadedFileURL,
        };
        documentReference.update(users).whenComplete(() {
          print("Document createdtopic ") ;
        });
        setState(() {
          progress1 = false;
          _image = null;
          _uploadedFileURL = null;
        });
      }catch(e){
        setState(() {
          progress1 = false;
        });
        print(e.toString());
        print("error");
      }
    }
  }
}

