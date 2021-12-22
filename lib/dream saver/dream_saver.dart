import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallet_q/dream%20saver/dream_saver_services.dart';
import 'package:wallet_q/dream%20saver/dream_savers.dart';
import 'package:wallet_q/users_services.dart';
import 'package:web_scraper/web_scraper.dart';

import 'dream_saver_result.dart';

class DreamSaver extends StatefulWidget {
  @override
  _DreamSaverState createState() => _DreamSaverState();
}

class _DreamSaverState extends State<DreamSaver> {
  TextEditingController searchController = TextEditingController();
  List<DreamSavers>? dreamSavers;
  bool isLoaded = false, hasDreamSaver = false;

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
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * (1 / 7),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Center(
                          child: Lottie.asset(
                            "assets/lotties/link.json",
                            width: MediaQuery.of(context).size.width / 2,
                          ),
                        ),
                      ),
                      Text(
                        "Copy paste link barang yang kamu butuhkan",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          fontFamily: "Inter",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 18.0),
                        child: buildSearchFormField(),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 4,
                        height: 55,
                        child: NeumorphicButton(
                          onPressed: () async {
                            if (!(searchController.text.trim() != "")) {
                              Get.snackbar(
                                "Perhatian",
                                "Silakan isi link terlebih dahulu",
                                snackPosition: SnackPosition.BOTTOM,
                                isDismissible: false,
                                backgroundColor: Color(0xFFFF98CE),
                                duration: const Duration(seconds: 3),
                                margin: const EdgeInsets.only(bottom: 0, left: 0, right: 0, top: 0),
                                colorText: Colors.white,
                                borderRadius: 16,
                              );
                            } else if (!Uri.parse(searchController.text).isAbsolute) {
                              Get.snackbar(
                                "Perhatian",
                                "Silakan isi link yang valid",
                                snackPosition: SnackPosition.TOP,
                                isDismissible: false,
                                backgroundColor: Color(0xFFFF98CE),
                                duration: const Duration(seconds: 3),
                                margin: const EdgeInsets.only(bottom: 0, left: 0, right: 0, top: 0),
                                colorText: Colors.white,
                                borderRadius: 16,
                              );
                            } else if (searchController.text.substring(0, 25) != "https://www.tokopedia.com") {
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
                                            "Silahkan masukkan link tokopedia yang valid:",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              String url =
                                                  "https://www.tokopedia.com/belajar-php/buku-belajar-pemrograman-kotlin-android-bahasa-indonesia-goodie-bag?whid=0";
                                              if (await canLaunch(url)) {
                                                await launch(url);
                                              } else {
                                                // can't launch url
                                              }
                                            },
                                            child: Text(
                                              "https://www.tokopedia.com/belajar-php/buku-belajar-pemrograman-kotlin-android-bahasa-indonesia-goodie-bag?whid=0",
                                              style: TextStyle(
                                                color: Colors.blue.shade400,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                decoration: TextDecoration.underline,
                                                decorationColor: Colors.blue,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              for (int i = 0; i < dreamSavers!.length; i++) {
                                if (dreamSavers![i].sourceLink == searchController.text) {
                                  hasDreamSaver = true;
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
                                                "Barang yang kamu masukkan sudah ada",
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
                                  break;
                                } else {
                                  hasDreamSaver = false;
                                }
                              }
                              if (!hasDreamSaver) {
                                Get.to(() => DreamSaverResult(link: searchController.text));
                              }
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
                            color: const Color(0xFFFF98CE),
                          ),
                          child: const Center(
                            child: Text(
                              "Cari",
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 18.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/images/16.png",
                              width: 100,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width - 152,
                                    child: Text(
                                      "Copy link produk",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        fontFamily: "Inter",
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width - 152,
                                    child: Text(
                                      "Masuk ke Tokopedia. Pilih barang yang diinginkan dan copy link-nya.",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontFamily: "Inter",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 18.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/images/17.png",
                              width: 100,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width - 152,
                                    child: Text(
                                      "Paste Link-nya",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        fontFamily: "Inter",
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width - 152,
                                    child: Text(
                                      "Paste link barang pilihan kamu dan klik tombol cari.",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontFamily: "Inter",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildSearchFormField() {
    return TextFormField(
      keyboardType: TextInputType.url,
      controller: searchController,
      cursorColor: Colors.black,
      style: const TextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: "https://",
        hintStyle: const TextStyle(color: Color(0xFF888888)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Colors.white)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Colors.white)),
        prefixIcon: const Padding(
          padding: EdgeInsets.all(14.0),
          child: Icon(
            Icons.mail_outline,
            size: 20,
            color: Color(0xFF888888),
          ),
        ),
      ),
    );
  }
}
