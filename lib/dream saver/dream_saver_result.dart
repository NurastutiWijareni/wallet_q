import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:web_scraper/web_scraper.dart';
import 'dream_saver_save1.dart';

class DreamSaverResult extends StatefulWidget {
  const DreamSaverResult({Key? key, required this.link}) : super(key: key);

  final String link;

  @override
  _DreamSaverResultState createState() => _DreamSaverResultState();
}

class _DreamSaverResultState extends State<DreamSaverResult> {
  final webScraper = WebScraper('https://tokopedia.com');

  List<Map<String, dynamic>>? productImages;
  List<Map<String, dynamic>>? productPrices;
  List<Map<String, dynamic>>? productTitles;

  String title = "", imageLink = "", price = "";

  void fetchProducts() async {
    try {
      if (await webScraper.loadWebPage(widget.link.substring(25, widget.link.length))) {
        setState(() {
          productImages = webScraper.getElement(
              'div.css-856ghu > div.css-4xe7jo > div.css-6jnsk6 > div.css-1nchjne > div.css-1q3zvcj > div.css-cbnyzd > div.css-1y5a13 > img',
              ['src']);
          imageLink = productImages![0]['attributes']['src'];

          productPrices = webScraper
              .getElement('div.css-856ghu > div.css-4xe7jo > div.css-1fogemr > div.css-jmbq56 > div.css-aqsd8m > div.price', ['class']);
          price = productPrices![0]['title'];

          productTitles =
              webScraper.getElement('div.css-856ghu > div.css-4xe7jo > div.css-1fogemr > div.css-jmbq56 > h1.css-1wtrxts', ['class']);
          title = productTitles![0]['title'];
        });
      }
    } catch (e) {
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
                    "Barang yang anda cari tidak ada, pastikan link tokopedia yang anda masukkan valid",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 18.0),
                  child: (productImages == null || productPrices == null || productTitles == null)
                      ? Center(
                          child: Lottie.asset(
                            "assets/lotties/search.json",
                            width: MediaQuery.of(context).size.width / 1.5,
                          ),
                        )
                      : SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          child: NeumorphicButton(
                            onPressed: () async {
                              Get.to(
                                () => DreamSaverSave1(
                                  title: title,
                                  price: price,
                                  imageLink: imageLink,
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
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    imageLink,
                                    width: 150,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width - 234,
                                        child: Text(
                                          title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width - 234,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              price,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "*Harga saat ini",
                                              style: const TextStyle(
                                                fontSize: 10.0,
                                              ),
                                            ),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
