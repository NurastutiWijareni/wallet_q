import 'package:cloud_firestore/cloud_firestore.dart';
import 'tabungans.dart';

class TabungansServices {
  static CollectionReference TabungansCollection = FirebaseFirestore.instance.collection("tabungans");

  static Future<void> createTabungan(String id, int amount, String description, String category) async {
    await TabungansCollection.doc(id + amount.toString() + description + category).set({
      "userID": id,
      "amount": amount,
      "description": description,
      "category": category,
      "time": DateTime.now().millisecondsSinceEpoch,
    });
  }

  static Future<List<Tabungans>> readTabungan(userID) async {
    QuerySnapshot querySnapshot = await TabungansCollection.where("userID", isEqualTo: userID).get();

    List<Tabungans> tabungans = [];
    for (var document in querySnapshot.docs) {
      tabungans.add(Tabungans(
        document.get("userID"),
        document.get("amount"),
        document.get("description"),
        document.get("category"),
        DateTime.fromMillisecondsSinceEpoch(document.get("time")),
      ));
    }

    return tabungans;
  }

  static Future<void> deleteTabungan(String id, int amount, String description, String category) async {
    await TabungansCollection.doc(id + amount.toString() + description + category).delete();
  }
}
