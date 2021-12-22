import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:wallet_q/dream%20saver/dream_saver_view.dart';
import 'package:wallet_q/notification_api.dart';
import 'package:wallet_q/profile.dart';
import 'package:wallet_q/reminder.dart';
import 'package:wallet_q/riwayat/riwayat.dart';
import 'package:wallet_q/target%20tabungan/target_tabungan.dart';
import 'dream saver/dream_saver.dart';
import 'tabungan/tabungan.dart';
import 'tabungan/tabungan_services.dart';
import 'users.dart';
import 'auth_services.dart';
import 'on_boarding_page.dart';
import 'users_services.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Users? users;
  List tabungans = [];
  int amount = 0;
  int income = 0;
  int expense = 0;
  bool _isIncome = false, isLoaded = false;

  @override
  void initState() {
    super.initState();

    NotificationApi.init(initScheduled: true);
    listenNotifications();
  }

  void listenNotifications() => NotificationApi.onNotifications.stream.listen(onClickNotification);

  void onClickNotification(String? payload) => Get.to(() => Home());

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

    if (!isLoaded) {
      TabungansServices.readTabungan(user.uid).then((value) {
        tabungans = value;
        amount = 0;
        income = 0;
        expense = 0;

        tabungans.forEach((element) {
          if (element.category == "Pemasukan") {
            income += element.amount as int;
            amount += element.amount as int;
          } else {
            expense += element.amount as int;
            amount -= element.amount as int;
          }
        });
        isLoaded = true;

        setState(() {});
      });
    }

    AppBar appBar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      actions: [
        FutureBuilder(
          future: UsersServices.readUser(user.uid),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                Users data = snapshot.data as Users;
                return Padding(
                  padding: const EdgeInsets.only(right: 18.0, top: 12.0),
                  child: Text(
                    "Halo, \n" + data.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: "Inter",
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            } else {
              return const SizedBox();
            }
          },
        ),
      ],
    );

    return SafeArea(
      child: Container(
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
        child: Scaffold(
          drawerEnableOpenDragGesture: false,
          backgroundColor: Colors.transparent,
          drawer: Drawer(
            child: SingleChildScrollView(
              child: Container(
                color: const Color(0xFFFFDDE3),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              FutureBuilder(
                                future: UsersServices.readUser(user.uid),
                                builder: (_, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.done) {
                                    if (snapshot.hasData) {
                                      Users data = snapshot.data as Users;
                                      return Padding(
                                        padding: const EdgeInsets.all(24.0),
                                        child: (data.profilePicture == "")
                                            ? Row(
                                                children: [
                                                  Image.asset(
                                                    "assets/images/5.png",
                                                    width: 50,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Image.asset(
                                                    (data.points < 100)
                                                        ? "assets/images/6.png"
                                                        : (data.points < 250)
                                                            ? "assets/images/18.png"
                                                            : "assets/images/19.png",
                                                    width: 35,
                                                  ),
                                                  Text(
                                                    (data.points < 100)
                                                        ? "(Ambisius)"
                                                        : (data.points < 250)
                                                            ? "(Profesional)"
                                                            : "(Expert)",
                                                    textAlign: TextAlign.left,
                                                    style: const TextStyle(
                                                      fontFamily: "Inter",
                                                      color: Color(0xFFFF98CE),
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 25,
                                                    backgroundImage: NetworkImage(data.profilePicture),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Image.asset(
                                                    (data.points < 100)
                                                        ? "assets/images/6.png"
                                                        : (data.points < 250)
                                                            ? "assets/images/18.png"
                                                            : "assets/images/19.png",
                                                    width: 35,
                                                  ),
                                                  Text(
                                                    (data.points < 100)
                                                        ? "(Ambisius)"
                                                        : (data.points < 250)
                                                            ? "(Profesional)"
                                                            : "(Expert)",
                                                    textAlign: TextAlign.left,
                                                    style: const TextStyle(
                                                      fontFamily: "Inter",
                                                      color: Color(0xFFFF98CE),
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                            ],
                          ),
                          FutureBuilder(
                            future: UsersServices.readUser(user.uid),
                            builder: (_, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                if (snapshot.hasData) {
                                  Users data = snapshot.data as Users;
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 30.0),
                                    child: Text(
                                      data.name,
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontFamily: "Inter",
                                        color: Color(0xFFC26969),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 4 / 5 - 24,
                      padding: const EdgeInsets.all(24.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: ElevatedButton(
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/images/7.png",
                                    width: 60,
                                  ),
                                  const SizedBox(
                                    width: 18.0,
                                  ),
                                  const Text(
                                    "Profil",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: "Inter",
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () async {
                                Get.to(() => Profile());
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  textStyle: const TextStyle(color: Colors.white, fontSize: 16)),
                            ),
                          ),
                          // Divider(
                          //   height: 1,
                          //   color: Colors.black,
                          // ),
                          // ClipRRect(
                          //   borderRadius: BorderRadius.circular(5),
                          //   child: ElevatedButton(
                          //     child: Row(
                          //       // mainAxisAlignment: MainAxisAlignment.start,
                          //       children: [
                          //         Image.asset(
                          //           "assets/images/8.png",
                          //           width: 60,
                          //         ),
                          //         const SizedBox(
                          //           width: 18.0,
                          //         ),
                          //         const Text(
                          //           "Reminder",
                          //           textAlign: TextAlign.left,
                          //           style: TextStyle(
                          //             fontFamily: "Inter",
                          //             color: Colors.black,
                          //             fontSize: 16,
                          //             fontWeight: FontWeight.w600,
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //     onPressed: () async {},
                          //     style: ElevatedButton.styleFrom(
                          //         primary: Colors.white,
                          //         padding: const EdgeInsets.symmetric(vertical: 15),
                          //         textStyle: const TextStyle(color: Colors.white, fontSize: 16)),
                          //   ),
                          // ),
                          // Divider(
                          //   height: 1,
                          //   color: Colors.black,
                          // ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: ElevatedButton(
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/images/20.png",
                                    width: 60,
                                  ),
                                  const SizedBox(
                                    width: 18.0,
                                  ),
                                  const Text(
                                    "Tentang",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: "Inter",
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: Color(0xFFFFC0CB),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      elevation: 16,
                                      content: SizedBox(
                                        height: 250,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "Developed by TeamTam\n\nNurastuti Wijareni\nLaode Ghazy Naufal Iksyam\nRio Yuda Sakti\nMuchammad Okto Nugroho\nRusydi Nurdin",
                                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  textStyle: const TextStyle(color: Colors.white, fontSize: 16)),
                            ),
                          ),
                          // Divider(
                          //   height: 1,
                          //   color: Colors.black,
                          // ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: ElevatedButton(
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/images/10.png",
                                    width: 60,
                                  ),
                                  const SizedBox(
                                    width: 18.0,
                                  ),
                                  const Text(
                                    "Keluar Akun",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: "Inter",
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () async {
                                AuthServices.signOut();
                                Get.offAll(() => OnBoarding());
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  textStyle: const TextStyle(color: Colors.white, fontSize: 16)),
                            ),
                          ),
                          // Divider(
                          //   height: 1,
                          //   color: Colors.black,
                          // ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: ElevatedButton(
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/images/21.png",
                                    width: 60,
                                  ),
                                  const SizedBox(
                                    width: 18.0,
                                  ),
                                  const Text(
                                    "Test Target Notifikasi",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: "Inter",
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () async {
                                NotificationApi.showNotification(
                                  title: "Target Tabungan Kangen Kamu Nih",
                                  body: 'Ayo ${users!.name}, capai target-mu sekarang!',
                                  payload: 'target.tabungan',
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  textStyle: const TextStyle(color: Colors.white, fontSize: 16)),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: ElevatedButton(
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/images/21.png",
                                    width: 60,
                                  ),
                                  const SizedBox(
                                    width: 18.0,
                                  ),
                                  const Text(
                                    "Test Dream Saver Notifikasi",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: "Inter",
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () async {
                                NotificationApi.showNotification(
                                  title: "Katanya Dimimpiin, Kok Dianggurin",
                                  body: 'Ayo ${users!.name}, capai mimpi-mu sekarang!',
                                  payload: 'target.tabungan',
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  textStyle: const TextStyle(color: Colors.white, fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          appBar: appBar,
          body: Column(
            children: [
              SizedBox(
                height: 25,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 10,
                width: double.infinity,
                child: Stack(
                  children: [
                    // Lottie.asset("assets/lotties/1.json", height: 75),
                    Center(
                      child: Text(
                        "Saldo Yang Dimiliki\n Rp. ${(amount < 0) ? 0 : amount.toString()}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Inter",
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 9 / 12 - appBar.preferredSize.height - 49,
                padding: const EdgeInsets.all(28.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MenuButton(
                          lottie: "assets/lotties/1.json",
                          text: "Dream Saver",
                          toPage: "Dream Saver",
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        MenuButton(
                          lottie: "assets/lotties/3.json",
                          text: "Riwayat",
                          toPage: "Riwayat",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      children: [
                        MenuButton(
                          lottie: "assets/lotties/tabungan.json",
                          text: "Tabungan",
                          toPage: "Tabungan",
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        MenuButton(
                          lottie: "assets/lotties/target tabungan.json",
                          text: "Target Tabungan",
                          toPage: "Target Tabungan",
                        ),
                      ],
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

class MenuButton extends StatelessWidget {
  const MenuButton({Key? key, this.lottie, this.text, this.toPage}) : super(key: key);

  final String? lottie;
  // final String? image;
  final String? text;
  final String? toPage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 56,
      height: MediaQuery.of(context).size.height / 4,
      child: NeumorphicButton(
        onPressed: () async {
          if (toPage == "Target Tabungan") {
            Get.to(() => TargetTabungan());
          } else if (toPage == "Dream Saver") {
            Get.to(() => DreamSaverView());
          } else if (toPage == "Reminder") {
            NotificationApi.showNotification(title: "test", body: "testttt", payload: 'test.test');
          } else if (toPage == "Tabungan") {
            Get.to(() => Tabungan());
          } else if (toPage == "Riwayat") {
            Get.to(() => Riwayat());
          }
        },
        provideHapticFeedback: true,
        style: NeumorphicStyle(
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(5),
          ),
          depth: 5,
          shadowDarkColor: Color(0xFFFF98CE),
          lightSource: LightSource.topLeft,
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(
            //   image!,
            // ),
            Lottie.asset(
              lottie!,
            ),
            Text(
              text!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: "Inter",
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
