import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:wallet_q/riwayat/riwayat_services.dart';
import 'package:wallet_q/tabungan/tabungan_services.dart';
import 'package:wallet_q/target%20tabungan/target_tabungan_add.dart';
import 'package:wallet_q/target%20tabungan/target_tabungan_services.dart';
import 'package:wallet_q/target%20tabungan/target_tabungans.dart';
import 'package:wallet_q/users.dart';
import 'package:wallet_q/users_services.dart';

class TargetTabungan extends StatefulWidget {
  const TargetTabungan({Key? key}) : super(key: key);

  @override
  _TargetTabunganState createState() => _TargetTabunganState();
}

class _TargetTabunganState extends State<TargetTabungan> {
  List<TargetTabungans>? targetTabungans;
  bool isLoaded = false;
  String targetTabunganReached = "";
  final _textcontrollerAMOUNT = TextEditingController();
  final _textcontrollerITEM = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Users? users;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    if (!isLoaded) {
      UsersServices.readUser(user.uid).then(
        (value) {
          try {
            users = value;
            TargetTabungansServices.readTargetTabungan(user.uid).then(
              (value) {
                setState(
                  () {
                    targetTabungans = value;
                    isLoaded = true;
                  },
                );
              },
            );
          } catch (e) {}
        },
      );
    }

    void _enterTransaction(bool _isIncome, String description, int amountTarget, int amountSaved, int timeCreated) {
      TabungansServices.createTabungan(
        user.uid,
        int.parse(_textcontrollerAMOUNT.text),
        description,
        (_isIncome) ? "Pemasukan" : "Pengeluaran",
        DateTime.now().millisecondsSinceEpoch,
      );
      TargetTabungansServices.TargetTabungansCollection.doc(user.uid + amountTarget.toString() + timeCreated.toString()).update({
        "amountSaved": int.parse(_textcontrollerAMOUNT.text) + amountSaved,
      });
      if (amountTarget - (amountSaved + int.parse(_textcontrollerAMOUNT.text)) == 0) {
        RiwayatsServices.createRiwayat(user.uid, amountTarget, description, description, DateTime.now().millisecondsSinceEpoch);
        UsersServices.updateUser(
            user.uid, user.email, users!.name, users!.username, users!.phoneNumber, users!.profilePicture, users!.points + 50);
      }
      setState(() {
        isLoaded = false;
        _isIncome = false;
        _textcontrollerAMOUNT.text = "";
        _textcontrollerITEM.text = "";
      });
    }

