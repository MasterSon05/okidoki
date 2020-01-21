import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem { Konusmalarim, Search, /*Kullanicilar,*/ Profil }

class TabItemData {
  final String title;
  final IconData icon;

  TabItemData(this.title, this.icon);

  static Map<TabItem, TabItemData> tumTablar = {
    TabItem.Konusmalarim: TabItemData("Chats", Icons.chat),
    TabItem.Search: TabItemData("Search", Icons.search),
   // TabItem.Kullanicilar:
    //    TabItemData("Kullanıcılar", Icons.supervised_user_circle),
    TabItem.Profil: TabItemData("Profile", Icons.person),
  };
}
