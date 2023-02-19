import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:coin_dex/components/PortfolioScreen.dart' as ps;
import 'package:coin_dex/components/CoinsetsScreen.dart' as cs;
import '../models/CoinSet.dart';
import '../services/smart_contract_functions.dart';

class Invest extends StatefulWidget {
  int index;
  Invest({Key? key,required this.index}) : super(key: key);

  @override
  _InvestState createState() => _InvestState();
}

class _InvestState extends State<Invest> {

  TextEditingController valueController = TextEditingController();
  String inputValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : SafeArea(
        child: Container(
          margin: EdgeInsets.all(22),
          child: Column(
            children: [
              TextField(
                controller: valueController ,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Value',
                ),
                onChanged: (text){
                  setState(() {
                    inputValue = text;
                  });
                },

              ),
              const SizedBox(height: 20,),
              TextButton(
                  onPressed: (){
                    CoinDex().buy(0, BigInt.from(int.parse(inputValue)));
                    ps.pcs.add(cs.coinsets[int.parse(inputValue)]);
                  },
                  child: const Text("Invest",style: TextStyle(color: Colors.white),),
                  style: TextButton.styleFrom(
                      backgroundColor: Color.fromRGBO(31, 31, 57, 1),
                    padding: EdgeInsets.fromLTRB(40,15,40,15)
                  )
                  // ButtonStyle(backgroundColor: MaterialStateProperty.all(Color.fromRGBO(31, 31, 57, 1))),
              )
            ],
          ),
        ),
      )
    );
  }
}
