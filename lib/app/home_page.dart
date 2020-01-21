import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:okidoki/app/konusmalarim_page.dart';
import 'package:okidoki/app/kullanicilar.dart';
import 'package:okidoki/app/my_custom_bottom_navi.dart';
import 'package:okidoki/app/profil.dart';
import 'package:okidoki/app/search.dart';
import 'package:okidoki/app/tab_items.dart';
import 'package:okidoki/model/user.dart';
import 'package:okidoki/notification_handler.dart';
import 'package:okidoki/viewmodel/all_users_view_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final User user;

  HomePage({Key key, @required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.Konusmalarim;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.Konusmalarim: GlobalKey<NavigatorState>(),
    TabItem.Search: GlobalKey<NavigatorState>(),
  //  TabItem.Kullanicilar: GlobalKey<NavigatorState>(),
    TabItem.Profil: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> tumSayfalar() {
    return {
      TabItem.Konusmalarim: KonusmalarimPage(),
      TabItem.Search: SearchScreen(),
    /*  TabItem.Kullanicilar: ChangeNotifierProvider(
        create: (context) => AllUserViewModel(),
        child: KullanicilarPage(),
      ),*/
      TabItem.Profil: ProfilPage(),
    };
  }

  @override
  void initState() {
    super.initState();

    NotificationHandler().initializeFCMNotification(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: MyCustomBottomNavigation(
        sayfaOlusturucu: tumSayfalar(),
        navigatorKeys: navigatorKeys,
        currentTab: _currentTab,
        onSelectedTab: (secilenTab) {
          if (secilenTab == _currentTab) {
            navigatorKeys[secilenTab]
                .currentState
                .popUntil((route) => route.isFirst);
          } else {
            setState(() {
              _currentTab = secilenTab;
            });
          }
        },
      ),
    );
  }
}
