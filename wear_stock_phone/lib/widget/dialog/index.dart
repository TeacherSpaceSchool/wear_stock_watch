import 'package:flutter/material.dart';
import '../../main.dart';
import '../../module/app_data.dart';

showMyDialog({required Widget content, String? title, accept}) async {
    return await showDialog<Map<String, dynamic>>(
        barrierColor: Colors.black26,
        context: navigatorKey.currentContext!,
        builder: (BuildContext dialogContext) =>
            Dialog(
                insetPadding: EdgeInsets.symmetric(horizontal: insetPaddingDialog, vertical: 32),
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            ...title!=null?[
                                Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 15)
                            ]:[],
                            content
                        ],
                    ),
                )
            )
    );
}
