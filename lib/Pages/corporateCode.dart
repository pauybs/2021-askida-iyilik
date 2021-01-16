import 'dart:ui';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class CorporateCode extends StatefulWidget {
  final String title;
  TextEditingController t1 = TextEditingController();
  String email;

  CorporateCode({this.title, this.email});

  @override
  corporateScreen createState() => corporateScreen();
}

// SAYFALARI ÇAĞIRMAK İÇİN KULLANILAN SINIF

class corporateScreen extends State<CorporateCode> {
  TextStyle text = TextStyle(fontSize: 30);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController t1 = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  var formKey = GlobalKey<FormState>();
  String indirmeBagglantisi;
  File yuklenecekDosya;
  String corporateCode1;
  String cn;
  String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
    return Scaffold(
      primary: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          RaisedButton.icon(
            label: Text(
              "Çıkış Yap",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blue,
            icon: Icon(
              Icons.exit_to_app,
              size: 32,
              color: Colors.white,
            ),
            onPressed: _userCikis,
          )
        ],
        title: Text("Doğrulama Kodu"),
      ),
      resizeToAvoidBottomPadding: false,
      body: Scaffold(
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
          onPressed: urunEkle,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ), //,
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 0,
                      ),
                      TextFormField(
                        controller: t1,
                        onSaved: (x) {
                          setState(() {
                            corporateCode1 = x;
                          });
                        },
                        enabled: false,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 50,
                          color: Colors.black,
                        ),
                        obscureText: false,
                        decoration: InputDecoration(
                            hintText: "Kod Oluştur",
                            hintStyle: TextStyle(
                              color: Colors.grey, // <-- Change this
                              fontSize: 50,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0))),
                      ),
                      SizedBox(height: 30),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              kodAl();
                            },
                            color: Colors.blue[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            hoverColor: Colors.black,
                            child: Text(
                              "Kod Oluştur",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _userCikis() async {
    await _auth
        .signOut()
        .then((value) => Navigator.pushNamed(context, "/"))
        .catchError((onError) {
      Alert(
          type: AlertType.warning,
          context: context,
          title: "ÇIKIŞ YAPILAMADI!",
          buttons: [
            DialogButton(
              child: Text(
                "KAPAT",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              onPressed: () => Navigator.pop(context),
            )
          ]).show();
    });
  }

  void kodAl() {
    FirebaseFirestore.instance
        .collection('company')
        .doc(_auth.currentUser.email)
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> firestoreInfo = documentSnapshot.data();

      setState(() {
        cn = firestoreInfo['companyName'];

        FirebaseFirestore.instance
            .collection("corpCode")
            .doc(cn)
            .update({'kod': t1.text = randomAlphaNumeric(6)});
      });
    });
  }

  void urunEkle() {
    Alert(
        context: context,
        title: "Ekleme İşlemleri",
        content: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            DialogButton(
              onPressed: () => Navigator.pushNamed(context, "/addProduct"),
              child: Text(
                "Ürün Ekle",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            DialogButton(
              onPressed: () => Navigator.pushNamed(context, "/addAdress"),
              child: Text(
                "Adres Ekle/Güncelle",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            DialogButton(
              onPressed: () => resimEkle(),
              child: Text(
                "Resim Ekle/Güncelle",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "İPTAL",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
    formKey.currentState.reset();
  }

  Future<void> resimEkle() async {
    String companyName;
    var alinanDosya = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      yuklenecekDosya = File(alinanDosya.path);
    });
    Reference refStorage = FirebaseStorage.instance
        .ref()
        .child("isyeriresimleri")
        .child(_auth.currentUser.uid)
        .child("isyeriResmi.png");

    UploadTask yukleme = refStorage.putFile(yuklenecekDosya);
    String url = await (await yukleme).ref.getDownloadURL();

    setState(() {
      indirmeBagglantisi = url;
    });
    FirebaseFirestore.instance
        .collection("company")
        .doc(_auth.currentUser.email)
        .update({'imgUrl': url});

    FirebaseFirestore.instance
        .collection('company')
        .doc(_auth.currentUser.email)
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> firestoreInfo = documentSnapshot.data();

      setState(() {
          companyName = firestoreInfo["companyName"];
      });
      FirebaseFirestore.instance
          .collection("corpCode")
          .doc(companyName)
          .update({'imgUrl': url});


    });

  }
}