    void _newTransaction(String description, int amountTarget, int amountSaved, int timeCreated) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                title: const Text(
                  'T A R G E T T A B U N G A N',
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
                        if (amountTarget - (amountSaved + int.parse(_textcontrollerAMOUNT.text)) < 0) {
                          Get.snackbar(
                            "Perhatian",
                            "Jumlah yang anda masukkan sudah melebihi yang diperlukan",
                            snackPosition: SnackPosition.TOP,
                            isDismissible: false,
                            backgroundColor: Color(0xFFEEE5FF),
                            duration: const Duration(seconds: 3),
                            margin: const EdgeInsets.only(bottom: 0, left: 0, right: 0, top: 0),
                            colorText: Colors.black,
                            borderRadius: 16,
                          );
                        } else {
                          _enterTransaction(true, description, amountTarget, amountSaved, timeCreated);
                          Navigator.of(context).pop();
                        }
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
        child: Container(
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
                      "Target Tabungan",
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
                    ? (targetTabungans!.length == 0)
                        ? Column(
                            children: [
                              Lottie.asset("assets/lotties/empty.json"),
                              SizedBox(
                                height: 50,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: NeumorphicButton(
                                    onPressed: () async {
                                      if (targetTabungans!.length == 2) {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor: Color(0xFFFF98CE),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                              elevation: 16,
                                              content: Container(
                                                height: 250,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Target Tabungan yang kamu buat tidak boleh lebih dari 2",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      } else {
                                        Get.to(() => TabunganAdd1());
                                      }
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
                            ],
                          )
                        : ListView.builder(
                            itemCount: targetTabungans!.length + 1,
                            itemBuilder: (context, index) {
                              return (index == targetTabungans!.length)
                                  ? SizedBox(
                                      height: 50,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: NeumorphicButton(
                                          onPressed: () async {
                                            if (targetTabungans!.length == 2) {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    backgroundColor: Color(0xFFFF98CE),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                    elevation: 16,
                                                    content: Container(
                                                      height: 250,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            "Target Tabungan yang kamu buat tidak boleh lebih dari 2",
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            } else {
                                              Get.to(() => TabunganAdd1());
                                            }
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
                                            showModalBottomSheet(
                                              context: context,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(25.0),
                                              ),
                                              builder: (context) {
                                                return Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 18.0),
                                                  height: MediaQuery.of(context).size.height / 2,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(25),
                                                      topRight: Radius.circular(25),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: <Widget>[
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                'Awal Mulai',
                                                                style: TextStyle(
                                                                  color: Colors.grey,
                                                                ),
                                                              ),
                                                              Text(
                                                                DateFormat.yMMMMd('en_US').format(DateTime.fromMillisecondsSinceEpoch(
                                                                    targetTabungans![index].timeCreated)),
                                                                style: TextStyle(
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                'Akhir Selesai',
                                                                style: TextStyle(
                                                                  color: Colors.grey,
                                                                ),
                                                              ),
                                                              Text(
                                                                DateFormat.yMMMMd('en_US').format(DateTime.fromMillisecondsSinceEpoch(
                                                                    targetTabungans![index].timeTarget)),
                                                                style: TextStyle(
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                'Target Tabungan',
                                                                style: TextStyle(
                                                                  color: Colors.grey,
                                                                ),
                                                              ),
                                                              Text(
                                                                "Rp.${(targetTabungans![index].amountTarget).toString()}",
                                                                style: TextStyle(
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                'Yang Sudah Ditabung',
                                                                style: TextStyle(
                                                                  color: Colors.grey,
                                                                ),
                                                              ),
                                                              Text(
                                                                "Rp.${(targetTabungans![index].amountSaved).toString()}",
                                                                style: TextStyle(
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width,
                                                        child: NeumorphicButton(
                                                          onPressed: () async {
                                                            await TargetTabungansServices.deleteTargetTabungan(
                                                                user.uid,
                                                                targetTabungans![index].amountTarget,
                                                                targetTabungans![index].timeCreated.toString());

                                                            Navigator.pop(context);
                                                            setState(() {
                                                              isLoaded = false;
                                                              _textcontrollerAMOUNT.text = "";
                                                              _textcontrollerITEM.text = "";
                                                            });
                                                          },
                                                          padding: EdgeInsets.symmetric(vertical: 18.0),
                                                          provideHapticFeedback: true,
                                                          style: NeumorphicStyle(
                                                            shape: NeumorphicShape.flat,
                                                            boxShape: NeumorphicBoxShape.roundRect(
                                                              BorderRadius.circular(18.0),
                                                            ),
                                                            depth: 1,
                                                            shadowDarkColor: Colors.black,
                                                            lightSource: LightSource.top,
                                                            color: Color(0xFFDD2A7B),
                                                          ),
                                                          child: Text(
                                                            'Hapus Target Tabungan',
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
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
                                                        "Rp.${(targetTabungans![index].amountTarget).toString()}",
                                                        style: const TextStyle(
                                                          fontSize: 20.0,
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
                                                      percent: targetTabungans![index].amountSaved / targetTabungans![index].amountTarget,
                                                      progressColor: Color(0xFF34C759),
                                                    ),
                                                    Text(
                                                      "${double.parse((targetTabungans![index].amountSaved / targetTabungans![index].amountTarget).toStringAsFixed(2)) * 100}% Telah Masuk",
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
                                                            "Rp.${(targetTabungans![index].amountTarget - targetTabungans![index].amountSaved).toString()}",
                                                            style: const TextStyle(
                                                              fontSize: 20.0,
                                                              color: Color(0xFF073B80),
                                                            ),
                                                          ),
                                                          (!DateTime.now().isBefore(
                                                                  DateTime.fromMillisecondsSinceEpoch(targetTabungans![index].timeTarget))
                                                              ? SizedBox()
                                                              : Align(
                                                                  alignment: Alignment.centerRight,
                                                                  child: NeumorphicButton(
                                                                    padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 4.0),
                                                                    onPressed: () async {
                                                                      _newTransaction(
                                                                          "Target Tabungan",
                                                                          targetTabungans![index].amountTarget,
                                                                          targetTabungans![index].amountSaved,
                                                                          targetTabungans![index].timeCreated);
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
                                                                )),
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
      ),
    );
  }
}
