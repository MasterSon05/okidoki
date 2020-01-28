import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:okidoki/app/sohbet_page.dart';
import 'package:okidoki/model/konusma.dart';
import 'package:okidoki/model/user.dart';
import 'package:okidoki/viewmodel/chat_view_model.dart';
import 'package:okidoki/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class KonusmalarimPage extends StatefulWidget {
  @override
  _KonusmalarimPageState createState() => _KonusmalarimPageState();
}

class _KonusmalarimPageState extends State<KonusmalarimPage> {
  @override
  void initState() {
    super.initState();
    initializeFCMNotification(context);
  }

//bildirim bölümü
  FirebaseMessaging _fcm = FirebaseMessaging();

  initializeFCMNotification(BuildContext context) async {
   
    _fcm.onTokenRefresh.listen((newToken) async {
      FirebaseUser _currentUser = await FirebaseAuth.instance.currentUser();
      await Firestore.instance
          .document("tokens/" + _currentUser.uid)
          .setData({"token": newToken});
    });

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
    //    print("onMessage tetiklendi: $message");
        _konusmalarimListesiniYenile();
      },
      onLaunch: (Map<String, dynamic> message) async {
        //print("onLaunch. tetiklendi: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        // print("onResume tetiklendi: $message");
      },
    );
  }


  //konuşmalarım sayfası
  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text("Chats",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                      )),
                  background: Image.asset(
                    "assets/images/chatimage.png",
                    fit: BoxFit.cover,
                  )),
            ),
          ];
        },
        body: FutureBuilder<List<Konusma>>(
          future: _userModel.getAllConversations(_userModel.user.userID),
          builder: (context, konusmaListesi) {
            if (!konusmaListesi.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              var tumKonusmalar = konusmaListesi.data;

              if (tumKonusmalar.length > 0) {
                return RefreshIndicator(
                  onRefresh: _konusmalarimListesiniYenile,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      var oankiKonusma = tumKonusmalar[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider(
                                create: (context) => ChatViewModel(
                                  currentUser: _userModel.user,
                                  sohbetEdilenUser: User.idveResim(
                                      userID: oankiKonusma.kimleKonusuyor,
                                      userName: oankiKonusma.konusulanUserName,
                                      profilURL:
                                          oankiKonusma.konusulanUserProfilURL),
                                ),
                                child: SohbetPage(),
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: <Widget>[
                            ListTile(
                                title: Text(oankiKonusma.konusulanUserName),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(oankiKonusma.sonYollananMesaj),
                                    Text(oankiKonusma.aradakiFark)
                                  ],
                                ),
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.white,
                                  child: ClipOval(
                                      child: Align(
                                    heightFactor: 1,
                                    child: FadeInImage.assetNetwork(
                                      image:
                                          oankiKonusma.konusulanUserProfilURL,
                                      placeholder: "assets/images/profile.png",
                                    ),
                                  )),
                                )),
                            Divider(
                              color: Colors.black,
                              height: 1,
                            )
                          ],
                        ),
                      );
                    },
                    itemCount: tumKonusmalar.length,
                  ),
                );
              } else {
                return RefreshIndicator(
                  onRefresh: _konusmalarimListesiniYenile,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.chat,
                              color: Theme.of(context).primaryColor,
                              size: 120,
                            ),
                            Text(
                              "Henüz Konusma Yapılmamış",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 36),
                            )
                          ],
                        ),
                      ),
                      height: MediaQuery.of(context).size.height - 150,
                    ),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }

  Future<Null> _konusmalarimListesiniYenile() async {
    setState(() {});
    await Future.delayed(Duration(seconds: 1));
    return null;
  }
}
