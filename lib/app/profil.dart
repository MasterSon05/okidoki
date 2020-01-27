import 'dart:io';

import 'package:flutter/material.dart';
import 'package:okidoki/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:okidoki/common_widget/social_log_in_button.dart';
import 'package:okidoki/viewmodel/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  TextEditingController _controllerUserName;
  File _profilFoto;

  @override
  void initState() {
    super.initState();
    _controllerUserName = TextEditingController();
  }

  @override
  void dispose() {
    _controllerUserName.dispose();
    super.dispose();
  }

  void _kameradanFotoCek() async {
    var _yeniResim = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _profilFoto = _yeniResim;
      Navigator.of(context).pop();
    });
  }

  void _galeridenResimSec() async {
    var _yeniResim = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _profilFoto = _yeniResim;
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    _controllerUserName.text = _userModel.user.userName;
    //print("Profil sayfasındaki user degerleri :" + _userModel.user.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: <Widget>[
          FlatButton(
            onPressed: () => _cikisIcinOnayIste(context),
            child: Text(
              "Log Out",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: 160,
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.camera),
                                  title: Text("Kameradan Çek"),
                                  onTap: () {
                                    _kameradanFotoCek();
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.image),
                                  title: Text("Galeriden Seç"),
                                  onTap: () {
                                    _galeridenResimSec();
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                        child: Align(
                          heightFactor: 1,
                        
                      child: _profilFoto == null
                          ? FadeInImage.assetNetwork(
                              image: _userModel.user.profilURL,
                              placeholder: "assets/images/profile.png",
                            )
                          : Image(
                              image: FileImage(_profilFoto),
                              
                            ),
                    )),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _userModel.user.email,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _controllerUserName,
                  decoration: InputDecoration(
                    labelText: "User Name",
                    hintText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SocialLoginButton(
                  butonColor: Theme.of(context).primaryColor,
                  butonText: "Save Changes",
                  onPressed: () {
                    _userNameGuncelle(context);
                    _profilFotoGuncelle(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _cikisYap(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context);
    bool sonuc = await _userModel.signOut();
    return sonuc;
  }

  Future _cikisIcinOnayIste(BuildContext context) async {
    final sonuc = await PlatformDuyarliAlertDialog(
      baslik: "Emin Misiniz?",
      icerik: "Are you sure you want to quit?",
      anaButonYazisi: "Accept",
      iptalButonYazisi: "Cancel",
    ).goster(context);

    if (sonuc == true) {
      _cikisYap(context);
    }
  }

  void _userNameGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context);
    if (_userModel.user.userName != _controllerUserName.text) {
      var updateResult = await _userModel.updateUserName(
          _userModel.user.userID, _controllerUserName.text);

      if (updateResult == true) {
        PlatformDuyarliAlertDialog(
          baslik: "Successful",
          icerik: "Username changed successfully",
          anaButonYazisi: 'OK',
        ).goster(context);
      } else {
        _controllerUserName.text = _userModel.user.userName;
        PlatformDuyarliAlertDialog(
          baslik: "Error",
          icerik: "Username already in use",
          anaButonYazisi: 'OK',
        ).goster(context);
      }
    }
  }

  void _profilFotoGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context);
    if (_profilFoto != null) {
      var url = await _userModel.uploadFile(
          _userModel.user.userID, "profil_foto", _profilFoto);
      //print("gelen url :" + url);

      if (url != null) {
        PlatformDuyarliAlertDialog(
          baslik: "Successful",
          icerik: "Profile photo changed successfully",
          anaButonYazisi: 'OK',
        ).goster(context);
      }
    }
  }
}
