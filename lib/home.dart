import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wallet_q/profile.dart';

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
                                                    "assets/images/6.png",
                                                    width: 35,
                                                  )
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
                                                    "assets/images/6.png",
                                                    width: 35,
                                                  )
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
                          Divider(
                            height: 1,
                            color: Colors.black,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: ElevatedButton(
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/images/8.png",
                                    width: 60,
                                  ),
                                  const SizedBox(
                                    width: 18.0,
                                  ),
                                  const Text(
                                    "Tabungan",
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
                              onPressed: () async {},
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  textStyle: const TextStyle(color: Colors.white, fontSize: 16)),
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: Colors.black,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: ElevatedButton(
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/images/9.png",
                                    width: 60,
                                  ),
                                  const SizedBox(
                                    width: 18.0,
                                  ),
                                  const Text(
                                    "Pengaturan",
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
                              onPressed: () async {},
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  textStyle: const TextStyle(color: Colors.white, fontSize: 16)),
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: Colors.black,
                          ),
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
                          Divider(
                            height: 1,
                            color: Colors.black,
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 25,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 10,
                  child: const Text(
                    "Saldo Yang Dimiliki\nRp. x.xxx.xxx",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Inter",
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 9 / 10 - appBar.preferredSize.height - 49,
                  padding: const EdgeInsets.all(28.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MenuButton(
                            image: "assets/images/11.png",
                            text: "Dream Saver",
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          MenuButton(
                            image: "assets/images/12.png",
                            text: "Reminder",
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      MenuButton(
                        image: "assets/images/13.png",
                        text: "Tabungan",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({Key? key, this.image, this.text}) : super(key: key);

  final String? image;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 56,
      height: MediaQuery.of(context).size.height / 4,
      child: NeumorphicButton(
        onPressed: () async {},
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
            Image.asset(
              image!,
            ),
            Text(
              text!,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontFamily: "Inter",
                fontSize: 16,
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
