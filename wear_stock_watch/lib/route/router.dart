import 'home.dart';
import 'wallet.dart';

router(context) {
	return {
		'/': (context) => const HomePage(),
		'/wallet': (context) => const WalletPage(),
	};
}