import 'package:coin_dex/models/Coin.dart';

class CoinSet{
  String? name;
  List<Coin>? coins;
  List<int>? value;
  double? returns;
  CoinSet(this.coins,this.name,this.returns);
  
  CoinSet.from(String name, List coins){
    name = name;
    coins = coins;
  }

  getCoins(){
    return coins;
  }
  getName(){
    return name;
  }
  getReturns(){
    return returns;
  }
}

// class CoinSetDisplayModel{
//   List<CoinSet>? coinSets;
//   CoinSetDisplayModel(this.coinSets);
//   getListOfAllCoinsets(List coinsets){
//     List<CoinSet> cs =[];
//     coinsets[0].forEach((v) {
//       cs.add(CoinSet(v[0],CoinDisplayModel(v[1]).getListOfCoins(v[1])));
//     });
//     return cs;
//   }
// }