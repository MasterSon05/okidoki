import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:okidoki/model/mesaj.dart';
import 'package:okidoki/viewmodel/chat_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SohbetPage extends StatefulWidget {
  @override
  _SohbetPageState createState() => _SohbetPageState();
}

class _SohbetPageState extends State<SohbetPage> {
  var _mesajController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _chatModel = Provider.of<ChatViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Hero(
              tag: 'photo',
              child: CircleAvatar(
                  backgroundImage:
                      NetworkImage(_chatModel.sohbetEdilenUser.profilURL)),
            ),
            SizedBox(
              width: 10,
            ),
            Text(_chatModel.sohbetEdilenUser.userName != null
                ? _chatModel.sohbetEdilenUser.userName
                : "loading"),
          ],
        ),
      ),
      body: _chatModel.state == ChatViewState.Busy
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                children: <Widget>[
                  _buildMesajListesi(),
                  _buildYeniMesajGir(),
                ],
              ),
            ),
    );
  }

  Widget _buildMesajListesi() {
    return Consumer<ChatViewModel>(builder: (context, chatModel, child) {
      return Expanded(
        
        child: Container(
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/chatback.png",),fit: BoxFit.cover)),
          child: ListView.builder(
            controller: _scrollController,
            reverse: true,
            itemBuilder: (context, index) {
              if (chatModel.hasMoreLoading &&
                  chatModel.mesajlarListesi.length == index) {
                return _yeniElemanlarYukleniyorIndicator();
              } else
                return _konusmaBalonuOlustur(chatModel.mesajlarListesi[index]);
            },
            itemCount: chatModel.hasMoreLoading
                ? chatModel.mesajlarListesi.length + 1
                : chatModel.mesajlarListesi.length,
          ),
        ),
      );
    });
  }

  Widget _buildYeniMesajGir() {
    final _chatModel = Provider.of<ChatViewModel>(context);
    return Container(
      padding: EdgeInsets.only(bottom: 8, left: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _mesajController,
              cursorColor: Colors.blueGrey,
              style: new TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                filled: true,
                hintText: "Mesajınızı Yazın",
                border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 4,
            ),
            child: FloatingActionButton(
              backgroundColor: Colors.deepPurple,
              elevation: 0,
              child: Icon(
                Icons.send,
                size: 35,
                color: Colors.white,
              ),
              onPressed: () async {
                if (_mesajController.text.trim().length > 0) {
                  Mesaj _kaydedilecekMesaj = Mesaj(
                    kimden: _chatModel.currentUser.userID,
                    kime: _chatModel.sohbetEdilenUser.userID,
                    bendenMi: true,
                    konusmaSahibi: _chatModel.currentUser.userID,
                    mesaj: _mesajController.text,
                  );

                  var sonuc = await _chatModel.saveMessage(
                      _kaydedilecekMesaj, _chatModel.currentUser);
                  if (sonuc) {
                    _mesajController.clear();
                    _scrollController.animateTo(
                      0,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 10),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _konusmaBalonuOlustur(Mesaj oankiMesaj) {
    Color _gelenMesajRenk = Colors.blue;
    Color _gidenMesajRenk = Theme.of(context).primaryColor;
    final _chatModel = Provider.of<ChatViewModel>(context);
    var _saatDakikaDegeri = "";

    try {
      _saatDakikaDegeri = _saatDakikaGoster(oankiMesaj.date ?? Timestamp(1, 1));
    } catch (e) {
      print("hata var:" + e.toString());
    }

    var _benimMesajimMi = oankiMesaj.bendenMi;
    if (_benimMesajimMi) {
      return Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _gidenMesajRenk,
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(
                      oankiMesaj.mesaj,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Text(_saatDakikaDegeri),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.grey.withAlpha(40),
                  backgroundImage:
                      NetworkImage(_chatModel.sohbetEdilenUser.profilURL),
                ),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _gelenMesajRenk,
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(oankiMesaj.mesaj),
                  ),
                ),
                Text(_saatDakikaDegeri),
              ],
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      );
    }
  }

  String _saatDakikaGoster(Timestamp date) {
    var _formatter = DateFormat.Hm();
    var _formatlanmisTarih = _formatter.format(date.toDate());
    return _formatlanmisTarih;
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      eskiMesajlariGetir();
    }
  }

  void eskiMesajlariGetir() async {
    final _chatModel = Provider.of<ChatViewModel>(context);
    if (_isLoading == false) {
      _isLoading = true;
      await _chatModel.dahaFazlaMesajGetir();
      _isLoading = false;
    }
  }

  _yeniElemanlarYukleniyorIndicator() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
