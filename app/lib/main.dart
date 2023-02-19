import 'package:coin_dex/components/SplashScreen.dart';
import 'package:flutter/material.dart';
import './components/HomeScreen.dart';
import './components/CoinsetDetailsScreen.dart';
import './components/CoinsetsScreen.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  void onTap(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  final List <Widget> _screenOptions = <Widget>[
    const HomeScreen(),
    const Coinsets()
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0x00f5f5f5)
        ),
        home: const Scaffold(
          body: Splash()
        )
    );
  }
}



