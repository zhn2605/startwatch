import 'package:firebase_auth/firebase_auth.dart';
import 'package:startwatch/pages/services/auth_service.dart';
import 'package:startwatch/widgets/startwatch.dart';
import 'package:startwatch/pages/login.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().authStateChanges, 
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Startwatch();
        } else {
          return const Login();
        }
      },
    );
  }
}