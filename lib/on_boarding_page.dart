import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:wallet_q/sign_in.dart';
import 'package:wallet_q/sign_up.dart';
import 'package:wallet_q/wrapper.dart';

import 'on_boarding_content.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool masuk = false;
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {"title": "Mengatur Keuangan Secara Mandiri", "text": "Anda dapat dengan mudah mengatur keuangan", "image": "assets/images/1.png"},
    {
      "title": "Mengetahui Kemana Uang yang Digunakan",
      "text": "Uang yang anda gunakan dapat dicatat sehingga penggunaan uang menjadi lebih jelas",
      "image": "assets/images/2.png"
    },
    {
      "title": "Adanya Dream Saver",
      "text": "Dengan adanya dream saver anda dapat menabung untuk mendapatkan barang yang anda inginkan",
      "image": "assets/images/3.png"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              // GestureDetector(
              //   child: Container(
              //     alignment: Alignment.topRight,
              //     margin: EdgeInsets.only(top: 20, right: 20),
              //     child: Text(
              //       "Lewati",
              //       textAlign: TextAlign.end,
              //       style: TextStyle(
              //           fontFamily: "Baloo Da",
              //           color: Colors.purple,
              //           fontSize: 20,
              //           fontWeight: FontWeight.bold),
              //     ),
              //   ),
              //   onTap: () {
              //     Get.off(() => StartScreening());
              //   },
              // ),
              // const SizedBox(
              //   height: 50,
              // ),
              // Text(
              //   "nafs",
              //   style: TextStyle(fontSize: 36, color: Colors.purple, fontWeight: FontWeight.bold, fontFamily: "Baloo Da"),
              // ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: PageView.builder(
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: (value) {
                      setState(() {
                        currentPage = value;
                        if (value == 2) {
                          masuk = true;
                        }
                      });
                    },
                    itemCount: splashData.length,
                    itemBuilder: (context, index) => OnBoardingContent(
                      title: splashData[index]["title"],
                      text: splashData[index]['text'],
                      image: splashData[index]["image"],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          splashData.length,
                          (index) => buildDot(index: index),
                        ),
                      ),
                      const Spacer(flex: 1),
                      (masuk)
                          ? Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: 55,
                                  child: NeumorphicButton(
                                    onPressed: () {
                                      Get.to(() => const SignUp());
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
                                        "Daftar",
                                        textAlign: TextAlign.center,
                                        style:
                                            TextStyle(fontFamily: "Inter", color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 55,
                                  child: NeumorphicButton(
                                    onPressed: () {
                                      Get.to(() => const SignIn());
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
                                      color: const Color(0xFFEEE5FF),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Masuk",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "Inter", color: Color(0xFF7F3DFF), fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      // Spacer(),
                      // Container(
                      //   width: double.infinity,
                      //   height: (56 / 812.0) * MediaQuery.of(context).size.height,
                      //   child: NeumorphicButton(
                      //     onPressed: () {
                      //       Get.off(() => StartScreening());
                      //     },
                      //     provideHapticFeedback: true,
                      //     style: NeumorphicStyle(
                      //       shape: NeumorphicShape.concave,
                      //       boxShape: NeumorphicBoxShape.roundRect(
                      //         BorderRadius.circular(12),
                      //       ),
                      //       depth: 1,
                      //       lightSource: LightSource.right,
                      //       color: Colors.purple,
                      //     ),
                      //     child: Text(
                      //       "Lewati",
                      //       textAlign: TextAlign.center,
                      //       style: TextStyle(
                      //           fontFamily: "Baloo Da",
                      //           color: Colors.white,
                      //           fontSize: 20,
                      //           fontWeight: FontWeight.bold),
                      //     ),
                      //   ),
                      // ),
                      const Spacer(),
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

  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 7.5),
      height: currentPage == index ? 15 : 10,
      width: currentPage == index ? 15 : 10,
      decoration: BoxDecoration(
        color: currentPage == index ? const Color(0xFFFF98CE) : Colors.black,
        borderRadius: BorderRadius.circular(currentPage == index ? 10 : 5),
      ),
    );
  }
}
