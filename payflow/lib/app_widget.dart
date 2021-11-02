import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'modules/splash/splash_page.dart';

import 'modules/barcode_scanner/barcode_scanner_page.dart';
import 'modules/home/home_page.dart';
import 'modules/login/login_page.dart';
import 'shared/themes/app_colors.dart';

class AppWidget extends StatelessWidget {
  AppWidget({Key? key}) : super(key: key) {
    //deixar sempre a tela presa em pé
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pay flow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        primarySwatch: Colors.orange,
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: AppColors.primary),
      ),
      //fica no lugar do home:
      initialRoute: '/splash',
      //rotas nomeadas
      routes: {
        '/splash': (context) => const SplashPage(),
        '/home': (context) => const HomePage(),
        '/login': (contex) => const LoginPage(),
        '/barcode_scanner': (context) => const BarcodeScannerPage(),
      },
    );
  }
}
