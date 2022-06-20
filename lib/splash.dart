import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:layout/HomePage.dart';

import 'main.dart';


class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}



class _SplashState extends State<Splash> {





  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(nextScreen:  HomePage(),
      splash:Image(image:AssetImage('images/logo.jpeg') ,) ,
      splashTransition: SplashTransition.scaleTransition,
        backgroundColor:Colors.white
      // imagePath:'assets/logo.png', home: Home(),
      // backGroundColor:const Color(0xff00334a),
      // customFunction:  (){
      //   player.play();
      //   return 1;
      // },
      // duration: 4000,
      // outputAndHome: output,
      // type: CustomSplashType.BackgroundProcess,
      //   animationEffect: 'zoom-in',

    );
  }
}
