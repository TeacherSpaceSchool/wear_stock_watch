import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';

const List<String> list = <String>['Binance', 'Yahoo'];

class AddElementDialog extends HookWidget  {

    const AddElementDialog({super.key});

    @override
    Widget build(BuildContext context) {
        //name
        final TextEditingController nameController = useTextEditingController(text: '');
        final nameError = useState<String?>('Заполните поле');
        //type
        final type = useState<String>('Binance');
        //close
        close() => Navigator.pop(context);
        //accept
        accept() {
            if(nameController.text.isNotEmpty) {
                Navigator.pop(context, {'name': nameController.text, 'type': type.value});
            }
        }
        return Column(
            children: [
                Row(
                    children: [
                        Expanded(
                            child: TextField(
                                controller: nameController,
                                onChanged: (String text) {
                                    if(text.isEmpty) {
                                        nameError.value = 'Заполните поле';
                                    }
                                    else {
                                        nameError.value = null;
                                    }
                                },
                                decoration: InputDecoration(
                                    labelText: 'Название',
                                    errorText: nameError.value
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
                const SizedBox(height: 15),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                            ),
                            child: const Text('Закрыть'),
                            onPressed: close,
                        ),
                        const SizedBox(width: 15),
                        ElevatedButton(
                            child: const Text('Добавить'),
                            onPressed: accept,
                        ),
                    ],
                )
            ],
        );
    }
}