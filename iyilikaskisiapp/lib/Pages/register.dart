import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:the_validator/the_validator.dart';

class CreateUser extends StatefulWidget {
  final String title;
  CreateUser(this.title);

  @override
  registerScreen createState() => registerScreen();
}

// SAYFALARI ÇAĞIRMAK İÇİN KULLANILAN SINIF

class registerScreen extends State<CreateUser> {
  var formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String name;
  String surname;
  String email;
  String password;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.all(20.0),
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/kayitEkran.jpg"),
          fit: BoxFit.cover,
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 60),
                  TextFormField(
                    onSaved: (x) {
                      setState(() {
                        name = x;
                      });
                    },
                    validator: (x) {
                      if (x.isEmpty) {
                        return "Doldurulması Zorunludur!";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                      errorStyle: TextStyle(fontSize: 18),
                      labelText: "Ad",
                      labelStyle: TextStyle(fontSize: 20, color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    onSaved: (x) {
                      setState(() {
                        surname = x;
                      });
                    },
                    validator: (x) {
                      if (x.isEmpty) {
                        return "Doldurulması Zorunludur!";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                      errorStyle: TextStyle(fontSize: 18),
                      labelText: "Soyad",
                      labelStyle: TextStyle(fontSize: 20, color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onSaved: (x) {
                      setState(() {
                        email = x;
                      });
                    },
                    validator: (x) {
                      if (x.isEmpty) {
                        return "Doldurulması Zorunludur!";
                      } else {
                        if (EmailValidator.validate(x) != true) {
                          return "Geçerli Bir Email Adresi Giriniz!";
                        } else {
                          return null;
                        }
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.blue,
                      ),
                      errorStyle: TextStyle(fontSize: 18),
                      labelText: "Email",
                      labelStyle: TextStyle(fontSize: 20, color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    onSaved: (x) {
                      setState(() {
                        password = x;
                      });
                    },
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.blue,
                      ),
                      errorStyle: TextStyle(fontSize: 18),
                      labelText: "Şifre",
                      labelStyle: TextStyle(fontSize: 20, color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  RaisedButton(
                    onPressed: _emailSifreEkle,
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    hoverColor: Colors.black,
                    child: Text(
                      "Kayıt Ol",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _emailSifreEkle() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      String id = _firestore.collection("users").doc().id;

      Map<String, dynamic> _user = Map();
      _user["id"] = id;
      _user["name"] = name;
      _user["surname"] = surname;
      _user["email"] = email;
      _user["password"] = password;




      var _firebaseUser = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .catchError((onError) => null);
      if (_firebaseUser != null) {
        Alert(
            type: AlertType.success,
            context: context,
            title: "KAYIT EKLENDİ!",
            desc: "Lütfen Email Adresinize Gelen Mesajı Onaylıyınız!",
            buttons: [
              DialogButton(
                child: Text(
                  "KAPAT",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                onPressed: () => Navigator.pop(context),
              )
            ]).show();
        formKey.currentState.reset();

        _firebaseUser.user
            .sendEmailVerification()
            .then((value) => null)
            .catchError((onError) => null);

        _firestore.doc("user/$id").set(_user).then((value) {
          Alert(
              context: context,
              title: "Kayıt Eklendi",
              type: AlertType.success,
              buttons: [
                DialogButton(
                    child: Text(
                      "Kapat",
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ]).show();
        });

      } else {
        Alert(
            type: AlertType.warning,
            context: context,
            title: "KAYIT EKLENEMEDİ!",
            desc:
                "Sisteme Kayıtlı Bir Email Adresi Girdiniz. \n Lütfen Farklı Bir Email Adresi Giriniz!",
            buttons: [
              DialogButton(
                child: Text(
                  "KAPAT",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                onPressed: () => Navigator.pop(context),
              )
            ]).show();
      }
    }
  }


}
