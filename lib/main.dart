import 'package:flutter/material.dart';
import 'package:okidoki/app/landing_page.dart';
import 'package:okidoki/locator.dart';
import 'package:okidoki/model/dil.dart';
import 'package:okidoki/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserModel(),
      child: MaterialApp(
          title: 'OkiDoki',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            accentColor: Colors.orange,
            cursorColor: Colors.orange,
            textTheme: TextTheme(
              display2: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 45.0,
                color: Colors.orange,
              ),
              button: TextStyle(
                fontFamily: 'OpenSans',
              ),
              subhead: TextStyle(fontFamily: 'NotoSans'),
              body1: TextStyle(fontFamily: 'NotoSans'),
            ),
          ),
          home: LandingPage()),
    );
  }
}
