import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem { Kullanicilar, Search, Konusmalarim, Profil }

class TabItemData {
  final String title;
  final IconData icon;

  TabItemData(this.title, this.icon);

  static Map<TabItem, TabItemData> tumTablar = {
    TabItem.Kullanicilar:
        TabItemData("Kullanıcılar", Icons.supervised_user_circle),
        TabItem.Search: TabItemData("Arama", Icons.search),
    TabItem.Konusmalarim: TabItemData("Konusmalarım", Icons.chat),
    TabItem.Profil: TabItemData("Profil", Icons.person),
  };
}
