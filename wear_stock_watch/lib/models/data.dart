import 'dart:ui';

class Data {
	final String symbol;
	final String price;
	final String changePercent;
	final Color color;
	final String openPrice;
	final String highPrice;
	final String lowPrice;

	const Data({
		required this.symbol,
		required this.price,
		required this.changePercent,
		required this.color,
		required this.openPrice,
		required this.highPrice,
		required this.lowPrice,
	});
}