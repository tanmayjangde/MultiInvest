import 'package:coin_dex/components/HomeScreen.dart';
import 'package:coin_dex/components/LoginScreen.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  
  @override
  void initState(){
    super.initState();
    _navigationhome();
  }
  
  _navigationhome()async{
    await Future.delayed(const Duration(milliseconds: 3000),(){});
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const LoginScreen()));
  }
  
  @override
  Widget build(BuildContext context) {
    return Center(child: Image.asset("assets/images/logo.png",height: 500,width: 500,));
  }
}
