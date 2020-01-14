import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:okidoki/app/hata_exception.dart';
import 'package:okidoki/app/sign_in/login_screen.dart';
import 'package:okidoki/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:okidoki/common_widget/social_log_in_button.dart';

PlatformException myHata;

class SignInPage extends StatefulWidget {
  /*void _misafirGirisi(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context);
    User _user = await _userModel.singInAnonymously();
    print("Oturum açan user id:" + _user.userID.toString());
  }*/

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

 
  void _emailVeSifreGiris(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => LoginScreen(),
      ),
    );
  }

  @override
  void initState() {

    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (myHata != null)
        PlatformDuyarliAlertDialog(
          baslik: "Kullanıcı Oluşturma HATA",
          icerik: Hatalar.goster(myHata.code),
          anaButonYazisi: 'Tamam',
        ).goster(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OkiDoki"),
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Oturum Açın",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
            SizedBox(
              height: 8,
            ),
        
            SocialLoginButton(
              onPressed: () => _emailVeSifreGiris(context),
              butonIcon: Icon(
                Icons.email,
                color: Colors.white,
                size: 32,
              ),
              butonText: "Email ve Şifre ile Giriş yap",
            ),
            /*SocialLoginButton(
              onPressed: () => _misafirGirisi(context),
              butonColor: Colors.teal,
              butonIcon: Icon(Icons.supervised_user_circle),
              butonText: "Misafir Girişi",
            ),*/
          ],
        ),
      ),
    );
  }
}
