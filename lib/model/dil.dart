import 'package:flutter/material.dart';

final dilList = new DilList(diller: [
  Dil(dilAdi: "Türkçe", dilEmo: "tr", dilCode: "tr"),
  Dil(dilAdi: "İngilizce", dilEmo: "en", dilCode: "en"),
  Dil(dilAdi: "İngilizce", dilEmo: "en", dilCode: "en"),
  Dil(dilAdi: "İngilizce", dilEmo: "en", dilCode: "en"),
  Dil(dilAdi: "İngilizce", dilEmo: "en", dilCode: "en")
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

Dil anaDil = Dil(dilAdi: "Türkçe", dilEmo: "tr", dilCode: "tr");
Dil transDil = Dil(dilAdi: "İngilizce", dilEmo: "tr", dilCode: "tr");
