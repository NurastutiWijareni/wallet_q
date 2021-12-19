import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallet_q/dream%20saver/dream_saver.dart';
import 'package:wallet_q/dream%20saver/dream_saver_services.dart';
import 'package:wallet_q/dream%20saver/dream_savers.dart';
import 'package:wallet_q/tabungan/tabungan_services.dart';
import 'package:wallet_q/users.dart';
import 'package:wallet_q/users_services.dart';

class DreamSaverView extends StatefulWidget {
  const DreamSaverView({Key? key}) : super(key: key);

  @override
  _DreamSaverViewState createState() => _DreamSaverViewState();
}

class _DreamSaverViewState extends State<DreamSaverView> {
  List<DreamSavers>? dreamSavers;
  bool isLoaded = false;
  final _textcontrollerAMOUNT = TextEditingController();
  final _textcontrollerITEM = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    if (!isLoaded) {
      UsersServices.readUser(user.uid).then(
        (value) {
          try {
            DreamSaversServices.readDreamSaver(user.uid).then(
              (value) {
                setState(
                  () {
                    dreamSavers = value;
                    isLoaded = true;
                  },
                );
              },
            );
          } catch (e) {}
        },
      );
    }

    void _enterTransaction(bool _isIncome, String description, int amountTarget, int timeCreated) {
      TabungansServices.createTabungan(
        user.uid,
        int.parse(_textcontrollerAMOUNT.text),
        description,
        (_isIncome) ? "Pemasukan" : "Pengeluaran",
        DateTime.now().millisecondsSinceEpoch,
      );
      DreamSaversServices.DreamSaversCollection.doc(user.uid + amountTarget.toString() + timeCreated.toString()).update({
        "amountSaved": int.parse(_textcontrollerAMOUNT.text),
      });
      setState(() {
        isLoaded = false;
        _isIncome = false;
        _textcontrollerAMOUNT.text = "";
        _textcontrollerITEM.text = "";
      });
    }

    void _newTransaction(String description, int amountTarget, int timeCreated) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                title: const Text(
                  'D R E A M S A V E R',
                  textAlign: TextAlign.center,
                ),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Jumlah',
                                ),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Masukkan Jumlah';
                                  }
                                  return null;
                                },
                                controller: _textcontrollerAMOUNT,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  MaterialButton(
                    color: Colors.pink[300],
                    child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  MaterialButton(
                    color: Colors.pink[300],
                    child: const Text('Enter', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _enterTransaction(false, description, amountTarget, timeCreated);
                        Navigator.of(context).pop();
                      }
                    },
                  )
                ],
              );
            },
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: 1000,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [
              0.5,
              0.9,
            ],
            colors: [
              Color(0xFFFFC0CB),
              Colors.white,
            ],
          ),
        ),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * (1 / 7),
              decoration: BoxDecoration(
                color: Color(0xFFFF98CE),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  Text(
                    "Dream Saver",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Icon(
                    Icons.arrow_back_ios,
                    color: Colors.transparent,
                    size: 30,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * (1 / 7),
                bottom: 18.0,
                left: 18.0,
                right: 18.0,
              ),
              child: (isLoaded)
                  ? ListView.builder(
                      itemCount: dreamSavers!.length + 1,
                      itemBuilder: (context, index) {
                        return (index == dreamSavers!.length)
                            ? SizedBox(
                                height: 50,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: NeumorphicButton(
                                    onPressed: () async {
                                      Get.to(() => DreamSaver());
                                    },
                                    provideHapticFeedback: true,
                                    style: NeumorphicStyle(
                                      shape: NeumorphicShape.flat,
                                      boxShape: NeumorphicBoxShape.roundRect(
                                        BorderRadius.circular(6),
                                      ),
                                      depth: 1,
                                      shadowDarkColor: Colors.black,
                                      lightSource: LightSource.top,
                                      color: Color(0xFFDD2A7B),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 18.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 200,
                                  child: NeumorphicButton(
                                    onPressed: () async {
                                      String url = dreamSavers![index].sourceLink;
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        // can't launch url
                                      }
                                    },
                                    provideHapticFeedback: true,
                                    style: NeumorphicStyle(
                                      shape: NeumorphicShape.flat,
                                      boxShape: NeumorphicBoxShape.roundRect(
                                        BorderRadius.circular(16),
                                      ),
                                      depth: 1,
                                      shadowDarkColor: Colors.black,
                                      lightSource: LightSource.top,
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: SizedBox(),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width - 104,
                                                child: Text(
                                                  dreamSavers![index].title,
                                                  style: const TextStyle(
                                                    fontSize: 14.0,
                                                    color: Color(0xFF073B80),
                                                  ),
                                                ),
                                              ),
                                              LinearPercentIndicator(
                                                padding: EdgeInsets.all(0),
                                                width: MediaQuery.of(context).size.width - 104,
                                                animation: true,
                                                animationDuration: 1000,
                                                lineHeight: 5.0,
                                                percent: dreamSavers![index].amountSaved / dreamSavers![index].amountTarget,
                                                progressColor: Color(0xFF34C759),
                                              ),
                                              Text(
                                                "${(dreamSavers![index].amountSaved / dreamSavers![index].amountTarget) * 100}% Telah Masuk",
                                                style: const TextStyle(
                                                  fontSize: 12.0,
                                                  color: Color(0xFF073B80),
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width - 104,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Rp.${(dreamSavers![index].amountTarget - dreamSavers![index].amountSaved).toString()}",
                                                      style: const TextStyle(
                                                        fontSize: 20.0,
                                                        color: Color(0xFF073B80),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.centerRight,
                                                      child: NeumorphicButton(
                                                        padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 4.0),
                                                        onPressed: () async {
                                                          _newTransaction(dreamSavers![index].title, dreamSavers![index].amountTarget,
                                                              dreamSavers![index].timeCreated);
                                                        },
                                                        provideHapticFeedback: true,
                                                        style: NeumorphicStyle(
                                                          shape: NeumorphicShape.flat,
                                                          boxShape: NeumorphicBoxShape.roundRect(
                                                            BorderRadius.circular(6),
                                                          ),
                                                          depth: 1,
                                                          shadowDarkColor: Colors.black,
                                                          lightSource: LightSource.top,
                                                          color: Color(0xFFDD2A7B),
                                                        ),
                                                        child: Icon(
                                                          Icons.add,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                      },
                    )
                  : SpinKitFadingCircle(
                      color: Colors.white,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
