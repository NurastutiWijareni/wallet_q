import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class TargetTabungan extends StatefulWidget {
  const TargetTabungan({Key? key}) : super(key: key);

  @override
  _TargetTabunganState createState() => _TargetTabunganState();
}

class _TargetTabunganState extends State<TargetTabungan> {
  bool isLoaded = true;

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
                    ? ListView.builder(
                        // itemCount: dreamSavers!.length + 1,
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          // return (index == dreamSavers!.length)
                          return (index == 1)
                              ? SizedBox(
                                  height: 50,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: NeumorphicButton(
                                      onPressed: () async {
                                        // Get.to(() => DreamSaver());
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
                                      onPressed: () async {},
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
                                                    // dreamSavers![index].title,
                                                    "test",
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
                                                  // percent: dreamSavers![index].amountSaved / dreamSavers![index].amountTarget,
                                                  percent: 0.1,
                                                  progressColor: Color(0xFF34C759),
                                                ),
                                                Text(
                                                  // "${(dreamSavers![index].amountSaved / dreamSavers![index].amountTarget) * 100}% Telah Masuk",
                                                  "test",
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
                                                        // "Rp.${(dreamSavers![index].amountTarget - dreamSavers![index].amountSaved).toString()}",
                                                        "test",
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
                                                            // _newTransaction(dreamSavers![index].title, dreamSavers![index].amountTarget,
                                                            //     dreamSavers![index].timeCreated);
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
      ),
    );
  }
}
