import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:wear_stock/widget/snack_bar.dart';

const List<String> list = <String>['Binance', 'Yahoo'];

class AddElementDialog extends HookWidget  {
    final int idx;

    const AddElementDialog({super.key, required this.idx});

    @override
    Widget build(BuildContext context) {
        //symbol
        final TextEditingController symbolController = useTextEditingController(text: '');
        final symbolError = useState<String?>('Заполните поле');
        //type
        final type = useState<String>('Binance');
        //count
        final TextEditingController countController = useTextEditingController(text: '');
        final countError = useState<String?>(idx==1?'Заполните поле':null);
        //close
        close() => Navigator.pop(context);
        //accept
        accept() {
            print('${symbolError.value} ${countError.value}');
            if(symbolError.value==null&&countError.value==null) {
                final Map<String, dynamic> resultDialog = {
                    'symbol': symbolController.text,
                    'type': type.value,
                };
                if(idx==1) {
                    resultDialog['count'] = int.parse(countController.text);
                }
                Navigator.pop(context, resultDialog);
            }
        }
        return Column(
            children: [
                Row(
                    children: [
                        Expanded(
                            child: TextField(
                                controller: symbolController,
                                onChanged: (String text) {
                                    if(text.isEmpty) {
                                        symbolError.value = 'Заполните поле';
                                    }
                                    else {
                                        symbolError.value = null;
                                    }
                                },
                                decoration: InputDecoration(
                                    labelText: 'Символ',
                                    errorText: symbolError.value
                                )
                            )
                        ),
                        const SizedBox(width: 10),
                        DropdownButton<String>(
                            value: type.value,
                            onChanged: (String? value) {
                                if(value!=null) type.value = value;
                            },
                            items: list.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                );
                            }).toList(),
                        )
                    ],
                ),
                idx==1?TextField(
                    keyboardType: TextInputType.number,
                    controller: countController,
                    onChanged: (String text) {
                        if(text.isEmpty) {
                            countError.value = 'Заполните поле';
                        }
                        else {
                            try {
                                int.parse(text);
                                countError.value = null;
                            }
                            catch(error) {
                                countError.value = 'Неверные данные';
                            }
                        }
                    },
                    decoration: InputDecoration(
                        labelText: 'Количество',
                        errorText: countError.value
                    )
                ):Container(),
                const SizedBox(height: 15),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                            ),
                            onPressed: close,
                            child: const Text('Закрыть'),
                        ),
                        const SizedBox(width: 15),
                        ElevatedButton(
                            onPressed: accept,
                            child: const Text('Добавить'),
                        ),
                    ],
                )
            ],
        );
    }
}