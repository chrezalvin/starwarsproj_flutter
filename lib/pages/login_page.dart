import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Login"),
            
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, "/home"),
              child: const Text("Login"),
            ),
          ],
        ),
      )
    );
  }
}