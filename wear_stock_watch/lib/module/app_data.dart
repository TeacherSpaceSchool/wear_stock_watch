import 'dart:ui';

const double regularTextSize = 20;
const double smallTextSize = 18;
late final double boxWidth;
late final double margin;
late final double diameter;

//инициализация
Future<Map<String, dynamic>> initialApp() async {
  diameter = (window.physicalSize / window.devicePixelRatio).width;
  boxWidth = diameter / 1.4142;
  margin = (diameter - boxWidth)/2;
  //результат
  return {
  };
}