import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class SaveSystem {
  Future<void> saveCategories(List<Map<String, dynamic>> categories) async {
    final file = await _categoriesFile;

    // Carrega as categorias existentes
    List<Map<String, dynamic>> existingCategories = [];
    try {
      String contents = await file.readAsString();
      existingCategories = List<Map<String, dynamic>>.from(jsonDecode(contents));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    // Substitui a categoria modificada pela categoria nova
    for (var updatedCategory in categories) {
      int index = existingCategories.indexWhere((category) =>
          category['name'] == updatedCategory['name']);
      if (index != -1) {
        existingCategories[index] = updatedCategory; // Atualiza a categoria
      } else {
        existingCategories.add(updatedCategory); // Se não encontrar, adiciona a nova categoria
      }
    }

    // Salva as categorias de volta no arquivo
    await file.writeAsString(jsonEncode(existingCategories));
  }

  Future<List<Map<String, dynamic>>> readCategories() async {
    try {
      final file = await _categoriesFile;

      String contents = await file.readAsString();
      return List<Map<String, dynamic>>.from(jsonDecode(contents));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  Future<void> saveHistory(String categoryName, double amount) async {
    final file = await _historyFile;

    // Verifica se o arquivo existe, caso contrário cria
    if (!file.existsSync()) {
      await file.create(recursive: true);
      await file.writeAsString(jsonEncode([])); // Inicializa o arquivo com uma lista vazia
    }

    // Lê o conteúdo do arquivo
    var historytemp = await file.readAsString();

    // Se o arquivo estiver vazio, inicialize uma lista vazia
    if (historytemp.isEmpty) {
      historytemp = '[]'; // Inicializa o arquivo com uma lista vazia
    }

    // Converte para lista de mapas
    var history = List<Map<String, dynamic>>.from(jsonDecode(historytemp));

    // Adiciona o novo histórico
    history.add({
      'categoryName': categoryName,
      'amount': amount,
      'date': DateTime.now().toString(),
    });

    // Grava no arquivo
    await file.writeAsString(jsonEncode(history));
  }

  Future<List<Map<String, dynamic>>> readHistory() async {
    try {
      final file = await _historyFile;

      // Verifica se o arquivo existe e contém dados
      if (file.existsSync()) {
        String contents = await file.readAsString();

        // Se o conteúdo estiver vazio, retorna uma lista vazia
        if (contents.isEmpty) {
          return [];
        }

        // Converte o conteúdo para lista de mapas
        return List<Map<String, dynamic>>.from(jsonDecode(contents));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return [];
  }

  Future<File> get _categoriesFile async {
    final path = await _localPath;
    final directory = Directory(path);
    if (!directory.existsSync()) {
      await directory.create(recursive: true);
    }
    return File('$path/categories.json');
  }

  Future<File> get _historyFile async {
    final path = await _localPath;
    final directory = Directory(path);
    if (!directory.existsSync()) {
      await directory.create(recursive: true);
    }
    return File('$path/history.json');
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
