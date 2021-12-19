import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:wallet_q/auth_services.dart';
import 'package:wallet_q/home.dart';
import 'package:wallet_q/users_services.dart';
import 'package:wallet_q/wrapper.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(30),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Daftar",
                    style: TextStyle(
                      fontFamily: "Inter",
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Spacer(),
                ],
              ),
              Image.asset(
                "assets/images/4.png",
                width: 150,
              ),
              const Text(
                "Daftar dan atur keuangan anda dengan mudah",
                style: TextStyle(
                  fontFamily: "Inter",
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SignUpForm(),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  bool isPressed = false;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildNamaFormField(),
          const SizedBox(height: 15),
          buildEmailFormField(),
          const SizedBox(height: 15),
          buildPasswordFormField(),
          const SizedBox(height: 15),
          buildRePasswordFormField(),
          const SizedBox(height: 50),
          (isPressed)
              ? const SpinKitFadingCircle(
                  color: Color(0xFFFF98CE),
                  size: 50,
                )
              : SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: NeumorphicButton(
                    onPressed: () async {
                      if (!(nameController.text.trim() != "" &&
                          emailController.text.trim() != "" &&
                          passwordController.text.trim() != "")) {
                        Get.snackbar(
                          "Perhatian",
                          "Silakan isi seluruh data",
                          snackPosition: SnackPosition.TOP,
                          isDismissible: false,
                          backgroundColor: Color(0xFFEEE5FF),
                          duration: const Duration(seconds: 3),
                          margin: const EdgeInsets.only(bottom: 0, left: 0, right: 0, top: 0),
                          colorText: Colors.black,
                          borderRadius: 16,
                        );
                      } else if (passwordController.text.length < 8) {
                        Get.snackbar(
                          "Perhatian",
                          "Panjang password minimal 8 karakter",
                          snackPosition: SnackPosition.TOP,
                          isDismissible: false,
                          backgroundColor: Color(0xFFEEE5FF),
                          duration: const Duration(seconds: 3),
                          margin: const EdgeInsets.only(bottom: 0, left: 0, right: 0, top: 0),
                          colorText: Colors.black,
                          borderRadius: 16,
                        );
                      } else if (passwordController.text != rePasswordController.text) {
                        Get.snackbar(
                          "Perhatian",
                          "Password yang anda masukkan tidak sesuai",
                          snackPosition: SnackPosition.TOP,
                          isDismissible: false,
                          backgroundColor: Color(0xFFEEE5FF),
                          duration: const Duration(seconds: 3),
                          margin: const EdgeInsets.only(bottom: 0, left: 0, right: 0, top: 0),
                          colorText: Colors.black,
                          borderRadius: 16,
                        );
                      } else if (!(EmailValidator.validate(emailController.text))) {
                        Get.snackbar(
                          "Perhatian",
                          "Silakan masukkan email anda",
                          snackPosition: SnackPosition.TOP,
                          isDismissible: false,
                          backgroundColor: Color(0xFFEEE5FF),
                          duration: const Duration(seconds: 3),
                          margin: const EdgeInsets.only(bottom: 0, left: 0, right: 0, top: 0),
                          colorText: Colors.black,
                          borderRadius: 16,
                        );
                      } else {
                        setState(() {
                          isPressed = !isPressed;
                        });
                        SignInSignUpResult result = await AuthServices.signUpEmail(emailController.text, passwordController.text);
                        if (result.user == null) {
                          Get.snackbar(
                            "Perhatian",
                            result.message,
                            snackPosition: SnackPosition.TOP,
                            isDismissible: false,
                            backgroundColor: Color(0xFFEEE5FF),
                            duration: const Duration(seconds: 3),
                            margin: const EdgeInsets.only(bottom: 0, left: 0, right: 0, top: 0),
                            colorText: Colors.black,
                            borderRadius: 16,
                          );
                          setState(() {
                            isPressed = !isPressed;
                          });
                        } else {
                          UsersServices.createUser(result.user!.uid, result.user!.email, nameController.text, "", "", "");
                          Get.offAll(() => const Home());
                        }
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
                        "Daftar",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: "Inter", color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
        ],
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

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
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

  TextFormField buildRePasswordFormField() {
    return TextFormField(
      obscureText: true,
      controller: rePasswordController,
      cursorColor: Colors.black,
      style: const TextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: "Konfirmasi Kata Sandi",
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
}
