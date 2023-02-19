import 'package:flutter/material.dart';
import 'package:web3_connect/web3_connect.dart';
import 'HomeScreen.dart';
import 'package:coin_dex/helpers/globals.dart' as globals;

//FundContract - 0xe96d1ef5bA4B81Ca9936D5f09Ae339b30F2A5B3c

class LoginScreen extends StatefulWidget{
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>{

  Web3Connect connector = globals.connector;

  loginUsingMetamask(BuildContext context) async {
    await connector.connect();
    if (connector.account!="") {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const HomeScreen()));
    }
  }

  @override
  void initState() {
    if (connector.account!="") {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const HomeScreen()));
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset("assets/images/logo.png",height: 30,fit:BoxFit.fitHeight),
            const Text("oindex")
          ],
        ),
        backgroundColor: const Color(0x00f5f5f5),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 250,),
            Image.asset("assets/images/logo.png"),
            const SizedBox(height: 20,),
            ElevatedButton(
                onPressed: (){
                  loginUsingMetamask(context);
                },
                child: const Text('Connect to Metamask')
            )
          ],
        ),
      ),
    );
  }
}