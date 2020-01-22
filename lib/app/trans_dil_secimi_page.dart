import 'package:flutter/material.dart';
import 'package:okidoki/model/dil.dart';

class TransDilSecimiPage extends StatefulWidget {
  @override
  _TransDilSecimiPageState createState() => _TransDilSecimiPageState();
}

class _TransDilSecimiPageState extends State<TransDilSecimiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Language Selection"),
      ),
      body: ListView.builder(
        itemCount: dilList.diller.length,
        itemBuilder: (context, index) {
          return FlatButton(
            onPressed: () {
              setState(() {
                transDil = dilList.diller[index];
              });
              Navigator.pop(context);
            },
            child: Column(
              children: <Widget>[
                ListTile(
                    leading: Text(dilList.diller[index].dilEmo),
                    title: Text(
                      dilList.diller[index].dilAdi,
                    )),
                Divider(
                  height: 1,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
