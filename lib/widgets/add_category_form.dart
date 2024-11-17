// add_category_form.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddCategoryForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController startingAmountController;
  final TextEditingController goalController;
  final VoidCallback onAdd;

  const AddCategoryForm({
    super.key,
    required this.nameController,
    required this.startingAmountController,
    required this.goalController,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
            height: 250,
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                TextField(
                  controller: nameController,
                  decoration:
                      const InputDecoration(labelText: 'Nome da Categoria'),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(20),
                  ],
                ),
                TextField(
                  controller: startingAmountController,
                  decoration: const InputDecoration(labelText: 'Valor Inicial'),
                  inputFormatters: [
                    CurrencyInputFormatter(),
                  ],
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: goalController,
                  decoration: const InputDecoration(labelText: 'Meta'),
                  inputFormatters: [
                    CurrencyInputFormatter(),
                  ],
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(
                  onPressed: onAdd,
                  child: const Text('Adicionar Categoria'),
                ),
              ],
            )
        )
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    // Verifique se o novo valor é um número válido
    final numericValue = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (numericValue.isEmpty) return oldValue;

    double value = double.parse(numericValue);

    // Formatação como moeda
    final formatter = NumberFormat.simpleCurrency(locale: "pt_BR", decimalDigits: 2);
    String newText = formatter.format(value/100);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class MyFilter extends TextInputFormatter {
  static final _reg = RegExp(r'^\d+$');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return _reg.hasMatch(newValue.text) ? newValue : oldValue;
  }
}
