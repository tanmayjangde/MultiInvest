class Coin{
  String? name;
  String? symbol;
  String? address;
  int? value;

  Coin({required this.name, required this.symbol, required this.address, this.value});

  Coin.fromAddress(String address){
    name = '';
    symbol= '';
    address = address;
  }

  getName(){
    return this.name;
  }
  getSymbol(){
    return this.symbol;
  }


}
class CoinDisplayModel{
  List<Coin>? coins;
  CoinDisplayModel(this.coins);

  getListOfCoins(List coins){
    coins.forEach((v) {
      coins!.add(Coin.fromAddress(v));
    });
    return coins;
  }
}