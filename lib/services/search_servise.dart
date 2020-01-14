import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  firebaseSeacrh(name) {
    var gelenData;
    try {
      gelenData = Firestore.instance
          .collection('users')
          .where("userName", isEqualTo: name)
          .snapshots();
    } catch (e) {}
    return gelenData;
  }
}
