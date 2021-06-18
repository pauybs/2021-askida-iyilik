import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:iyilikaskisiapp/Pages/donate.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/widgets.dart';

class LoginUser extends StatefulWidget {
  final String title;
  LoginUser(this.title);

  @override
  loginScreen createState() => loginScreen();
}
enum authProblems { UserNotFound, PasswordNotValid, NetworkError }
class loginScreen extends State<LoginUser> {
  var formKey = GlobalKey<FormState>();
  Stream collectionStream =
      FirebaseFirestore.instance.collection('user').snapshots();
  CollectionReference user = FirebaseFirestore.instance.collection('user');
  FirebaseAuth _auth = FirebaseAuth.instance;
  String group;
  String email;
  String password;
  bool _isLoading = false;
  bool _isHidden = false;
  
 @override
  void initState() {
     FirebaseFirestore.instance
        .collection('user')
        .doc(email)
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> firestoreinfo = documentSnapshot.data();
      setState(() {
        group = firestoreinfo['group'];
      });
    });// TODO: implement initState
    super.initState();
  }
  TextEditingController t1 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.all(
            MediaQuery.of(context).size.height * 0.03,
          ),
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/backGroundIcon.png"),
          )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                      Text(
                        "Giriş Yap",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      TextFormField(
                        controller: t1,
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
                          labelStyle:
                              TextStyle(fontSize: 20, color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.blue, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      TextFormField(
                        onSaved: (x) {
                          setState(() {
                            password = x;
                          });
                        },
                        obscureText: _isHidden ? false : true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(_isHidden
                                ? Icons.remove_red_eye
                                : Icons.remove_red_eye_outlined),
                            onPressed: sifreGoster,
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.blue,
                          ),
                          labelText: "Şifre",
                          labelStyle:
                              TextStyle(fontSize: 20, color: Colors.grey),
                          errorStyle: TextStyle(
                            fontSize: 18,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.blue, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: RichText(
                          text: TextSpan(
                              text: 'Şifremi unuttum',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  _sifreGonder();
                                }),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: _emailSifreGiris,
                            color: Colors.blue[500],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30),
                            hoverColor: Colors.black,
                            child: Text(
                              "Giriş Yap",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.06,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                              child: RichText(
                                  text: TextSpan(
                                      text: 'Hesabın yok mu?',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                      children: <TextSpan>[
                                TextSpan(
                                    text: ' Kaydol',
                                    style: TextStyle(color: Colors.blue[500]),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushNamed(
                                            context, "/createUser");
                                      }),
                              ])))
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
Future<String> getEmail() async {
    await null;
     FirebaseFirestore.instance
        .collection('user')
        .doc(email)
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> firestoreinfo = documentSnapshot.data();
      setState(() {
        group = firestoreinfo['group'];
      });
    });// 
return group;
    
  }
  void _emailSifreGiris() async {
     await getEmail();
    getEmail().then((String m) => print(m));
    setState(() {
      _isLoading = true;
    });
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((user) {
        if (user.user.emailVerified == false) {
          Alert(
              type: AlertType.warning,
              context: context,
              title: "HATA!",
              desc:
                  "Lütfen Email Adresinizi Emailinize Gelen Mesajla Onaylayın. \n Email Ulaşmadıysa Aşağıdaki Butonu Tıklayınız!",
              buttons: [
                DialogButton(
                    child: Text(
                      "AKTİVASYON MAİLİ GÖNDER",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      user.user.sendEmailVerification();
                      Navigator.pop(context);
                    }),
              ]).show();
          setState(() {
            _isLoading = false;
          });
        } else {
          
         
          if (group == "user") {
            Navigator.pushNamed(context, "/donatePage");

            formKey.currentState.reset();
          } else
            (Alert(
                type: AlertType.warning,
                context: context,
                title: "GİRİŞ YAPILAMADI!",
                desc: "Bu Sayfadan Sadece Bireysel Hesap Girişi Yapabilirsiniz",
                buttons: [
                  DialogButton(
                    child: Text(
                      "KAPAT",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    onPressed: () => Navigator.pop(context),
                  )
                ]).show());
          setState(() {
            _isLoading = false;
          });
        }
      }).catchError((e) {

        Alert(
            type: AlertType.warning,
            context: context,
            title: "GİRİŞ YAPILAMADI!",
            desc: "Hatalı Email Adresi / Şifre",
            buttons: [
              DialogButton(
                child: Text(
                  "KAPAT",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                onPressed: () => Navigator.pop(context),
              )
            ]).show();
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _sifreGonder() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
    }
    await _auth.sendPasswordResetEmail(email: email).then((value) {
      Alert(
          type: AlertType.success,
          context: context,
          title: "ŞİFRE GÖNDERİLDİ!",
          desc: "Lütfen Email Adresinizi Kontrol Ediniz!!",
          buttons: [
            DialogButton(
              child: Text(
                "KAPAT",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              onPressed: () => Navigator.pop(context),
            )
          ]).show();
    }).catchError((onError) {
      Alert(
          type: AlertType.warning,
          context: context,
          title: "HATA!",
          desc: "Lütfen Kayıtlı Bir Email Adresi Giriniz!",
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

  sifreGoster() {
    FocusScope.of(context).unfocus();

    setState(() {
      if (!_isHidden) {
        this._isHidden = !this._isHidden;
      } else if (_isHidden) {
        this._isHidden = !this._isHidden;
      }
    });
  }
}
