import 'package:coin_dex/components/ReusableCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:coin_dex/components/CoinsetsScreen.dart' as cs;
import '../models/CoinSet.dart';
import '../services/smart_contract_functions.dart';

List<CoinSet> pcs = [];

class PortfolioScreen extends StatefulWidget {
  double portfolio = 0;
  PortfolioScreen({Key? key,required this.portfolio}) : super(key: key);

  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {


  getPortfolio()async{
    List<CoinSet> tempCoinsets = [];
    List<dynamic> cst = (await CoinDex().getPortFolioAllCoins())[0];
    debugPrint(cst.toString());
    for(int i=0;i<cst.length;i++){
    int j = cst[i];
    tempCoinsets.add(cs.coinsets[j]);
    }
    tempCoinsets.add(cs.coinsets[0]);
    //tempCoinsets.add(cs.coinsets[1]);
    setState(() {
      pcs=tempCoinsets;
    });
  }

  @override
  void initState(){
    super.initState();
    getPortfolio();
    print(cs.coinsets.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackButton(),
              Container(
                margin: EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ReusableCard(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "My portfolio",
                            style: TextStyle(color: Color.fromRGBO(146, 145, 177, 1),fontSize: 20),
                          ),
                          SizedBox(height:20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "\$${widget.portfolio.toStringAsFixed(2)}                         ",
                                style: TextStyle(fontSize: 32),
                              ),
                              // Row(
                              //   children: [
                              //     Icon(Icons.arrow_drop_down,color: Colors.red,),
                              //     Text("14%",style: TextStyle(fontSize: 20,color: Colors.red)),
                              //   ],
                              // )
                            ],
                          ),
                          //SizedBox(height: 10,),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Column(
                          //       children: [
                          //         Text("Invested",style: TextStyle(fontSize: 20,color: Color.fromRGBO(146, 145, 177, 1)),),
                          //         SizedBox(height: 10,),
                          //         Text("\$146.22",style: TextStyle(fontSize: 20))
                          //       ],
                          //     ),
                          //     Column(
                          //       children: [
                          //         Text("Available",style: TextStyle(fontSize: 20,color: Color.fromRGBO(146, 145, 177, 1)),),
                          //         //SizedBox(height: 10,),
                          //         Text("\$146.22",style: TextStyle(fontSize: 20))
                          //       ],
                          //     )
                          //   ],
                          // )
                        ],
                      )
                      , 150, 20),
                    ),
                    SizedBox(height: 40,),
                    Text("Investments",style: TextStyle(fontSize: 20),),
                    SizedBox(height: 20,),
                    for(int i=0;i<pcs.length;i++)
                      Slidable(
                        key: const ValueKey(0),
                        startActionPane: ActionPane(
                          // A motion is a widget used to control how the pane animates.
                          motion: const ScrollMotion(),
                          // All actions are defined in the children parameter.
                          children:  [
                            // A SlidableAction can have an icon and/or a label.
                            SlidableAction(
                              onPressed: (BuildContext c){
                                CoinDex().sell(i);
                              },
                              backgroundColor: Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              label: 'Sell',
                            )
                          ],
                        ),
                        child: ReusableCard(
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${pcs[i].name}",style: TextStyle(fontSize: 18),),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${widget.portfolio.toStringAsFixed(2)}",style: TextStyle(fontSize: 20),),
                                    Text("0%",style: TextStyle(fontSize: 16,color: Colors.green),)
                                  ],
                                )
                              ],
                            ),
                            92, 20),
                      ),
                    SizedBox(height: 8,),
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
