import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../models/dataItem.dart';
import '../module/app_data.dart';

class DataPage extends HookWidget  {
	final DataItem element;

	const DataPage({super.key, required this.element});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: Stack(
				fit: StackFit.expand,
				children: [
					Positioned(
						top: 0,
						bottom: 0,
						left: 0,
						child: IconButton(
							padding: const EdgeInsets.all(0),
							iconSize: margin,
							icon: const Icon(
								Icons.arrow_back_ios_new,
								color: Colors.indigo
							),
							onPressed: () => Navigator.pop(context)
						)
					),
					Column(
						crossAxisAlignment: CrossAxisAlignment.center,
						mainAxisAlignment: MainAxisAlignment.center,
						children: [
							Text(
								element.symbol!,
								style: TextStyle(
									color: element.color
								)
							),
							const SizedBox(height: 5),
							Text(
								'Price: ${element.price}',
								style: TextStyle(
									color: element.color
								)
							),
							Text(
								'Change: ${element.changePercent}',
								style: TextStyle(
									color: element.color
								)
							),
							Text(
								'Open: ${element.openPrice}',
								style: TextStyle(
									color: element.color
								)
							),
							Text(
								'High: ${element.highPrice}',
								style: TextStyle(
									color: element.color
								)
							),
							Text(
								'Low: ${element.lowPrice}',
								style: TextStyle(
									color: element.color
								)
							),
						],
					),
				]
			)
		);
	}

}
