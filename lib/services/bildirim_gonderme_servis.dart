import 'package:okidoki/model/mesaj.dart';
import 'package:okidoki/model/user.dart';
import 'package:http/http.dart' as http;

class BildirimGondermeServis {
  Future<bool> bildirimGonder(
      Mesaj gonderilecekBildirim, User gonderenUser, String token) async {
    String endURL = "https://fcm.googleapis.com/fcm/send";
    String firebaseKey =
        "AAAAi_RG4c8:APA91bFuzFFOP8n1h7L2A4xe3aBLxclNajr3scXZHDlFEilOiuLgaflDRd_yJ6EzJEDKL1SXfqusiyrVwgtVDDV9YC9apXYk9MqmWZbsxGCnyjTbrjTxyX-Qgv5gRKrV2q9ttomaplEb";
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "key=$firebaseKey"
    };

    String json =
        '{ "to" : "$token", "data" : { "message" : "${gonderilecekBildirim.mesaj}", "title": "${gonderenUser.userName}", "profilURL": "${gonderenUser.profilURL}", "gonderenUserID" : "${gonderenUser.userID}" } }';

    http.Response response =
        await http.post(endURL, headers: headers, body: json);

    if (response.statusCode == 200) {
      print("işlem basarılı");
    } else {
      /*print("işlem basarısız:" + response.statusCode.toString());
      print("jsonumuz:" + json);*/
    }
  }
}
