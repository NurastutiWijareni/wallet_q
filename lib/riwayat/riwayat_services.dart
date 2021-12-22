import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wallet_q/riwayat/riwayats.dart';
import 'package:wallet_q/riwayat/riwayats.dart';

class RiwayatsServices {
  static CollectionReference RiwayatsCollection = FirebaseFirestore.instance.collection("riwayats");

  static Future<void> createRiwayat(
    String id,
    int amountTarget,
    String title,
    String category,
    int timeReached,
  ) async {
    await RiwayatsCollection.doc(id + amountTarget.toString() + timeReached.toString()).set(
      {
        "userID": id,
        "amountTarget": amountTarget,
        "title": title,
        "category": category,
        "timeReached": timeReached,
      },
    );
  }

  static Future<List<Riwayats>> readRiwayat(userID) async {
    QuerySnapshot querySnapshot = await RiwayatsCollection.where("userID", isEqualTo: userID).get();

    List<Riwayats> riwayats = [];
    for (var document in querySnapshot.docs) {
      riwayats.add(
        Riwayats(
          document.get("userID"),
          document.get("amountTarget"),
          document.get("title"),
          document.get("category"),
          document.get("timeReached"),
        ),
      );
    }

    return riwayats;
  }
}
