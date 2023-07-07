import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../widget/dialog/add_element.dart';
import '../widget/dialog/index.dart';
import '../main.dart';

class HomePage extends HookWidget  {

	const HomePage({super.key});

	@override
	Widget build(BuildContext context) {
		final setting = useState<List>([]);
		useEffect(() {
			List setting_ = box.get('setting');
			setting.value = [...setting_];
		}, []);
		//add
		add() async {
			final Map<String, dynamic>? resultDialog = await showMyDialog(
				content: const AddElementDialog(),
				title: 'Добавить'
			);
			if(resultDialog!=null) {
				setting.value = [resultDialog, ...setting.value];
				HapticFeedback.vibrate();
			}
		}
		//delete
		delete(int idx) {
			setting.value.removeAt(idx);
			setting.value = [...setting.value];
			HapticFeedback.vibrate();
		}
		//onReorder
		onReorder(int oldIndex, int newIndex) {
			if (oldIndex < newIndex) {
				newIndex -= 1;
			}
			final Map item = setting.value.removeAt(oldIndex);
			setting.value.insert(newIndex, item);
			setting.value = [...setting.value];
			HapticFeedback.vibrate();
		}
		//sync
		sync() {
			box.put('setting', setting.value);
			watch.sendMessage({'setting': setting.value});
			HapticFeedback.vibrate();
		}
		return Scaffold(
			body: SafeArea(
				child: Stack(
					fit: StackFit.expand,
					children: [
						ReorderableListView(
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
																setting.value[idx]['name']
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
						)
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
