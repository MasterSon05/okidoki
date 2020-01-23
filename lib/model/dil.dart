import 'package:flutter/material.dart';

final dilList = new DilList(diller: [
  Dil(dilAdi: "Türkçe", dilEmo: "🇹🇷", dilCode: "tr"),
  Dil(dilAdi: "İngilizce", dilEmo: "🇬🇧", dilCode: "en"),
  Dil(dilAdi: "Almanca", dilEmo: "🇩🇪", dilCode: "de"),
  Dil(dilAdi: "Rusça", dilEmo: "🇷🇺", dilCode: "ru"),
  Dil(dilAdi: "İspanyolca", dilEmo: "🇪🇸", dilCode: "es"),
  Dil(dilAdi: "Çince", dilEmo: "🇨🇳", dilCode: "zh-cn"),
   Dil(dilAdi: "Japonca", dilEmo: "🇯🇵", dilCode: "ja"),
    Dil(dilAdi: "İtalyanca", dilEmo: "🇮🇹", dilCode: "it"),
]);

class DilList {
  final List<Dil> diller;

  DilList({
    @required this.diller,
  });
}

class Dil {
  final String dilAdi;
  final String dilEmo;
  final String dilCode;

  Dil({
    @required this.dilAdi,
    @required this.dilEmo,
    @required this.dilCode,
  });
}

Dil anaDil = Dil(dilAdi: "Türkçe", dilEmo: "🇹🇷", dilCode: "tr");
Dil transDil = Dil(dilAdi: "İngilizce", dilEmo: "🇬🇧", dilCode: "en");
