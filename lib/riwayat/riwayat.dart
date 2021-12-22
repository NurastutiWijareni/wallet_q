import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wallet_q/riwayat/riwayat_services.dart';
import 'package:wallet_q/riwayat/riwayats.dart';
import 'package:wallet_q/users_services.dart';

class Riwayat extends StatefulWidget {
  const Riwayat({Key? key}) : super(key: key);

  @override
  _RiwayatState createState() => _RiwayatState();
}

class _RiwayatState extends State<Riwayat> {
  List<Riwayats>? riwayats;
  bool isLoaded = false;
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    if (!isLoaded) {
      UsersServices.readUser(user.uid).then(
        (value) {
          try {
            RiwayatsServices.readRiwayat(user.uid).then(
              (value) {
                setState(
                  () {
                    riwayats = value;
                    isLoaded = true;
                  },
                );
              },
            );
          } catch (e) {}
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
                      "Riwayat",
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
                        itemCount: riwayats!.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: MediaQuery.of(context).size.height / 24,
                                ),
                                padding: EdgeInsets.only(
                                  left: 18.0,
                                  right: 18.0,
                                  top: MediaQuery.of(context).size.height / 24,
                                ),
                                height: MediaQuery.of(context).size.height / 5,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                // padding: EdgeInsets.all(10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Menyelesaikan ${(riwayats![index].category == 'Dream Saver') ? 'Dream Saver' : 'Target'}",
                                      style: TextStyle(
                                        color: Color(0xFFC26969),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${(riwayats![index].category == 'Dream Saver') ? 'Harga Barang' : 'Target'}",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          "Rp.${riwayats![index].amountTarget}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: 10,
                                  top: 10,
                                  right: 10,
                                ),
                                padding: EdgeInsets.only(left: 28.0),
                                height: MediaQuery.of(context).size.height / 12,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(color: Color(0xFFFF98CE), width: 4),
                                  color: Color(0xFFFFC0CB),
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    DateFormat.yMMMd("en_US").format(DateTime.fromMillisecondsSinceEpoch(riwayats![index].timeReached)),
                                    style: TextStyle(
                                      color: Color(0xFFC26969),
                                      fontSize: 26,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        })
                    : SpinKitFadingCircle(
                        color: Colors.white,
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
