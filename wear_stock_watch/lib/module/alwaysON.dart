import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakelock/wakelock.dart';

final ambientProvider = StateProvider<bool>((ref) => false);
Timer? timerAmbient;

stopAlwaysON(WidgetRef ref) {
	timerAmbient?.cancel();
	Wakelock.disable();
	ref.read(ambientProvider.notifier).state = false;
}

startAlwaysON(WidgetRef ref) {
	timerAmbient?.cancel();
	ref.read(ambientProvider.notifier).state = false;
	Wakelock.enable();
	timerAmbient = Timer(const Duration(seconds: 30), () {
		ref.read(ambientProvider.notifier).state = true;
		Wakelock.disable();
	});
}
