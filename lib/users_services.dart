import 'package:cloud_firestore/cloud_firestore.dart';
import 'users.dart';
import 'auth_services.dart';

class UsersServices {
  static CollectionReference usersCollection = FirebaseFirestore.instance.collection("users");

  static Future<void> createUser(id, email, name, username, phoneNumber, profilePicture) async {
    await usersCollection.doc(id).set({
      "userID": id,
      "email": email,
      "name": name,
      "username": username,
      "phoneNumber": phoneNumber,
      "profilePicture": profilePicture,
    });
  }

  static Future<dynamic> readUser(userID) async {
    QuerySnapshot querySnapshot = await usersCollection.where("userID", isEqualTo: userID).get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    }
    return Users(
      userID,
      querySnapshot.docs[0].get("email"),
      name: querySnapshot.docs[0].get('name'),
      username: querySnapshot.docs[0].get('username'),
      phoneNumber: querySnapshot.docs[0].get('phoneNumber'),
      profilePicture: querySnapshot.docs[0].get('profilePicture'),
    );
  }

  static Future<void> updateUser(id, email, name, username, phoneNumber, profilePicture) async {
    await usersCollection.doc(id).update({
      "userID": id,
      "email": email,
      "name": name,
      "username": username,
      "phoneNumber": phoneNumber,
      "profilePicture": profilePicture,
    });
  }

  static Future<void> deleteUser(id, email, password) async {
    await AuthServices.delete(email, password);
    await usersCollection.doc(id).delete();
  }
}
