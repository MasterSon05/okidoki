import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:okidoki/app/sohbet_page.dart';
import 'package:okidoki/common_widget/social_log_in_button.dart';
import 'package:okidoki/model/user.dart';
import 'package:okidoki/services/search_servise.dart';
import 'package:okidoki/viewmodel/chat_view_model.dart';
import 'package:okidoki/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String name = "";

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Kullanıcı Adı Giriniz',
            border: OutlineInputBorder(),
          ),
          onChanged: (val) => initiateSearch(val),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: SearchService().firebaseSeacrh(name),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          if (snapshot.hasData) {
            if (snapshot.data.documents.length > 0) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  return Padding(
                    padding: const EdgeInsets.only(top: 70.0),
                    child: ListView(
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        return Center(
                          child: Card(
                            child: Container(
                              padding: EdgeInsets.all(20.0),
                              width: MediaQuery.of(context).size.width / 1.3,
                              height: MediaQuery.of(context).size.height / 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 150,
                                    width: 150,
                                    child: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(document['profilURL']),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    document['userName'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  SocialLoginButton(
                                    butonText: "Sohbet Başlat",
                                    butonColor: Theme.of(context).primaryColor,
                                    radius: 10,
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChangeNotifierProvider(
                                            builder: (context) => ChatViewModel(
                                                currentUser: _userModel.user,
                                                sohbetEdilenUser:
                                                    User.idveResim(
                                                        userID:
                                                            document['userID'],
                                                        userName: document[
                                                            'userName'],
                                                        profilURL: document[
                                                            'profilURL'])),
                                            child: SohbetPage(),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
              }
            } else {
              return Text("Arama Yapınız");
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  void initiateSearch(String val) {
    setState(() {
      name = val.toLowerCase().trim();
    });
  }
}
