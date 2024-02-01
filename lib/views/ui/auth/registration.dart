import 'package:flutter/material.dart';
import 'package:online_shop/controllers/login_provider.dart';
import 'package:online_shop/models/auth/singup_model.dart';
import 'package:online_shop/views/shared/custom_textfield.dart';
import 'package:online_shop/views/shared/export.dart';
import 'package:online_shop/views/shared/export_packages.dart';
import 'package:online_shop/views/ui/auth/login.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationState();
}

class _RegistrationState extends State<RegistrationPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();

  bool validation = false;

  void formValidation() {
    if (email.text.isNotEmpty &&
        password.text.isNotEmpty &&
        username.text.isNotEmpty) {
      validation = true;
    } else {
      validation = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var authNotifier = Provider.of<LoginNotifier>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 50.h,
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
        ),
        decoration: const BoxDecoration(
            image: DecorationImage(
                opacity: 1.0, image: AssetImage('assets/images/bg.jpg'))),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            reusableText(
                text: "Hello!",
                style: appstyle(30, Colors.white, FontWeight.w600)),
            reusableText(
                text: "Fill in your details to sign up for an account",
                style: appstyle(14, Colors.white, FontWeight.normal)),
            SizedBox(
              height: 50.h,
            ),
            CustomTextField(
              keyboard: TextInputType.emailAddress,
              hintText: "Username",
              controller: username,
              validator: (username) {
                if (username!.isEmpty) {
                  return 'Please provide valid username';
                } else {
                  return null;
                }
              },
            ),
            SizedBox(
              height: 15.h,
            ),
            CustomTextField(
              keyboard: TextInputType.emailAddress,
              hintText: "Email",
              controller: email,
              validator: (email) {
                if (email!.isEmpty && !email.contains("@")) {
                  return 'Please provide valid email';
                } else {
                  return null;
                }
              },
            ),
            SizedBox(
              height: 15.h,
            ),
            CustomTextField(
              hintText: "Password",
              obscureText: authNotifier.isObsecure,
              controller: password,
              suffixIcon: GestureDetector(
                onTap: () {
                  authNotifier.isObsecure = !authNotifier.isObsecure;
                },
                child: authNotifier.isObsecure
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility),
              ),
              validator: (password) {
                if (password!.isEmpty && password.length < 7) {
                  return 'Password too weak';
                } else {
                  return null;
                }
              },
            ),
            SizedBox(
              height: 10.h,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                },
                child: reusableText(
                    text: "Login",
                    style: appstyle(14, Colors.white, FontWeight.normal)),
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            GestureDetector(
              onTap: () {
                formValidation();
                if (validation) {
                  SignupModel model = SignupModel(
                      username: username.text,
                      email: email.text,
                      password: password.text);
                  authNotifier.registerUser(model).then((response) {
                    if (response == true) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    } else {
                      debugPrint('Failed to Signup'); 
                    } 
                  });
                } else {
                  debugPrint('form not valid');
                }
              },
              child: Container(
                height: 55.h,
                width: 300,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Center(
                    child: reusableText(
                        text: "S I G N U P",
                        style: appstyle(18, Colors.black, FontWeight.bold))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
