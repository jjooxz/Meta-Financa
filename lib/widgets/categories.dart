// categories.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta_financa/widgets/view_category.dart';
import 'add_category_form.dart';
import 'package:meta_financa/const.dart';
import 'package:meta_financa/save_system.dart';


class Categories extends StatefulWidget {
  final SaveSystem saveSystem;
  const Categories({super.key, required this.saveSystem});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<Map<String, dynamic>> categories = [];
  // Usando saveSystem diretamente (sem o Future)
  late SaveSystem saveSystem;

  @override
  void initState() {
    super.initState();
    // Inicializando o saveSystem com o valor passado pelo widget
    saveSystem = widget.saveSystem;
    
    // Carregar as categorias inicializadas
    _loadCategories();

    // Atualiza as categorias a cada 2 segundos
    Timer.periodic(const Duration(seconds: 2), (timer) {
      _loadCategories();
    });
  }

  Future<void> _loadCategories() async {
    final loadedCategories = await saveSystem.readCategories();
    setState(() {
      categories = loadedCategories;
    });
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController startingAmountController = TextEditingController();
  final TextEditingController goalController = TextEditingController();

  Widget _showAddCategoryForm() {
    return AddCategoryForm(
      nameController: nameController,
      startingAmountController: startingAmountController,
      goalController: goalController,
      onAdd: _addCategory,
    );
  }

  void _deleteCategory(String name) {
    final index = categories.indexWhere((category) => category['name'] == name);
    if (index == -1) {
      // Lançar um erro ou mostrar uma mensagem caso a categoria não exista
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao encontrar categoria $name! Reinicie seu aplicativo e tente novamente."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      categories.removeAt(index);
      saveSystem.saveCategories(categories);
    });
  }


  void _addCategory() {
    Navigator.pop(context);
    if (nameController.text.isNotEmpty && goalController.text.isNotEmpty && startingAmountController.text.isNotEmpty) {
      setState(() {
        // Remove o símbolo de moeda e qualquer outro caractere não numérico
        var startingAmountText = startingAmountController.text.replaceAll(RegExp(r'[^\d,]'), '');
        startingAmountText = startingAmountText.replaceAll(RegExp(r'[,]'), '.');
        double startingAmountValue = double.tryParse(startingAmountText)!;

        var goalText = goalController.text.replaceAll(RegExp(r'[^\d,]'), '');
        goalText = goalText.replaceAll(RegExp(r'[,]'), '.');
        double goalValue = double.tryParse(goalText)!;

        categories.add({
          'name': nameController.text,
          'startingAmount': startingAmountValue,
          'goal': goalValue,
        });
        saveSystem.saveCategories(categories);
      });
      nameController.clear();
      startingAmountController.clear();
      goalController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).brightness == Brightness.light ? kBackgroundColorLight : kBackgroundColorDark;
    return Scaffold(   
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 40,
        backgroundColor: Theme.of(context).brightness == Brightness.light ? Color.fromARGB(255, 254, 247, 255) : Color.fromARGB(255, 20, 18, 24),
        title: Center(child: Text("Categorias", style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold))),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return categoryList(category, categories, context, _deleteCategory, saveSystem);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            context: context,
            backgroundColor: primaryColor,
            builder: (context2) {
              return _showAddCategoryForm();
            },
          );
        },
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}

Widget categoryList(Map<String, dynamic> category, List<Map<String, dynamic>> categories, BuildContext context, void Function(String) deleteCategory, SaveSystem saveSystem) {
  final bgColor = Theme.of(context).brightness == Brightness.light
      ? const Color.fromARGB(255, 90, 90, 90)
      : const Color.fromARGB(255, 105, 105, 105);
  final textColor = Theme.of(context).brightness == Brightness.light
      ? kTextColorDark
      : kTextColorDark;
  final isFirst = category == categories[0];

  return Container(
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).brightness == Brightness.light ? bgColor.withOpacity(0.6) : bgColor.withOpacity(0.2),
          offset: const Offset(10, 10),
          blurRadius: 7,
        ),
      ],
    ),
    margin: isFirst
        ? const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 6)
        : const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    child: ListTile(
      onTap: () {
        // Navegar para a página de detalhes da categoria
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryDetailsPage(
              category: category, // Passando a categoria correta
              save_system: saveSystem, // Passando o sistema de salvamento
            ),
          ),
        );
      },
      title: Text(category['name'], style: Theme.of(context).textTheme.titleLarge!.copyWith(color: textColor)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('R\$ ${category['startingAmount'].toStringAsFixed(2)} / R\$ ${category['goal'].toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleLarge!.copyWith(color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(
            width: 200,
            child: LinearProgressIndicator(
              value: category['startingAmount'] / category['goal'],
              backgroundColor: Colors.grey,
              valueColor: const AlwaysStoppedAnimation<Color>(kPrimaryColor),
            ),
          )
        ]
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => deleteCategory(category['name']),
          ),
        ],
      ),
    ),
  );
}