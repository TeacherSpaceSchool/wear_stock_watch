import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../widget/dialog/add_element.dart';
import '../widget/dialog/index.dart';
import '../main.dart';
import '../widget/snack_bar.dart';

class HomePage extends HookWidget  {

	const HomePage({super.key});

	@override
	Widget build(BuildContext context) {
		final tabController = useTabController(initialLength: 2);
		final setting = useState<List>([]);
		final wallet = useState<List>([]);
		useEffect(() {
			setting.value = box.get('setting');
			wallet.value = box.get('wallet');
		}, []);
		//add
		add() async {
			final Map<String, dynamic>? resultDialog = await showMyDialog(
				content: AddElementDialog(idx: tabController.index),
				title: 'Добавить'
			);
			if(resultDialog!=null) {
				if(tabController.index==0) {
					setting.value = [resultDialog, ...setting.value];
				}
				else {
					wallet.value = [resultDialog, ...wallet.value];
				}
				HapticFeedback.vibrate();
			}
		}
		//delete
		delete(int idx) {
			List list = tabController.index==0?setting.value:wallet.value;
			list.removeAt(idx);
			if(tabController.index==0) {
			    setting.value = [...list];
			}
			else {
				wallet.value = [...list];
			}
			HapticFeedback.vibrate();
		}
		//onReorder
		onReorder(int oldIndex, int newIndex) {
			if (oldIndex < newIndex) {
				newIndex -= 1;
			}
			List list = tabController.index==0?setting.value:wallet.value;
			final Map item = list.removeAt(oldIndex);
			list.insert(newIndex, item);
			if(tabController.index==0) {
			  setting.value = [...list];
			} else {
			  wallet.value = [...list];
			}
			HapticFeedback.vibrate();
		}
		//sync
		sync() {
			box.put('setting', setting.value);
			box.put('wallet', setting.value);
			watch.sendMessage({
				'setting': setting.value,
				'wallet': wallet.value,
			});
			HapticFeedback.vibrate();
			showSnackBar('SYNC', type: 's');
		}
		return Scaffold(
			appBar: AppBar(
				bottom: TabBar(
					controller: tabController,
					tabs: const [
						Tab(icon: Icon(Icons.timeline)),
						Tab(icon: Icon(Icons.wallet)),
					],
				),
				title: const Text('WearStock'),
			),
			body: SafeArea(
				child: TabBarView(
					controller: tabController,
					children: [
						ReorderableListView(
							key: const ValueKey(0),
							padding: const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 65),
							proxyDecorator: proxyDecorator,
							children: [
								for (int idx = 0; idx < setting.value.length; idx += 1)
									Padding(
										key: ValueKey(idx),
										padding: const EdgeInsets.all(5),
										child: Row(
											crossAxisAlignment: CrossAxisAlignment.center,
											children: [
												Expanded(
													child: Column(
														crossAxisAlignment: CrossAxisAlignment.start,
														children: [
															Text(
																setting.value[idx]['symbol']
															),
															Text(
																setting.value[idx]['type'],
																style: Theme.of(context).textTheme.bodySmall
															)
														]
													)
												),
												InkWell(
													child: const IconButton(
														icon: Icon(
															Icons.delete,
															color: Colors.red,
															size: 30
														), onPressed: null,
													),
													onLongPress: () => delete(idx),
												)
											],
										)
									)
							],
							onReorder: (int oldIndex, int newIndex) => onReorder(oldIndex, newIndex),
						),
						ReorderableListView(
							key: const ValueKey(1),
							padding: const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 65),
							proxyDecorator: proxyDecorator,
							children: [
								for (int idx = 0; idx < wallet.value.length; idx += 1)
									Padding(
										key: ValueKey(idx),
										padding: const EdgeInsets.all(5),
										child: Row(
											crossAxisAlignment: CrossAxisAlignment.center,
											children: [
												Expanded(
													child: Column(
														crossAxisAlignment: CrossAxisAlignment.start,
														children: [
															Text(
																'${wallet.value[idx]['count']} ${wallet.value[idx]['symbol']}'
															),
															Text(
																wallet.value[idx]['type'],
																style: Theme.of(context).textTheme.bodySmall
															)
														]
													)
												),
												InkWell(
													child: const IconButton(
														icon: Icon(
															Icons.delete,
															color: Colors.red,
															size: 30
														), onPressed: null,
													),
													onLongPress: () => delete(idx),
												)
											],
										)
									)
							],
							onReorder: (int oldIndex, int newIndex) => onReorder(oldIndex, newIndex),
						),
					]
				)
			),
			floatingActionButton: Row(
				mainAxisSize: MainAxisSize.min,
				mainAxisAlignment: MainAxisAlignment.end,
				children: [
					FloatingActionButton(
						onPressed: sync,
						child: const Icon(Icons.sync),
					),
					const SizedBox(width: 20),
					FloatingActionButton(
						backgroundColor: Colors.green,
						onPressed: add,
						child: const Icon(Icons.add),
					),
				]
			)
		);
	}

}

Widget proxyDecorator(
	Widget child, int index, Animation<double> animation) {
	return AnimatedBuilder(
		animation: animation,
		builder: (BuildContext context, Widget? child) {
			return Material(
				color: Colors.black26,
				child: child,
			);
		},
		child: child,
	);
}
