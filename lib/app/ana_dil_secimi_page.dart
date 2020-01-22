import 'package:flutter/material.dart';
import 'package:okidoki/model/dil.dart';

class AnaDilSecimiPage extends StatefulWidget {
  @override
  _AnaDilSecimiPageState createState() => _AnaDilSecimiPageState();
}

class _AnaDilSecimiPageState extends State<AnaDilSecimiPage> {
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
                anaDil = dilList.diller[index];
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
