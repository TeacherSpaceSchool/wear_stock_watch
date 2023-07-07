import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:watch_connectivity/watch_connectivity.dart';
import 'module/alwaysON.dart';
import 'module/snack_bar.dart';
import 'route/router.dart';
import 'module/app_data.dart';

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
    //WatchConnectivity
    watch = WatchConnectivity();
    //initialApp
    await initialApp();
    //run
    runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {

    const MyApp({super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        //sync data from phone
        useEffect(() {
            StreamSubscription dataStream = watch.messageStream.listen((message) {
                box.put('setting', message['setting']);
                showSnackBar('SYNC', type: 's');
            });
            return () => dataStream.cancel();
        }, []);
        //alwaysON
        final bool ambient = ref.watch(ambientProvider);
        final appLifecycleState = useAppLifecycleState();
        useEffect(() {
            if(appLifecycleState==AppLifecycleState.resumed) {
                startAlwaysON(ref);
            }
            else {
                stopAlwaysON(ref);
            }
        }, [appLifecycleState]);
        return Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
                MaterialApp(
                    scaffoldMessengerKey: snackbarKey,
                    navigatorKey: navigatorKey,
                    debugShowCheckedModeBanner: false,
                    theme: ThemeData(
                        visualDensity: VisualDensity.compact,
                        primarySwatch: Colors.indigo,
                        scaffoldBackgroundColor: Colors.black,
                        textTheme: const TextTheme(
                            bodyMedium: TextStyle(
                                color: Colors.white,
                                fontSize: regularTextSize
                            ),
                            bodySmall: TextStyle(
                                color: Colors.white70,
                                fontSize: smallTextSize
                            ),
                            titleMedium: TextStyle(
                                color: Colors.white,
                                fontSize: regularTextSize
                            ),
                        ),
                        textSelectionTheme: const TextSelectionThemeData(
                            cursorColor: Colors.white,
                        ),
                        inputDecorationTheme: const InputDecorationTheme(
                            labelStyle: TextStyle(
                                color: Colors.white70,
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 3, color: Colors.white70),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 3, color: Colors.white),
                            ),
                        ),
                    ),
                    initialRoute: initialRoute,
                    routes: router(context)
                ),
                ...ambient?[
                    GestureDetector(
                        onTap: () => startAlwaysON(ref),
                        child: Container(
                            color: Colors.black54,
                        )
                    )
                ]:[]
            ]
        );
    }
}

