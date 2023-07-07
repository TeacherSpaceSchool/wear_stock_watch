import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import 'app_data.dart';

showSnackBar(text, {type = 'w'}) {
    HapticFeedback.vibrate();
    final SnackBar snackBar = SnackBar(
        duration: const Duration(seconds: 3),
        content: Center(
            child: Text(
                text,
                maxLines: 5,
                style: const TextStyle(
                    fontSize: regularTextSize
                )
            )
        ),
        backgroundColor: (type=='s'?Colors.green:type=='e'?Colors.red:Colors.orange)
    );
    snackbarKey.currentState?.showSnackBar(snackBar);
}