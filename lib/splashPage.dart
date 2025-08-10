import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taxi_app/enterPhoneNumber.dart';
import 'package:taxi_app/tdlib/tdlib.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2)).then((onValue) => chekEvent());
    // _navigateToHomeScreen();
  }

  void _navigateToHomeScreen() {
    Timer(const Duration(seconds: 3), () {
      // 3 soniyadan so'ng
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const EnterPhoneNumberPage(), // HomePage ga o'tish
        ),
      );
    });
  }

  Future<void> chekEvent() async {
    await TelegramClient().initialize(context);
  }

  @override
  Widget build(BuildContext context) {
    // HomePage dagi AppBar rangiga o'xshash yoki mos keladigan fon
    // Yoki Theme.of(context).scaffoldBackgroundColor ni ishlatishingiz mumkin
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color backgroundColor =
        Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[900]! // Qorong'u rejim uchun
        : Colors.white; // Ochiq rejim uchun

    return Scaffold(
      backgroundColor: backgroundColor, // Fon rangini o'rnatish
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Taxi ilovasi uchun mos ikona
            Icon(
              Icons.local_taxi_rounded, // Yoki o'zingizning logotipingiz
              size: 120.0,
              color: primaryColor, // Asosiy rangni ishlatish
            ),
            const SizedBox(height: 24.0),
            Text(
              'Xush Kelibsiz!', // Yoki ilovangiz nomi
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              'Sizning ishonchli taksi xizmatingiz', // Ilovangiz shiori
              style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40.0),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
