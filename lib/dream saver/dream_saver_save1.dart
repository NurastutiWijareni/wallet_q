import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import 'dream_saver_save2.dart';

class DreamSaverSave1 extends StatefulWidget {
  const DreamSaverSave1({Key? key, required this.title, required this.price, required this.imageLink, required this.link})
      : super(key: key);
  final String title;
  final String price;
  final String imageLink;
  final String link;

  @override
  _DreamSaverSave1State createState() => _DreamSaverSave1State();
}

class _DreamSaverSave1State extends State<DreamSaverSave1> {
  @override
  Widget build(BuildContext context) {
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
                    Image.network(
                      widget.imageLink,
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
                            "Rencanakan mimpimu disini",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            widget.title,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          Text(
                            "Jumlah yang harus kamu tabung",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            widget.price,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.white,
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
                                  Get.to(
                                    () => DreamSaverSave2(
                                      title: widget.title,
                                      price: widget.price,
                                      imageLink: widget.imageLink,
                                      link: widget.link,
                                    ),
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
