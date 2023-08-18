import 'dart:ui';

class DataItem {
	final String? symbol;
	final String price;
	final Color color;
	final String? changePercent;
	final String? openPrice;
	final String? highPrice;
	final String? lowPrice;

	const DataItem({
		this.symbol,
		required this.price,
		required this.color,
		this.changePercent,
		this.openPrice,
		this.highPrice,
		this.lowPrice,
	});
}