import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class SaveSystem {
  Future<void> saveCategories(List<Map<String, dynamic>> categories) async {
    final file = await _categoriesFile;

    await file.writeAsString(jsonEncode(categories));
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

    var historytemp = await file.readAsString();
    var history = List<Map<String, dynamic>>.from(jsonDecode(historytemp));

    history.add({
      'categoryName': categoryName,
      'amount': amount,
      'date': DateTime.now().toString(),
    });

    await file.writeAsString(jsonEncode(history));
  }

  Future<List<Map<String, dynamic>>> readHistory() async {
    try {
      final file = await _historyFile;

      if (file.existsSync()) {
        String contents = await file.readAsString();
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
