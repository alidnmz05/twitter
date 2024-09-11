import 'package:flutter/material.dart';
import 'package:twitter/components/input_textfield.dart';
import 'package:twitter/components/my_button.dart';
import 'package:twitter/services/auth/auth_service.dart';
import 'package:twitter/services/database/database_service.dart';

class RegisterPage extends StatefulWidget {
  final void Function() onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _auth = AuthService();
  final _db = DatabaseService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cPasswordController = TextEditingController();

  void register() async {
    if (passwordController.text == cPasswordController.text) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Yükleme İşlemi"),
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Yükleme İşlemi Bekleniyor"),
              ],
            ),
          );
        },
      );
      try {
        await _auth.registerEmailPassword(
            emailController.text, passwordController.text, nameController.text);

        if (mounted) {
          Navigator.of(context).pop(context);
        }
        await _db.saveUserInfoInFirebase(
            name: nameController.text, email: emailController.text);
      } catch (e) {
        if (mounted) {
          Navigator.of(context).pop(context);
          print(e.toString());
        }
      }
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Text("Şifreler Eşleşmiyor"),
              ));
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
                  "Hadi, bir hesap oluşturalım.",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                SizedBox(height: 50),
                InputTextfield(
                  controller: nameController,
                  icon: Icons.abc,
                  isHint: false,
                  text: 'Kullanıcı adı',
                ),

                SizedBox(height: 13),
                InputTextfield(
                  controller: emailController,
                  icon: Icons.person,
                  isHint: false,
                  text: 'Email',
                ),
                SizedBox(height: 13),
                InputTextfield(
                  controller: passwordController,
                  icon: Icons.lock,
                  isHint: true,
                  text: 'Şifre',
                ),

                SizedBox(height: 13),
                InputTextfield(
                  controller: cPasswordController,
                  icon: Icons.lock_clock_rounded,
                  isHint: true,
                  text: 'Şifreyi onayla',
                ),
                SizedBox(height: 20),
                //login button
                MyButton(
                  text: 'Kayıt Ol',
                  onTap: register,
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Zaten üye misin?",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        " Giriş yap",
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
