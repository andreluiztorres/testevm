import 'package:flutter/material.dart';
import 'exam_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Organizar Números',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ExamApi api = ExamApiImpl();
  List<int>? numbers;
  bool? isOrdered;

  void fetchNumbers(int quantity) {
    setState(() {
      numbers = api.getRandomNumbers(quantity);
      isOrdered = null;
    });
  }

  void validateOrder() {
    setState(() {
      isOrdered = api.checkOrder(numbers!);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isOrdered!
            ? 'Os números estão em ordem crescente!'
            : 'Os números NÃO estão em ordem crescente!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Organizar Números')),
      body: numbers == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final quantity = await showDialog<int>(
                        context: context,
                        builder: (_) => const QuantityDialog(),
                      );
                      if (quantity != null) fetchNumbers(quantity);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                      backgroundColor: const Color.fromARGB(255, 174, 2, 2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: const Text('Gerar Números',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255))),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text('by André Luiz Torres',
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: Card(
                    margin: const EdgeInsets.all(36),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ReorderableListView(
                        onReorder: (oldIndex, newIndex) {
                          setState(() {
                            if (newIndex > oldIndex) newIndex -= 1;
                            final item = numbers!.removeAt(oldIndex);
                            numbers!.insert(newIndex, item);
                          });
                        },
                        children: numbers!
                            .asMap()
                            .map((i, num) => MapEntry(
                                i,
                                ListTile(
                                  key: ValueKey(num),
                                  title: Text('$num'),
                                )))
                            .values
                            .toList(),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: validateOrder,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                    backgroundColor: const Color.fromARGB(255, 174, 2, 2),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: const Text('Validar Ordem',
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                    backgroundColor: const Color.fromARGB(255, 174, 2, 2),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: const Text('Reiniciar',
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
    );
  }
}

class QuantityDialog extends StatefulWidget {
  const QuantityDialog({super.key});

  @override
  _QuantityDialogState createState() => _QuantityDialogState();
}

class _QuantityDialogState extends State<QuantityDialog> {
  int quantity = 5;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Informe a quantidade'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Escolha a quantidade de números aleatórios:'),
          Slider(
            activeColor: const Color.fromARGB(255, 186, 1, 1),
            value: quantity.toDouble(),
            min: 1,
            max: 20,
            divisions: 19,
            label: quantity.toString(),
            onChanged: (value) {
              setState(() {
                quantity = value.toInt();
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, quantity),
          child: const Text('Confirmar'),
        ),
      ],
    );
  }
}
