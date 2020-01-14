import 'package:flutter/material.dart';
import 'package:okidoki/app/home_page.dart';
import 'package:okidoki/app/sign_in/sign_in_page.dart';
import 'package:okidoki/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    if (_userModel.state == ViewState.Idle) {
      if (_userModel.user == null) {
        return SignInPage();
      } else {
        return HomePage(user: _userModel.user);
      }
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
