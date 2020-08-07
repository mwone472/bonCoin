import 'package:bonCoinSN/modals/user.dart';
import 'package:bonCoinSN/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.ac_unit), onPressed: () => print(user.email)),
          ],
        ),
      ),
    );
  }
}
