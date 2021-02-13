import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'file:///C:/ornekler/iyilikaskisiapp/lib/Pages/donateConfirm.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/text.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';

class Akureyri extends StatefulWidget {
  Akureyri(
      {Key key,
      this.title,
      this.subtitle,
      this.companyName,
      this.productPiece,
      this.idd})
      : super(key: key);
  final String title;
  final String subtitle;
  String productPiece;
  String companyName;
  String idd;

  @override
  _AkureyriState createState() => _AkureyriState();
}

class _AkureyriState extends State<Akureyri> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  Image i;
  String companyName;
  String productName;
  String aciklama;
  String adres;
  bool _isLoading = false;
  int uid;
  final FirebaseDatabase db = FirebaseDatabase();
  @override
  Widget build(BuildContext context) {
    String adet = widget.productPiece + " Adet " + widget.subtitle;
    aciklamaDetay();
    adresDetay();
    idAl();
    return LoadingOverlay(
        isLoading: _isLoading,
        child: Scaffold(
            appBar: AppBar(
              title: Text("Askı Detayları"),
            ),
            body: ListView(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    SizedBox(
                        child: FutureBuilder(
                      future: _getImage(context, uid.toString() + "/a"),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: MediaQuery.of(context).size.width / 1.2,
                            child: snapshot.data,
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: MediaQuery.of(context).size.width / 1.2,
                            child: snapshot.data,
                          );
                        }
                      },
                    )),
                    Padding(
                      padding: EdgeInsets.only(top: 270, left: 20, right: 20),
                      child: Container(
                          height: 100.0,
                          width: MediaQuery.of(context).size.width - 24.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 2.0,
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2.0)
                              ]),
                          child: Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.title,
                                  style: TextStyle(
                                      fontFamily: 'ConcertOne-Regular'),
                                ),
                                Text(adet),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 13.0,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 13.0,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 13.0,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 13.0,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 13.0,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 60, bottom: 20, left: 14),
                  child: Text(
                    'Ürün İçeriği',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'ConcertOne-Regular'),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 14, top: 6, right: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          aciklama,
                          style: TextStyle(
                              fontSize: 15, fontFamily: 'ConcertOne-Regular'),
                        ),
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 60, bottom: 20, left: 14),
                  child: Text(
                    'Adres ve Konum',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'ConcertOne-Regular'),
                  ),
                ),
                adress_donate(adres),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                      minWidth: 180,
                      onPressed: _launchURL,
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                      textColor: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: <Color>[
                              Colors.blue[300],
                              Colors.blue[300],
                              Colors.blue[300],
                            ],
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(40.0, 20, 40.0, 20.0),
                        child: Text('Konum',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        askidanAl();
                      },
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                      textColor: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: <Color>[
                              Colors.blue[300],
                              Colors.blue[300],
                              Colors.blue[300],
                            ],
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(40.0, 20, 35.0, 20.0),
                        child: const Text('Askıdan Al',
                            style: TextStyle(fontSize: 20)),
                      ),
                    )
                  ],
                )
              ],
            )));
  }

  Future<Widget> _getImage(BuildContext context, String imageName) async {
    Image image;
    await FireStorageService.loadImage(context, imageName).then((value) {
      image = Image.network(
        value.toString(),
        fit: BoxFit.scaleDown,
      );
    });
    return image;
  }

  idAl() async {
    int uid;
    FirebaseFirestore.instance
        .collection('corpCode')
        .doc(widget.companyName)
        .get()
        .then((value) {
      setState(() {
        uid = value.data()['id'];
      });
    });

    return uid;
  }

  _launchURL() async {
    const url = 'https://goo.gl/maps/8koBwKUMEBRaHw9q8';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void askidanAl() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                DonateConfirm(id: widget.idd, companyName1: widget.title)));
  }

  Future<void> downloadURLExample() async {
    String url;
    FirebaseFirestore.instance
        .collection('corpCode')
        .doc(widget.title)
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> firestoreInfo = documentSnapshot.data();

      setState(() {
        url = firestoreInfo["imgUrl"];
      });
    });

    return Image.network(url);

    // Within your widgets:
    // Image.network(downloadURL);
  }

  aciklamaDetay() {
    FirebaseFirestore.instance
        .collection(widget.title)
        .doc(widget.subtitle)
        .get()
        .then((value) {
      setState(() {
        aciklama = value.data()['aciklama'];
      });
    });
  }

  adresDetay() {
    FirebaseFirestore.instance
        .collection('adresses')
        .doc(widget.title)
        .get()
        .then((value) {
      setState(() {
        adres = value.data()['adres'];
      });
    });
  }
}

Widget adress_donate(
  String description,
) {
  return Padding(
    padding: EdgeInsets.only(left: 9, top: 6, right: 14, bottom: 50),
    child: Column(
      children: <Widget>[
        Text(
          description,
          style: TextStyle(fontSize: 15, fontFamily: 'ConcertOne-Regular'),
        )
      ],
    ),
  );
}

class FireStorageService extends ChangeNotifier {
  FireStorageService();
  static Future<dynamic> loadImage(BuildContext context, String Image) async {
    return await FirebaseStorage.instance.ref().child(Image).getDownloadURL();
  }
}
