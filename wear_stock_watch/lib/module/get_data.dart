import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../models/data.dart';

const String binanceURL = 'https://api.binance.com/api/v3/ticker/24hr?symbols=';
const String yahooURL = 'https://query1.finance.yahoo.com/v7/finance/options/';

Future<List<Data>?> getData() async {
  try {
    //parseSetting
    final List setting = box.get('setting');
    if(setting.isEmpty) return [];
    List symbolsBinance = [];
    List symbolsYahoo = [];
    for (var element in setting) {
      if(element['type']=='Binance') {
        symbolsBinance.add(element['name']);
      }
      else {
        symbolsYahoo.add(element['name']);
      }
    }
    //Binance
    final String symbolsJSONBinance = jsonEncode(symbolsBinance);
    final http.Response res = await http.get(Uri.parse('$binanceURL$symbolsJSONBinance'));
    final List resBodyBinance = jsonDecode(res.body);
    List<Data> listBinance = [];
    for(int i=0; i<resBodyBinance.length; i++) {
      final priceChange = double.parse(resBodyBinance[i]['priceChangePercent']);
      listBinance.add(Data(
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
    List<Data> listYahoo = [];
    for (var symbolYahoo in symbolsYahoo) {
      final http.Response resYahoo = await http.get(Uri.parse('$yahooURL$symbolYahoo'));
      final jsonYahoo = jsonDecode(resYahoo.body);
      final dataYahoo = jsonYahoo['optionChain']['result'][0]['quote'];
      listYahoo.add(Data(
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
    List<Data> list = [...listYahoo, ...listBinance];
    List<Data> parsedList = [];
    for (var element in setting) {
      for(int i=0; i<list.length; i++) {
        if(list[i].symbol==element['name']) {
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