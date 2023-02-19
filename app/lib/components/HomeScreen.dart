import 'dart:async';

import 'package:coin_dex/components/PortfolioScreen.dart';
import 'package:coin_dex/components/ReusableCard.dart';
import 'package:coin_dex/models/Coin.dart';
import 'package:coin_dex/models/CoinSet.dart';
import 'package:coin_dex/services/smart_contract_functions.dart';
import 'package:flutter/material.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:web3dart/credentials.dart';
import 'CoinsetsScreen.dart';
import "ReusableCard.dart";
import 'dart:convert';
import "CoinsetDetailsScreen.dart";
import 'package:http/http.dart' as http;
import 'package:coin_dex/components/CoinsetsScreen.dart' as css;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;


  void onTap(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  final List <Widget> _screenOptions = <Widget>[
    const HomePage(),
    const Coinsets()
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.money),
              label: "Coinset"
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        onTap: onTap,
      ),
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset("assets/images/logo.png",height: 30,fit:BoxFit.fitHeight),
            const Text("oindex")
          ],
        ),
        backgroundColor: const Color(0x00f5f5f5),
      ),
      body: SafeArea(
          child: _screenOptions.elementAt(_selectedIndex)
      )
    );
  }
}
class HomePage extends StatefulWidget{
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();

}

class HomePageState extends State<HomePage>{

  double portfolioAmount = 0;
  String baseurl = 'https://luminous-florentine-4dc632.netlify.app/coinPrice/avax';
  double price = 0.00;
  double numberOfTokens = 8.5004477;



  getPortfolio()async{
    BigInt totalCoins = ((await CoinDex().getPortFolioAmount())[0]);
    debugPrint('total coins');
    debugPrint(totalCoins.toString());
    setState(() {
      portfolioAmount=price*numberOfTokens;
    });
  }

  @override
  void initState(){
    getCoinPrice();
    getPortfolio();
    loadCoinset();
    super.initState();
  }

  List<CoinSet> coinsets = [];

  getCoinPrice() async{
    Uri uri = Uri.parse(baseurl);
    dynamic response;
    try{
      response = await http.get(uri);
    }on TimeoutException catch(_){
      print("Time Out Exception");
      throw Exception("Failed to load data");
    }
    debugPrint(response.body);
    price=json.decode(response.body)['usd']??0;
    setState(() {
      portfolioAmount=price*numberOfTokens;
    });
  }

  void loadCoinset()async{
    List<CoinSet> tempCoinsets = [];
    List<dynamic> cs = (await CoinDex().getAllCoinSets())[0];
    for(int i=0;i<2;i++){
      String name = cs[i][0];
      List<dynamic> addressOfCoins = cs[i][1];

      List<Coin>coins = [];
      for(EthereumAddress address in addressOfCoins){
        List<dynamic> nameAndSymbol = await CoinDex().getNameAndSymbol(address);
        Coin coin = Coin(name: nameAndSymbol[0], symbol: nameAndSymbol[1], address: address.toString());
        coins.add(coin);
      }
      double returns = 0;
      if(i == 0){
        returns = 0.006;
      }else{
        returns = -0.021;
      }
      tempCoinsets.add(CoinSet(coins, name,returns));
    }

    setState(() {
      coinsets = tempCoinsets;
    });

    // print(c.getName());
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(22),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TextButton(onPressed: ()=>{
            //   CoinDex().getAllCoinSets()
            //   //CoinDex().buy(0, BigInt.from(10))
            // }, child: Text("Press")),
            GestureDetector(
              onTap: (){Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PortfolioScreen(portfolio:portfolioAmount,))
              );
              },
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ReusableCard(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start ,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:  [
                        const Text(
                          "My Account",
                          style: TextStyle(
                              fontSize: 20,
                              color: Color.fromRGBO(146, 145, 177, 1)
                          ),
                        ),
                        Row(
                          children: [
                            const Text('\$',
                                style: TextStyle(
                                    fontSize: 32,
                                    color:Color.fromRGBO(212, 212, 212, 1)
                                )
                            ),
                            Text(
                              '${portfolioAmount.toStringAsFixed(2)}                         ',
                              style: const TextStyle(
                                  fontSize: 32,
                                  color:Color.fromRGBO(212, 212, 212, 1)
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    128,
                    22
                ),
              ),
            ),
            const SizedBox(height:24),
            const Text(
                "Popular coin sets",
                style: TextStyle(
                    fontSize: 20,
                    color: Color.fromRGBO(245, 245, 245, 1)
                )
            ),
            const SizedBox(height:11),
            SingleChildScrollView(
              child: Column(
                children: (coinsets.length > 0 ? coinsets.map(
                      (coinset) =>
                      GestureDetector(
                        onTap: (){Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CoinsetDetailsScreen(coinset.getName(), coinset.getCoins())));},
                        child: ReusableCard(
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(coinset.getName(),style: TextStyle(fontSize: 18),),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children : [
                                      const Text(
                                          "Returns",
                                          style:TextStyle(
                                              color : Color.fromRGBO(146, 145, 177, 1)
                                          )),
                                      Text(
                                        coinset.getReturns().toString() + "%",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: (coinset.getReturns() <0 ? Colors.red: Colors.green)),
                                      )
                                    ]
                                  )
                              ],
                            ),
                            92, 20),
                      ),).toList() : [Padding(
                        padding: const EdgeInsets.fromLTRB(0,100,0,0),
                        child: Image.asset(circularProgressIndicator, scale: 10),
                      )])
              ),
            ),

          ],
        ),
      ),
    );
  }

}
