import 'package:flutter/material.dart'
    show BuildContext, MaterialApp, StatelessWidget, Widget, runApp;
import 'package:layout/SelecionarDispositivo.dart';
import 'package:layout/HomePage.dart';
import 'package:layout/splash.dart';
import 'package:provider/provider.dart';
import 'provider/StatusConexaoProvider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(

        providers: [
          ChangeNotifierProvider<StatusConexaoProvider>.value(
              value: StatusConexaoProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Xerocasa',
          initialRoute: '/',
          routes: {
            '/': (context) => Splash(),
            '/selectDevice': (context) => const SelecionarDispositivoPage(),
            '/HomePage': (context) => const HomePage(),

          },
        ));
  }
}
