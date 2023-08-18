import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wear_stock/models/walletItem.dart';
import '../main.dart';
import '../models/dataItem.dart';

const String binanceURL = 'https://api.binance.com/api/v3/ticker/24hr?symbols=';
const String binanceURLSingle = 'https://api.binance.com/api/v3/ticker/24hr?symbol=';
const String yahooURL = 'https://query1.finance.yahoo.com/v7/finance/options/';

Future<List<DataItem>?> getData() async {
  try {
    //parseSetting
    final List setting = box.get('setting');
    if(setting.isEmpty) return [];
    List symbolsBinance = [];
    List symbolsYahoo = [];
    for (var element in setting) {
      if(element['type']=='Binance') {
        symbolsBinance.add(element['symbol']);
      }
      else {
        symbolsYahoo.add(element['symbol']);
      }
    }
    //Binance
    final String symbolsJSONBinance = jsonEncode(symbolsBinance);
    final http.Response res = await http.get(Uri.parse('$binanceURL$symbolsJSONBinance'));
    final List resBodyBinance = jsonDecode(res.body);
    List<DataItem> listBinance = [];
    for(int i=0; i<resBodyBinance.length; i++) {
      final priceChange = double.parse(resBodyBinance[i]['priceChangePercent']);
      listBinance.add(DataItem(
        symbol: resBodyBinance[i]['symbol'],
        price: double.parse(resBodyBinance[i]['lastPrice']).toStringAsFixed(2),
        changePercent: '${priceChange.toStringAsFixed(2)}%',
        color: priceChange==0?Colors.white:priceChange>0?Colors.green:Colors.red,
        openPrice: double.parse(resBodyBinance[i]['openPrice']).toStringAsFixed(2),
        highPrice: double.parse(resBodyBinance[i]['highPrice']).toStringAsFixed(2),
        lowPrice: double.parse(resBodyBinance[i]['lowPrice']).toStringAsFixed(2),
      ));
    }
    //Yahoo
    List<DataItem> listYahoo = [];
    for (var symbolYahoo in symbolsYahoo) {
      final http.Response resYahoo = await http.get(Uri.parse('$yahooURL$symbolYahoo'));
      final jsonYahoo = jsonDecode(resYahoo.body);
      final dataYahoo = jsonYahoo['optionChain']['result'][0]['quote'];
      listYahoo.add(DataItem(
        symbol: symbolYahoo,
        price: dataYahoo['regularMarketPrice'].toStringAsFixed(2),
        changePercent: '${dataYahoo['regularMarketChangePercent'].toStringAsFixed(2)}%',
        color: dataYahoo['regularMarketChangePercent']==0?Colors.white:dataYahoo['regularMarketChangePercent']>0?Colors.green:Colors.red,
        openPrice: dataYahoo['regularMarketOpen'].toStringAsFixed(2),
        highPrice: dataYahoo['regularMarketDayHigh'].toStringAsFixed(2),
        lowPrice: dataYahoo['regularMarketDayLow'].toStringAsFixed(2),
      ));
    }
    //resList
    List<DataItem> list = [...listYahoo, ...listBinance];
    List<DataItem> parsedList = [];
    for (var element in setting) {
      for(int i=0; i<list.length; i++) {
        if(list[i].symbol==element['symbol']) {
          parsedList.add(list[i]);
          list.removeAt(i);
          break;
        }
      }
    }
    return parsedList;
  } catch(error) {
    print(error);
    return null;
  }
}

Future<List<WalletItem>?> getWallet() async {
  try {
    //parseWallet
    final List<WalletItem> parsedList = [];
    final List wallet = box.get('wallet');
    if(wallet.isEmpty) return [];
    for (var element in wallet) {
      final http.Response res = await http.get(Uri.parse('${element['type']=='Binance'?binanceURLSingle:yahooURL}${element['symbol']}'));
      final json = jsonDecode(res.body);
      final Map dataItem;
      if(element['type']=='Yahoo') {
        final data = json['optionChain']['result'][0]['quote'];
        dataItem = {
          'price': data['regularMarketPrice'],
          'color': data['regularMarketChangePercent'] == 0 ? Colors.white : data['regularMarketChangePercent'] > 0 ? Colors.green : Colors.red,
        };
      }
      else {
        final priceChange = double.parse(json['priceChangePercent']);
        dataItem = {
          'price': double.parse(json['lastPrice']),
          'color': priceChange == 0 ? Colors.white : priceChange > 0 ? Colors.green : Colors.red,
        };
      }
      parsedList.add(WalletItem(
          symbol: element['symbol'],
          price: (element['count']*dataItem['price']).toStringAsFixed(2),
          color: dataItem['color']
      ));
    }
    return parsedList;
  } catch(error) {
    print(error);
    return null;
  }
}