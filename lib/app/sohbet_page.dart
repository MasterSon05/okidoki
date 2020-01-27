import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:okidoki/app/ana_dil_secimi_page.dart';
import 'package:okidoki/app/trans_dil_secimi_page.dart';
import 'package:okidoki/model/dil.dart';
import 'package:okidoki/model/mesaj.dart';
import 'package:okidoki/viewmodel/chat_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:bubble/bubble.dart';
import 'package:translator/translator.dart';

class SohbetPage extends StatefulWidget {
  @override
  _SohbetPageState createState() => _SohbetPageState();
}

class _SohbetPageState extends State<SohbetPage> {
  TextEditingController _mesajController = TextEditingController();
  TextEditingController _ceviriMesajController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  bool _isLoading = false;
  bool sendingOK = false;

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
    if (_mesajController.text == "") {
      _ceviriMesajController.text = "";
    }
    final _chatModel = Provider.of<ChatViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Hero(
              tag: 'photo',
              child: CircleAvatar(
                child: ClipOval(
                    child: Align(
                  heightFactor: 1,
                  child: FadeInImage.assetNetwork(
                    image: _chatModel.sohbetEdilenUser.profilURL,
                    placeholder: "assets/images/profile.png",
                  ),
                )),
              ),
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
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(
            "assets/images/chatback.png",
          ),
          fit: BoxFit.cover,
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.2), BlendMode.dstATop),
        )),
        child: _chatModel.state == ChatViewState.Busy
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: Column(
                  children: <Widget>[
                    _buildDilSecimi(),
                    _buildMesajListesi(),
                    _buildYeniMesajGir(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildDilSecimi() {
    return Container(
      height: 50,
      color: Theme.of(context).accentColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: FlatButton(
              child: Text(
                transDil.dilEmo + transDil.dilAdi,
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => TransDilSecimiPage()));
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.swap_horiz,
              size: 30,
            ),
            onPressed: () {
              setState(() {
                var geciciDil = anaDil;
                anaDil = transDil;
                transDil = geciciDil;
              });
            },
          ),
          Expanded(
            child: FlatButton(
              child: Text(
                anaDil.dilEmo + anaDil.dilAdi,
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => AnaDilSecimiPage()));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMesajListesi() {
    return Consumer<ChatViewModel>(builder: (context, chatModel, child) {
      return Expanded(
        child: Container(
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
    return sendingOK
        ? Container(
            color: Theme.of(context).accentColor,
            padding: EdgeInsets.only(bottom: 8, left: 8, top: 4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      TextField(
                        readOnly: true,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        maxLines: 5,
                        minLines: 1,
                        controller: _ceviriMesajController,
                        cursorColor: Colors.blueGrey,
                        style: new TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(13),
                            child: Text(
                              anaDil.dilEmo,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          suffixIcon: Container(
                            padding: EdgeInsets.only(right: 2),
                            height: 20,
                            child: FloatingActionButton(
                              heroTag: "ceviri",
                              backgroundColor: Colors.deepPurple,
                              elevation: 0,
                              child: Icon(
                                Icons.send,
                                size: 35,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                if (_ceviriMesajController.text.trim().length >
                                    0) {
                                  Mesaj _kaydedilecekMesaj = Mesaj(
                                    kimden: _chatModel.currentUser.userID,
                                    kime: _chatModel.sohbetEdilenUser.userID,
                                    bendenMi: true,
                                    konusmaSahibi:
                                        _chatModel.currentUser.userID,
                                    mesaj: _ceviriMesajController.text,
                                  );
                                  WidgetsBinding.instance.addPostFrameCallback(
                                      (_) => _mesajController.clear());

                                  WidgetsBinding.instance.addPostFrameCallback(
                                      (_) => _ceviriMesajController.clear());
                                  var sonuc = await _chatModel.saveMessage(
                                      _kaydedilecekMesaj,
                                      _chatModel.currentUser);
                                  if (sonuc) {
                                    _scrollController.animateTo(
                                      0,
                                      curve: Curves.easeOut,
                                      duration:
                                          const Duration(milliseconds: 10),
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.deepPurpleAccent[100],
                          hintText: "Write Your Message",
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      TextField(
                        onChanged: (val) => sendingCeviri(val),
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        maxLines: 5,
                        minLines: 1,
                        controller: _mesajController,
                        cursorColor: Colors.blueGrey,
                        style: new TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(13),
                            child: Text(
                              transDil.dilEmo,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          suffixIcon: Container(
                            padding: EdgeInsets.only(right: 2),
                            height: 20,
                            child: FloatingActionButton(
                              heroTag: "mesaj",
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
                                    konusmaSahibi:
                                        _chatModel.currentUser.userID,
                                    mesaj: _mesajController.text,
                                  );
                                  WidgetsBinding.instance.addPostFrameCallback(
                                      (_) => _mesajController.clear());

                                  WidgetsBinding.instance.addPostFrameCallback(
                                      (_) => _ceviriMesajController.clear());

                                  var sonuc = await _chatModel.saveMessage(
                                      _kaydedilecekMesaj,
                                      _chatModel.currentUser);
                                  if (sonuc) {
                                    _scrollController.animateTo(
                                      0,
                                      curve: Curves.easeOut,
                                      duration:
                                          const Duration(milliseconds: 10),
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.deepPurpleAccent[100],
                          hintText: "Write Your Message",
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  child: FloatingActionButton(
                    heroTag: "gerial",
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.translate,
                      size: 27,
                    ),
                    onPressed: () {
                      setState(() {
                        sendingOK = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          )
        : Container(
            color: Theme.of(context).accentColor,
            padding: EdgeInsets.only(bottom: 8, left: 8, top: 4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    maxLines: 5,
                    minLines: 1,
                    controller: _mesajController,
                    cursorColor: Colors.blueGrey,
                    style: new TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      suffixIcon: Container(
                        padding: EdgeInsets.only(right: 2),
                        height: 20,
                        child: FloatingActionButton(
                          heroTag: "ceviriyegec",
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.translate,
                            size: 27,
                          ),
                          onPressed: () {
                            setState(() {
                              sendingOK = true;
                            });
                          },
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.deepPurpleAccent[100],
                      hintText: "Write Your Message",
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  child: FloatingActionButton(
                    heroTag: "send",
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
                        WidgetsBinding.instance.addPostFrameCallback(
                            (_) => _mesajController.clear());

                        WidgetsBinding.instance.addPostFrameCallback(
                            (_) => _ceviriMesajController.clear());

                        var sonuc = await _chatModel.saveMessage(
                            _kaydedilecekMesaj, _chatModel.currentUser);
                        if (sonuc) {
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

  sendingCeviri(val) {
    setState(() async {
      if (_mesajController.text == "") {
        _ceviriMesajController.text = "";
      } else if (_mesajController.text.length > 1) {
        _ceviriMesajController.text = await _ceviriYap(val);
      } else {
        _ceviriMesajController.text = "";
      }
    });
  }

  Widget _konusmaBalonuOlustur(Mesaj oankiMesaj) {
    Color _gelenMesajRenk = Theme.of(context).accentColor;
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
                Container(
                  width: MediaQuery.of(context).size.width / 1.4,
                  child: Bubble(
                    shadowColor: Colors.purpleAccent,
                    elevation: 5,
                    alignment: Alignment.topRight,
                    nip: BubbleNip.rightBottom,
                    color: _gidenMesajRenk,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          oankiMesaj.mesaj,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          _saatDakikaDegeri,
                          style: TextStyle(color: Colors.white, fontSize: 9),
                        ),
                      ],
                    ),
                  ),
                ),
                /* Flexible(
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
                ),*/
                // Text(_saatDakikaDegeri),
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
                Flexible(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.4,
                    child: GelenMesajBalonu(
                        gelenMesajRenk: _gelenMesajRenk,
                        saatDakikaDegeri: _saatDakikaDegeri,
                        oankiMesaj: oankiMesaj),
                  ),
                  /*  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _gelenMesajRenk,
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(oankiMesaj.mesaj),
                  ),*/
                ),
                //   Text(_saatDakikaDegeri),
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

class GelenMesajBalonu extends StatefulWidget {
  const GelenMesajBalonu({
    Key key,
    @required Color gelenMesajRenk,
    @required String saatDakikaDegeri,
    @required Mesaj oankiMesaj,
  })  : _gelenMesajRenk = gelenMesajRenk,
        _saatDakikaDegeri = saatDakikaDegeri,
        _oankiMesaj = oankiMesaj,
        super(key: key);

  final Color _gelenMesajRenk;
  final String _saatDakikaDegeri;
  final Mesaj _oankiMesaj;

  @override
  _GelenMesajBalonuState createState() => _GelenMesajBalonuState();
}

class _GelenMesajBalonuState extends State<GelenMesajBalonu> {
  bool cevrildi = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (cevrildi) {
          setState(() {
            cevrildi = false;
          });
        } else {
          setState(() {
            cevrildi = true;
          });
        }
      },
      child: Bubble(
        shadowColor: widget._gelenMesajRenk,
        elevation: 5,
        alignment: Alignment.topLeft,
        nip: BubbleNip.leftTop,
        color: widget._gelenMesajRenk,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            cevrildi
                ? FutureBuilder<String>(
                    future: _ceviriYap(widget._oankiMesaj.mesaj),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          transDil.dilEmo +
                              ": " +
                              widget._oankiMesaj.mesaj +
                              "\n" +
                              anaDil.dilEmo +
                              ": " +
                              snapshot.data.toString(),
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        );
                      } else if (snapshot.hasError) {
                        return Text("Error",
                            style:
                                TextStyle(color: Colors.black, fontSize: 16));
                      } else {
                        return Text("Loading",
                            style:
                                TextStyle(color: Colors.black, fontSize: 16));
                      }
                    })
                : Text(
                    widget._oankiMesaj.mesaj,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
            Text(
              widget._saatDakikaDegeri,
              style: TextStyle(color: Colors.black, fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }
}

Future<String> _ceviriYap(String gelenMetin) async {
  final translator = GoogleTranslator();
  String cevirilenMetin;

  var translation = await translator.translate(gelenMetin,
      from: transDil.dilCode, to: anaDil.dilCode);
  cevirilenMetin = translation;

  return cevirilenMetin;
}
