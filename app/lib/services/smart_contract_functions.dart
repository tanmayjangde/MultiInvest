import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:coin_dex/helpers/globals.dart' as globals;

class CoinDex{

  late Web3Client _client;
  String _abiCode = '';
  //final String _rpcUrl = 'https://rpc-mumbai.matic.today/';
  final String _rpcUrl = 'https://api.avax-test.network/ext/bc/C/rpc';

  late Credentials _credentials ;
  final EthereumAddress _contractAddress =
  EthereumAddress.fromHex('0xDaF6Ca1E5A73ac4C94529AAFbb21cbEe5948ebb0');
  //late EthereumAddress _ownAddress;
  late DeployedContract _contract;

  late ContractFunction _getAllCoinSets;
  late ContractFunction _getPortfolio;
  late ContractFunction _sell;
  late ContractFunction _buy;
  late ContractFunction _getTokenNameAndSymbol;
  late ContractFunction _getPortfolioAmount;

  getAllCoinSets() async {
    _client = Web3Client(_rpcUrl, Client());
    _credentials = globals.connector.credentials;
    _abiCode = await rootBundle.loadString("assets/abi/abi.json");
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "CoinDex"), _contractAddress);
    _getAllCoinSets = _contract.function("getAllCoinSets");
    List allCoinSets = await _client.call(contract: _contract, function: _getAllCoinSets, params: []);
    debugPrint(allCoinSets.toString());
    // debugPrint(allCoinSets.toString());
    return allCoinSets;
  }

  getPortFolioAmount() async {
    _client = Web3Client(_rpcUrl, Client());
    _credentials = globals.connector.credentials;
    _abiCode = await rootBundle.loadString("assets/abi/abi.json");
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "CoinDex"), _contractAddress);
    _getPortfolioAmount = _contract.function("getPortfolioValue");

    List portfolio = await _client.call(contract: _contract, function: _getPortfolioAmount, params: []);
    debugPrint(portfolio.toString());
    return portfolio;
  }

  getPortFolioAllCoins() async {
    _client = Web3Client(_rpcUrl, Client());
    _credentials = globals.connector.credentials;
    _abiCode = await rootBundle.loadString("assets/abi/abi.json");
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "CoinDex"), _contractAddress);
    _getPortfolio = _contract.function("getInvestedCoin");

    List portfolio = await _client.call(contract: _contract, function: _getPortfolio, params: []);
    debugPrint(portfolio.toString());
    return portfolio;
  }



  sell(int index) async {
    _client = Web3Client(_rpcUrl, Client());
    _credentials = globals.connector.credentials;
    _abiCode = await rootBundle.loadString("assets/abi/abi.json");
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "CoinDex"), _contractAddress);
    _sell = _contract.function("sellCoinSet");

    List sell = await _client.call(contract: _contract, function: _sell, params: [BigInt.from(index)]);
    debugPrint(sell.toString());
  }

  buy(int index, BigInt value) async{
    _client = Web3Client(_rpcUrl, Client());
    _credentials = globals.connector.credentials;
    _abiCode = await rootBundle.loadString("assets/abi/abi.json");
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "CoinDex"), _contractAddress);
    _buy = _contract.function("investInCoinSet");
    var address = EthereumAddress.fromHex(globals.connector.session!.accounts[0]);
    debugPrint(address.toString());

    String? buy = await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: _buy,
        parameters: [BigInt.from(index)],
        from: address,
        value: EtherAmount.fromUnitAndValue(EtherUnit.finney, value),
      ),
    );

    debugPrint(buy.toString());
  }

  getNameAndSymbol(EthereumAddress value) async{
    _client = Web3Client(_rpcUrl, Client());
    //_credentials = globals.connector.credentials;
    _abiCode = await rootBundle.loadString("assets/abi/abi.json");
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "CoinDex"), _contractAddress);
    _getTokenNameAndSymbol = _contract.function("getTokenNameAndSymbol");

    List getTokenNameAndSymbol = await _client.call(contract: _contract, function: _getTokenNameAndSymbol, params: [value]);
    // debugPrint(getTokenNameAndSymbol.toString());
    return getTokenNameAndSymbol;
  }
}