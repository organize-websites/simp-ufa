 
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import 'homesimp2.dart';
import 'homescreen.dart';

Future<void> main() async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('tokenjwt');
  print(token);
  runApp(MaterialApp(home: token == null ? SplashPage() : HomeSimp3n()));
}

class SplashPage extends StatefulWidget {
  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  paraOutraTela() async{
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, main);
  }
  VideoPlayerController _controller;
  void navigationToNextPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    /*Navigator.pushReplacementNamed(context, '/HomePage');*/
  }

  startSplashScreenTimer() async {
    var _duration = new Duration(seconds: 11);
    return new Timer(_duration, navigationToNextPage);
  }

  @override
  void initState() {
    super.initState();
    paraOutraTela();
    startSplashScreenTimer();
    _controller = VideoPlayerController.asset('imagens/s.mp4')..initialize().then((_) {_controller.play(); setState(() {});});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    return Container(
      color: Colors.white,
      child: Center(
                child: _controller.value.initialized
                ? AspectRatio(aspectRatio: _controller.value.aspectRatio, child: VideoPlayer(_controller),)
                : Container()
                ),
    );
              
  }
}