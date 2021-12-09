import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:wallet_q/auth_services.dart';
import 'package:wallet_q/users_services.dart';
import 'package:wallet_q/wrapper.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 25,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Column(
                children: const [
                  Text(
                    "Masuk",
                    style: TextStyle(
                      fontFamily: "Inter",
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Selamat Datang Kembali",
                    style: TextStyle(
                      fontFamily: "Inter",
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              const SignInForm(),
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

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPressed = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          const SizedBox(height: 15),
          buildPasswordFormField(),
          const SizedBox(height: 200),
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
                      if (!(emailController.text.trim() != "" && passwordController.text.trim() != "")) {
                        Get.snackbar(
                          "Perhatian",
                          "Silakan isi seluruh data",
                          snackPosition: SnackPosition.TOP,
                          isDismissible: false,
                          backgroundColor: Color(0xFFEEE5FF),
                          duration: const Duration(seconds: 10),
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
                          duration: const Duration(seconds: 10),
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
                          duration: const Duration(seconds: 10),
                          margin: const EdgeInsets.only(bottom: 0, left: 0, right: 0, top: 0),
                          colorText: Colors.black,
                          borderRadius: 16,
                        );
                      } else {
                        setState(() {
                          isPressed = !isPressed;
                        });
                        SignInSignUpResult result = await AuthServices.signInEmail(emailController.text, passwordController.text);
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
                          setState(() {
                            isPressed = !isPressed;
                          });
                        } else {
                          Get.offAll(() => const Wrapper());
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
                        "Masuk",
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
}
