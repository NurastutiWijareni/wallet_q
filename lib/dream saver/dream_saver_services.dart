import 'package:cloud_firestore/cloud_firestore.dart';
import 'dream_savers.dart';

class DreamSaversServices {
  static CollectionReference DreamSaversCollection = FirebaseFirestore.instance.collection("DreamSavers");

  static Future<void> createDreamSaver(
    String id,
    int amountTarget,
    int amountSaved,
    String title,
    String imageLink,
    String sourceLink,
    int timeTarget,
    int timeCreated,
  ) async {
    await DreamSaversCollection.doc(id + amountTarget.toString() + timeCreated.toString()).set(
      {
        "userID": id,
        "amountTarget": amountTarget,
        "amountSaved": amountSaved,
        "title": title,
        "imageLink": imageLink,
        "sourceLink": sourceLink,
        "timeTarget": timeTarget,
        "timeCreated": timeCreated,
      },
    );
  }

  static Future<List<DreamSavers>> readDreamSaver(userID) async {
    QuerySnapshot querySnapshot = await DreamSaversCollection.where("userID", isEqualTo: userID).get();

    List<DreamSavers> dreamSavers = [];
    for (var document in querySnapshot.docs) {
      dreamSavers.add(
        DreamSavers(
          document.get("userID"),
          document.get("amountTarget"),
          document.get("amountSaved"),
          document.get("title"),
          document.get("imageLink"),
          document.get("sourceLink"),
          document.get("timeTarget"),
          document.get("timeCreated"),
        ),
      );
    }

    return dreamSavers;
  }
}
