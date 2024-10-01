import 'package:flutter/material.dart';
import 'package:natthawut_flutter_049/Page/AddProductPage.dart';
import 'package:natthawut_flutter_049/Page/EditProductPage.dart';
import 'package:natthawut_flutter_049/Page/home_admin.dart';

import 'package:natthawut_flutter_049/Page/home_screen.dart';
import 'package:natthawut_flutter_049/Page/login_screen.dart';
import 'package:natthawut_flutter_049/Page/register.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Login Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/home': (context) =>  const HomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterPage(),
          '/admin': (context) => const HomeAdmin(),
          '/add_product': (context) => AddProductPage(),
          '/edit_product': (context) => EditProductPage(),
        });
  }
}
