import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:wallet_q/wrapper.dart';

import 'users.dart';
import 'auth_services.dart';
import 'on_boarding_page.dart';
import 'users_services.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController noTelpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passController = TextEditingController();

  Users? users;
  bool isLoaded = false, isPressed = false;
  File? profilePicture;
  String? picture = "https://drive.google.com/uc?export=view&id=1JTavNbUwwyVXVpaK5wAB8d7xN6WkKFm3";
  bool isFile = false;

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    if (!isLoaded) {
      UsersServices.readUser(user!.uid).then((value) {
        emailController.text = value.email;
        nameController.text = value.name;
        usernameController.text = value.username;
        noTelpController.text = value.phoneNumber;
        passwordController.text = "password";

        users = value;

        if (value.profilePicture != "") {
          picture = value.profilePicture;
        }

        isLoaded = true;

        setState(() {});
      });
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: ProfileWidget(
                    imagePath: picture!,
                    imageFile: profilePicture,
                    isFile: isFile,
                    onClicked: () {
                      getImage().then((value) {
                        setState(() {
                          profilePicture = value;
                          isFile = true;
                        });
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        child: Text(
                          "Nama",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        child: buildNamaFormField(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        child: Text(
                          "Username",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        child: buildUsernameFormField(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        child: Text(
                          "Email",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        child: buildEmailFormField(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        child: Text(
                          "No.Telepon",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        child: buildNoTelpFormField(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        child: Text(
                          "Password",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        child: buildPasswordFormField(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                (isPressed)
                    ? const SpinKitFadingCircle(
                        color: Color(0xFFFFC0CB),
                        size: 50,
                      )
                    : Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18.0),
                            width: double.infinity,
                            height: 55,
                            child: NeumorphicButton(
                              onPressed: () async {
                                if (!(emailController.text.trim() != "" &&
                                    nameController.text.trim() != "" &&
                                    noTelpController.text.trim() != "")) {
                                  Get.snackbar(
                                    "Pesan",
                                    "Silahkan Isi Seluruh Data Yang Diminta",
                                    snackPosition: SnackPosition.TOP,
                                    isDismissible: false,
                                    backgroundColor: Colors.white,
                                    duration: const Duration(seconds: 3),
                                    margin: const EdgeInsets.only(bottom: 0, left: 0, right: 0),
                                    colorText: Colors.black,
                                    borderRadius: 0,
                                  );
                                } else if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(noTelpController.text)) {
                                  Get.snackbar(
                                    "Pesan",
                                    "Format no telepon tidak sesuai",
                                    snackPosition: SnackPosition.TOP,
                                    isDismissible: false,
                                    backgroundColor: Colors.white,
                                    duration: const Duration(seconds: 3),
                                    margin: const EdgeInsets.only(bottom: 0, left: 0, right: 0),
                                    colorText: Colors.black,
                                    borderRadius: 0,
                                  );
                                } else if (profilePicture == null) {
                                  setState(() {
                                    isPressed = !isPressed;
                                  });
                                  String profileLink = "";
                                  await UsersServices.updateUser(user!.uid, user.email, nameController.text, usernameController.text,
                                      noTelpController.text, profileLink);
                                  setState(() {
                                    isLoaded = false;
                                    isPressed = !isPressed;
                                  });
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: Color(0xFF14FF00),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                        elevation: 16,
                                        content: Container(
                                          height: 250,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Lottie.asset("assets/lotties/check.json", height: 200),
                                              Text(
                                                "Data Berhasil DIganti",
                                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  setState(() {
                                    isPressed = !isPressed;
                                  });
                                  String profileLink = await uploadImage(profilePicture);
                                  await UsersServices.updateUser(user!.uid, user.email, nameController.text, usernameController.text,
                                      noTelpController.text, profileLink);
                                  setState(() {
                                    isLoaded = false;
                                    isPressed = !isPressed;
                                  });
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: Color(0xFF14FF00),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                        elevation: 16,
                                        content: Container(
                                          height: 250,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Lottie.asset("assets/lotties/check.json", height: 200),
                                              Text(
                                                "Data Berhasil DIganti",
                                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
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
                                  "Edit",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontFamily: "Inter", color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18.0),
                            width: double.infinity,
                            height: 55,
                            child: NeumorphicButton(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: Color(0xFFFFC0CB),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      elevation: 16,
                                      content: SizedBox(
                                        height: 250,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Silakan Masukkan Password Anda",
                                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                            passwordFormField(),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width: double.infinity,
                                              height: 55,
                                              child: NeumorphicButton(
                                                onPressed: () async {
                                                  SignInSignUpResult result =
                                                      await AuthServices.signInEmail(emailController.text, passController.text);
                                                  if (result.user == null) {
                                                    Get.snackbar(
                                                      "Perhatian",
                                                      result.message,
                                                      snackPosition: SnackPosition.TOP,
                                                      isDismissible: false,
                                                      backgroundColor: Color(0xFFEEE5FF),
                                                      duration: const Duration(seconds: 10),
                                                      margin: const EdgeInsets.only(bottom: 0, left: 0, right: 0, top: 0),
                                                      colorText: Colors.black,
                                                      borderRadius: 16,
                                                    );
                                                  } else {
                                                    if (picture !=
                                                        "https://drive.google.com/uc?export=view&id=1JTavNbUwwyVXVpaK5wAB8d7xN6WkKFm3") {
                                                      await deleteFileFromFirebaseByUrl(picture!);
                                                    }
                                                    await UsersServices.deleteUser(user!.uid, user.email, passController.text);
                                                    Get.offAll(() => Wrapper());
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
                                                  color: const Color(0xFFEEE5FF),
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    "Hapus Akun",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontFamily: "Inter",
                                                        color: Color(0xFF7F3DFF),
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
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
                                color: const Color(0xFFEEE5FF),
                              ),
                              child: const Center(
                                child: Text(
                                  "Hapus Akun",
                                  textAlign: TextAlign.center,
                                  style:
                                      TextStyle(fontFamily: "Inter", color: Color(0xFF7F3DFF), fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildNamaFormField() {
    return TextFormField(
      controller: nameController,
      cursorColor: Colors.black,
      style: const TextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: "Nama Lengkap",
        hintStyle: const TextStyle(color: Color(0xFF888888)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Colors.white)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Colors.white)),
        prefixIcon: const Padding(
          padding: EdgeInsets.all(14.0),
          child: Icon(
            Icons.person_outline,
            size: 20,
            color: Color(0xFF888888),
          ),
        ),
      ),
    );
  }

  TextFormField buildUsernameFormField() {
    return TextFormField(
      controller: usernameController,
      cursorColor: Colors.black,
      style: const TextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: "Username",
        hintStyle: const TextStyle(color: Color(0xFF888888)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Colors.white)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Colors.white)),
        prefixIcon: const Padding(
          padding: EdgeInsets.all(14.0),
          child: Icon(
            Icons.person_pin_outlined,
            size: 20,
            color: Color(0xFF888888),
          ),
        ),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      readOnly: true,
      cursorColor: Colors.black,
      style: const TextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: "Email",
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

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      readOnly: true,
      controller: passwordController,
      cursorColor: Colors.black,
      style: const TextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: "Kata Sandi",
        hintStyle: const TextStyle(color: Color(0xFF888888)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Colors.white)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Colors.white)),
        prefixIcon: const Padding(
          padding: EdgeInsets.all(14.0),
          child: Icon(
            Icons.lock,
            size: 20,
            color: Color(0xFF888888),
          ),
        ),
      ),
    );
  }

  TextFormField passwordFormField() {
    return TextFormField(
      obscureText: true,
      controller: passController,
      cursorColor: Colors.black,
      style: const TextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: "Kata Sandi",
        hintStyle: const TextStyle(color: Color(0xFF888888)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Colors.white)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Colors.white)),
        prefixIcon: const Padding(
          padding: EdgeInsets.all(14.0),
          child: Icon(
            Icons.lock,
            size: 20,
            color: Color(0xFF888888),
          ),
        ),
      ),
    );
  }

  TextFormField buildNoTelpFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: noTelpController,
      cursorColor: Colors.black,
      style: const TextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: "No.Telepon",
        hintStyle: const TextStyle(color: Color(0xFF888888)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Colors.white)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Colors.white)),
        prefixIcon: const Padding(
          padding: EdgeInsets.all(14.0),
          child: Icon(
            Icons.phone_outlined,
            size: 20,
            color: Color(0xFF888888),
          ),
        ),
      ),
    );
  }
}

Future<File?> getImage() async {
  try {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    return File(image!.path);
  } catch (e) {
    return null;
  }
}

//* Method to uploading image to firebase storage
Future<String> uploadImage(File? image) async {
  String fileName = basename(image!.path);

  Reference ref = FirebaseStorage.instance.ref().child(fileName);
  UploadTask task = ref.putFile(image);
  // TaskSnapshot snapshot = await task.onComplete;

  return await (await task).ref.getDownloadURL();
}

Future<void> deleteFileFromFirebaseByUrl(String urlFile) async {
  String fileName = urlFile.replaceAll("/o/", "*");
  fileName = fileName.replaceAll("?", "*");
  fileName = fileName.split("*")[1];

  Reference storageReferance = FirebaseStorage.instance.ref();
  storageReferance.child(fileName).delete();
}

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final File? imageFile;
  final bool isEdit;
  final bool isFile;
  final VoidCallback onClicked;

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    this.isEdit = false,
    this.imageFile,
    this.isFile = false,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: GestureDetector(
              onTap: onClicked,
              child: buildEditIcon(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    final image = NetworkImage(imagePath);

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: (isFile && imageFile != null)
            ? Ink.image(
                image: FileImage(imageFile!),
                fit: BoxFit.cover,
                width: 128,
                height: 128,
                child: InkWell(onTap: onClicked),
              )
            : Ink.image(
                image: image,
                fit: BoxFit.cover,
                width: 128,
                height: 128,
                child: InkWell(onTap: onClicked),
              ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: Icon(
            isEdit ? Icons.add_a_photo : Icons.edit,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
