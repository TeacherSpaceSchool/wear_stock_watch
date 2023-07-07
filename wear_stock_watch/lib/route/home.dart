import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wear_stock/route/data.dart';
import '../../module/get_data.dart';
import '../models/data.dart';
import '../module/app_data.dart';

class HomePage extends HookWidget  {

	const HomePage({super.key});

	@override
	Widget build(BuildContext context) {
		final load = useState<bool>(false);
		final list = useState<List<Data>?>([]);
		updateData() async {
			if(!load.value) {
				load.value = true;
				list.value = await getData();
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
					list.value!=null?
						RefreshIndicator(
							backgroundColor: Colors.indigo,
							color: Colors.white,
							triggerMode: RefreshIndicatorTriggerMode.onEdge,
							onRefresh: () async {
								if(!load.value) {
									load.value = true;
									list.value = await getData();
									load.value = false;
								}
							},
							child: ListView.builder(
								shrinkWrap: true,
								padding: EdgeInsets.only(top: margin, right: margin, bottom: margin, left: margin),
								itemCount: list.value!.length,
								itemBuilder: (BuildContext context, int idx) {
									return  Column(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											InkWell(
												onTap: () => Navigator.push(
													context,
													MaterialPageRoute(builder: (context) => DataPage(element: list.value![idx])),
												),
												child: Text(
													'${list.value![idx].symbol} ${list.value![idx].price}',
													style: TextStyle(
														color: list.value![idx].color
													)
												)),
											const SizedBox(height: 5,)
										]

									);
								}
							)
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
						)
			)
		);
	}

}
