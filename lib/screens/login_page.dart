import 'dart:async';

import 'package:flutter/material.dart';
import 'package:twitter/components/input_textfield.dart';
import 'package:twitter/components/my_button.dart';
import 'package:twitter/services/auth/auth_service.dart';

/*
      1- logo
      2- email input
      3- password input
      4- login button
      5- register button


*/

class LoginPage extends StatefulWidget {
  final void Function() onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() async {
    try {
      await _auth.loginEmailPassword(
          emailController.text, passwordController.text);
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Column(
            children: [
              AlertDialog(
                content: Text("Hatalı email veya şifre"),
              ),
            ],
          );
        },
      );
      Timer(Duration(seconds: 3), () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          foregroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 50),
                Icon(
                  Icons.lock_open_rounded,
                  size: 100,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(height: 50),
                Text(
                  "Tekrar hoşgeldin, Özlendin",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                SizedBox(height: 50),
                //email textfield
                InputTextfield(
                  controller: emailController,
                  icon: Icons.person,
                  isHint: false,
                  text: 'Email',
                ),
                SizedBox(height: 20),
                //password textfield
                InputTextfield(
                  controller: passwordController,
                  icon: Icons.lock_clock_rounded,
                  isHint: true,
                  text: 'Şifre',
                ),
                //forgot password
                Padding(
                  padding: EdgeInsets.only(
                    right: 5,
                  ),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Şifremi unuttum",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary),
                          ))),
                ),
                //login button
                MyButton(
                  text: 'Giriş Yap',
                  onTap: login,
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Üye değil misin?",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        " Üye ol",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
