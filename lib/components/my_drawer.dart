import 'package:flutter/material.dart';
import 'package:twitter/components/drawer_tile.dart';
import 'package:twitter/screens/profile_page.dart';
import 'package:twitter/screens/settings_page.dart';
import 'package:twitter/services/auth/auth_service.dart';
// ignore_for_file: prefer_const_constructors
/*
  1- Home
  2- Profile
  3- Search
  4- Settings
  5- Logout



*/

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});
  //acces the auth service
  final _auth = AuthService();

  void logout() async {
    try {
      _auth.logout();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            //Logo
            Padding(
              padding: EdgeInsets.symmetric(vertical: 50.0),
              child: Icon(
                Icons.person,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            //divder line
            Divider(
              indent: 25,
              endIndent: 25,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(
              height: 10,
            ),

            //Home listtile
            DrawerTile(
              onTap: () {
                Navigator.pop(context);
              },
              icon: Icons.home,
              text: 'H O M E',
            ),
            DrawerTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      uid: _auth.getCurrentUserUid(),
                    ),
                  ),
                );
              },
              icon: Icons.person,
              text: 'P R O F I L E',
            ),

            //Search
            DrawerTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsPage()));
              },
              icon: Icons.settings,
              text: 'S E T T I N G S',
            ),
            //Settings

            //Logouts
            DrawerTile(icon: Icons.logout, text: 'L O G O U T ', onTap: logout)
          ],
        ),
      ),
    );
  }
}
