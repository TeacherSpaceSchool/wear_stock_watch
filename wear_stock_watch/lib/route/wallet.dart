import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../module/get_data.dart';
import '../models/walletItem.dart';
import '../module/app_data.dart';

class WalletPage extends HookWidget  {

	const WalletPage({super.key});

	@override
	Widget build(BuildContext context) {
		final load = useState<bool>(false);
		final list = useState<List<WalletItem>?>([]);
		updateData() async {
			if(!load.value) {
				load.value = true;
				list.value = await getWallet();
				load.value = false;
			}
		}
		final appLifecycleState = useAppLifecycleState();
		useEffect(() {
			if(appLifecycleState==AppLifecycleState.resumed) {
				updateData();
			}
			else {
				list.value = [];
			}
		}, [appLifecycleState]);

		return Scaffold(
			body: Center(
				child: load.value?
					const SpinKitRing(
						color: Colors.indigo,
						size: 70,
						lineWidth: 5
					)
					:
				Stack(
					fit: StackFit.expand,
					children: [
						list.value!=null?
							ListView.builder(
								shrinkWrap: true,
								padding: EdgeInsets.only(top: margin, right: margin, bottom: margin, left: margin),
								itemCount: list.value!.length,
								itemBuilder: (BuildContext context, int idx) {
									return Text(
										'${list.value![idx].symbol} ${list.value![idx].price}',
										style: TextStyle(
											color: list.value![idx].color
										)
									);
								}
							)
							:
							Center(
							child: InkWell(
								onTap: updateData,
								child: const Text(
									'ОШИБКА',
									style: TextStyle(
										color: Colors.red,
									)
								)
							)
						),
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
					]
				)
			)
		);
	}

}
