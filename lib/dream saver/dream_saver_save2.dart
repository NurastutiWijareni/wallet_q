import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wallet_q/dream%20saver/dream_saver_services.dart';
import 'package:wallet_q/home.dart';

import '../users.dart';
import '../users_services.dart';

enum TimeSaving { tiga_bulan, enam_bulan, sembilan_bulan, duabelas_bulan }

class DreamSaverSave2 extends StatefulWidget {
  const DreamSaverSave2({Key? key, required this.title, required this.price, required this.imageLink, required this.link})
      : super(key: key);
  final String title;
  final String price;
  final String imageLink;
  final String link;

  @override
  _DreamSaverSave2State createState() => _DreamSaverSave2State();
}

class _DreamSaverSave2State extends State<DreamSaverSave2> {
  Users? users;
  bool isChecked = false;
  TimeSaving? _timeSaving = TimeSaving.tiga_bulan;

  DateTime dateTime = DateTime(DateTime.now().year, DateTime.now().month + 3, DateTime.now().day);
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    UsersServices.readUser(user.uid).then(
      (value) {
        try {
          users = value;
        } catch (e) {}
      },
    );
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
        child: Container(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 400,
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * (1 / 7) + 18.0,
                        bottom: 18.0,
                        left: 18.0,
                        right: 18.0,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFE86EAE),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFF9C4A75),
                            width: 10,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Tercapai pada",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  dateTime.day.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 48.0,
                                  ),
                                ),
                                Text(
                                  DateFormat.MMMM().format(dateTime),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                                Text(
                                  dateTime.year.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 18,
                          ),
                          Text(
                            "Rencana nabung berapa lama nih ?",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "3 Bulan",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Radio<TimeSaving>(
                                value: TimeSaving.tiga_bulan,
                                groupValue: _timeSaving,
                                activeColor: Color(0xFF009789),
                                onChanged: (TimeSaving? value) {
                                  setState(
                                    () {
                                      _timeSaving = value;
                                      isChecked = true;
                                      dateTime = DateTime(DateTime.now().year, DateTime.now().month + 3, DateTime.now().day);
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "6 Bulan",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Radio<TimeSaving>(
                                value: TimeSaving.enam_bulan,
                                groupValue: _timeSaving,
                                activeColor: Color(0xFF009789),
                                onChanged: (TimeSaving? value) {
                                  setState(
                                    () {
                                      _timeSaving = value;
                                      isChecked = true;
                                      dateTime = DateTime(DateTime.now().year, DateTime.now().month + 6, DateTime.now().day);
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "9 Bulan",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Radio<TimeSaving>(
                                value: TimeSaving.sembilan_bulan,
                                groupValue: _timeSaving,
                                activeColor: Color(0xFF009789),
                                onChanged: (TimeSaving? value) {
                                  setState(
                                    () {
                                      _timeSaving = value;
                                      isChecked = true;
                                      dateTime = DateTime(DateTime.now().year, DateTime.now().month + 9, DateTime.now().day);
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "12 Bulan",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Radio<TimeSaving>(
                                value: TimeSaving.duabelas_bulan,
                                groupValue: _timeSaving,
                                activeColor: Color(0xFF009789),
                                onChanged: (TimeSaving? value) {
                                  setState(
                                    () {
                                      _timeSaving = value;
                                      isChecked = true;
                                      dateTime = DateTime(DateTime.now().year + 1, DateTime.now().month, DateTime.now().day);
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              height: 55,
                              child: NeumorphicButton(
                                onPressed: () async {
                                  await DreamSaversServices.createDreamSaver(
                                    users!.id,
                                    int.parse(widget.price.replaceAll(RegExp(r'[^0-9]'), '')),
                                    0,
                                    widget.title,
                                    widget.imageLink,
                                    widget.link,
                                    dateTime.millisecondsSinceEpoch,
                                    DateTime.now().millisecondsSinceEpoch,
                                  );
                                  Get.offAll(() => Home());
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
                                  color: const Color(0xFFFF98CE),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Selanjutnya",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: "Inter",
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
                      "Dream Saver Baru",
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
            ],
          ),
        ),
      ),
    );
  }
}
