import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wallet_q/target%20tabungan/target_tabungans.dart';

class TargetTabungansServices {
  static CollectionReference TargetTabungansCollection = FirebaseFirestore.instance.collection("targetTabungans");

  static Future<void> createTargetTabungan(
    String id,
    int amountTarget,
    int amountSaved,
    int timeTarget,
    int timeCreated,
  ) async {
    await TargetTabungansCollection.doc(id + amountTarget.toString() + timeCreated.toString()).set(
      {
        "userID": id,
        "amountTarget": amountTarget,
        "amountSaved": amountSaved,
        "timeTarget": timeTarget,
        "timeCreated": timeCreated,
      },
    );
  }

  static Future<List<TargetTabungans>> readTargetTabungan(userID) async {
    QuerySnapshot querySnapshot = await TargetTabungansCollection.where("userID", isEqualTo: userID).get();

    List<TargetTabungans> targetTabungans = [];
    for (var document in querySnapshot.docs) {
      targetTabungans.add(
        TargetTabungans(
          document.get("userID"),
          document.get("amountTarget"),
          document.get("amountSaved"),
          document.get("timeTarget"),
          document.get("timeCreated"),
        ),
      );
    }

    return targetTabungans;
  }

  static Future<void> deleteTargetTabungan(String id, int amountTarget, String timeCreated) async {
    await TargetTabungansCollection.doc(id + amountTarget.toString() + timeCreated).delete();
  }
}
