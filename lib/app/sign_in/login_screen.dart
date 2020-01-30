import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:okidoki/app/landing_page.dart';

import 'package:okidoki/model/user.dart';
import 'package:okidoki/viewmodel/user_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email, _sifre;

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  Future<String> _loginUser(LoginData data) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    _email = data.name;
    _sifre = data.password;
    try {
      User _girisYapanUser =
          await _userModel.signInWithEmailandPassword(_email, _sifre);
    } on PlatformException catch (e) {
      return 'email or password is wrong';
    }
    return Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => LandingPage(),
    ));
  }

  Future<String> _createUser(LoginData data) async {
    final _userModel = Provider.of<UserModel>(context,listen: false);
    _email = data.name;
    _sifre = data.password;
    try {
      User _olusturulanUser =
          await _userModel.createUserWithEmailandPassword(_email, _sifre);
      //if (_girisYapanUser != null)
      //print("Oturum açan user id:" + _girisYapanUser.userID.toString());

    } on PlatformException catch (e) {
      return 'email already in use ';
    }
    return Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => LandingPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
  
   
    return FlutterLogin(
      title: 'OkiDoki',
      onLogin: (loginData) {
        print('Login info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');
        return _loginUser(loginData);
      },
      onSignup: (loginData) {
        print('Signup info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');
        return _createUser(loginData);
      },
      

      onRecoverPassword: (_) => Future(null),
      
    );
  }
}
