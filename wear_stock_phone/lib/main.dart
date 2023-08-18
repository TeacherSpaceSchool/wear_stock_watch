import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'route/router.dart';
import 'module/app_data.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

//initialRoute
String initialRoute = '/';
//WatchConnectivity
late final WatchConnectivity watch;
//hive
var box;
//key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    //hive
    await Hive.initFlutter();
    box = await Hive.openBox('wearStockBox');
    if(box.get('setting')==null) {
        box.put('setting', []);
    }
    if(box.get('wallet')==null) {
        box.put('wallet', []);
    }
    box.put('wallet', [
        {
            'symbol': 'BTCUSDT',
            'type': 'Binance',
            'count': 0.23
        }
    ]);
    //WatchConnectivity
    watch = WatchConnectivity();
    //initialApp
    await initialApp();
    //run
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({super.key});
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            scaffoldMessengerKey: snackbarKey,
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primarySwatch: Colors.indigo,
                textTheme:
                const TextTheme(
                    bodyMedium: TextStyle(
                        fontSize: regularTextSize
                    ),
                    bodySmall: TextStyle(
                        color: Colors.black54,
                        fontSize: smallTextSize
                    ),
                    titleMedium: TextStyle(
                        fontSize: regularTextSize
                    ),
                )
            ),
            initialRoute: initialRoute,
            routes: router(context)
        );
    }
}

