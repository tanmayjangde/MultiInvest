import 'dart:convert';
import 'package:coin_dex/components/invest.dart';
import 'package:coin_dex/models/Coin.dart';
import 'package:flutter/material.dart';
import 'package:coin_dex/components/ReusableCard.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'package:coin_dex/components/CoinsetsScreen.dart' as cs;


class CoinsetDetailsScreen extends StatefulWidget {
  String coinsetName="";
  List<Coin> coins = [];
  CoinsetDetailsScreen(this.coinsetName,this.coins);

  @override
  _CoinsetDetailsScreenState createState() => _CoinsetDetailsScreenState(coins);
}

class _CoinData{
  _CoinData(this.date,this.price);
  String date;
  double price;

  String getDate(){
    return date;
  }
  double getPrice(){
    return price;
  }
}

class _CoinsetDetailsScreenState extends State<CoinsetDetailsScreen> {
  List<Coin> coins = [];
  _CoinsetDetailsScreenState(this.coins);

  List<_CoinData> data = [];
  String percentageChange = "0";

  late CrosshairBehavior _crosshairBehavior;
  int index=0;
   getIndex(){
     for(int i=0;i<cs.coinsets.length;i++){
       if(cs.coinsets[i].name==widget.coinsetName)
         index=i;
     }
   }


  @override
  void initState(){
    _crosshairBehavior = CrosshairBehavior(
      // Enables the crosshair
        enable: true
    );
    super.initState();
    loadCoinData();
  }

  void loadCoinData()async{
    List<_CoinData> coin_data = [];

    for(int j=0; j<coins.length;j++){
      String symbol = (coins[j].getSymbol()).trim();
      if(symbol=='eth')symbol = 'ETH';
      if(symbol == 'wBTC') symbol = 'BTC';
      var res = await http.get(Uri.parse("https://luminous-florentine-4dc632.netlify.app/coinPriceHistory/" + symbol));
      var result = json.decode(res.body);
      var price_history = result[0]['price_history'];


      for(var i=0;i<price_history.length;i++){
        var date = DateTime.parse(price_history[i]['date']);
        String string_date = (date.day).toString() + "/" + (date.month).toString() + "/" + (date.year).toString();
        double price = price_history[i]['usd'];
        if(j==0)coin_data.add(_CoinData(string_date, price));
        else{
          coin_data[i] = _CoinData(string_date, coin_data[i].getPrice() + price);
        }
      }
    }


    double first = coin_data[0].getPrice(), last = coin_data[coin_data.length - 1].getPrice();
    double change = (last - first)/first ;
    setState(() {
      data = coin_data;
      percentageChange = change.toStringAsFixed(3);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackButton(),
              Container(
                  margin: const EdgeInsets.all(22),
                  child : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.coinsetName,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                          ),
                          //Icon(Icons.share)
                        ],
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ReusableCard(
                              Row(
                                children: const [
                                  Icon(Icons.people_alt_outlined),
                                  SizedBox(width: 5),
                                  Text("0",style: TextStyle(fontSize: 18),),
                                  Text("investors", style: TextStyle(
                                    color: Color.fromRGBO(146, 145, 177, 1),
                                    fontSize: 10
                                  ),)
                                ],
                              ),
                              50,
                              12),
                          ReusableCard(
                              Row(
                                children:  [
                                  Icon((double.parse(percentageChange) < 0 ? Icons.arrow_drop_down : Icons.arrow_drop_up),color: ((double.parse(percentageChange) < 0 ? Colors.red : Colors.green))),
                                  Text(percentageChange, style: TextStyle(fontSize: 18,color: (double.parse(percentageChange) < 0 ? Colors.red : Colors.green) )),
                                ],
                              ),
                              50,
                              12)
                        ],
                      )
                    ],
                  )
              ),
              SfCartesianChart(
                  crosshairBehavior: _crosshairBehavior,
                  tooltipBehavior: TooltipBehavior(enable: true),

                  primaryXAxis: CategoryAxis(isVisible:false),
                  series: <ChartSeries<_CoinData, String>>[
                    LineSeries<_CoinData, String>(
                        dataSource: data,
                        xValueMapper: (_CoinData price, _) => price.date,
                        yValueMapper: (_CoinData price, _) => price.price,
                        name: 'Price',
                        // Enable data label
                        dataLabelSettings: const DataLabelSettings(isVisible: false))
                  ]),
              Container(
                margin: EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Constituents",style: TextStyle(fontSize: 20),),
                    SizedBox(height: 15),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Table(
                          children:[TableRow(
                              children: [
                                Text("Name",style: TextStyle(fontSize: 16,color: Color.fromRGBO(146, 145, 177, 1)),),
                                Text("Holding %",style: TextStyle(fontSize: 16,color: Color.fromRGBO(146, 145, 177, 1))),
                              ]
                          )]

                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Table(
                        children:
                          widget.coins.map((coin)=>TableRow(
                              children: [
                                Text(coin.getName(),style: TextStyle(height: 2.5,color: Color.fromRGBO(212, 212, 212, 0.61)),),
                                Text((100 / widget.coins.length).toStringAsFixed(2)+ "%",style: TextStyle(height: 2.5,color: Color.fromRGBO(212, 212, 212, 0.61)),),
                              ]
                          )).toList()

                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 35,),
            ],
          ),
        ),
      ),

      bottomSheet: Container(
        width: MediaQuery.of(context).size.width,
        child: TextButton(
          child: Text("Invest",style: TextStyle(color: Colors.white),),
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Invest(index: index,)));
          },
        ),
        color: Color.fromRGBO(31, 31, 57, 0.5),
      ),
    );
  }
}