import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta_financa/save_system.dart';

class History extends StatefulWidget {
  final SaveSystem saveSystem;

  // Recebendo SaveSystem como parâmetro
  const History({super.key, required this.saveSystem});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  // Usando o saveSystem passado pelo widget
  late SaveSystem saveSystem;

  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    // Inicializando o saveSystem com o valor passado pelo widget
    saveSystem = widget.saveSystem;
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final loadedHistory = await saveSystem.readHistory();
    setState(() {
      // Ordenando a lista de histórico para ter os mais recentes no topo
      history = loadedHistory;
      history.sort((a, b) {
        DateTime dateA = DateTime.parse(a['date']); // Assumindo que 'date' está em formato ISO 8601
        DateTime dateB = DateTime.parse(b['date']);
        return dateB.compareTo(dateA); // Ordem decrescente (mais recente primeiro)
      });

      Timer.periodic(const Duration(seconds: 2), (timer) {
        _loadHistory();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 40,
        backgroundColor: Theme.of(context).brightness == Brightness.light ? Color.fromARGB(255, 254, 247, 255) : Color.fromARGB(255, 20, 18, 24),
        title: Center(child: Text("Histórico", style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold))),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: history.length,
          itemBuilder: (context, index) {
            return Container(
              child: ListTile(
                title: Text("Categoria: ${history[index]['categoryName']}"),
                subtitle: Text("R\$ ${history[index]['amount'].toStringAsFixed(2)}"),
              ),
            );
          },
        ),
      ),
    );
  }
}
