import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CategoryDetailsPage extends StatefulWidget {
  final Map<String, dynamic> category;

  const CategoryDetailsPage({super.key, required this.category});

  @override
  State<CategoryDetailsPage> createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
  final TextEditingController amountController = TextEditingController();

  int touchedIndex = -1;

  double percentageCurrentAmount = 0;
  String currentAmount = '';
  double percentageGoal = 0;
  String goal = '';

  @override
  void initState() {
    super.initState();
    _updatePercentages();
  }

  void _updatePercentages() {
    setState(() {
      percentageCurrentAmount =
          (widget.category['startingAmount'] / widget.category['goal']) * 100;
      currentAmount = percentageCurrentAmount.toStringAsFixed(1);
      if (percentageCurrentAmount > 100) {
        percentageCurrentAmount = 100;
      } else if (percentageCurrentAmount < 0) {
        percentageCurrentAmount = 0;
      }

      percentageGoal = 100 - percentageCurrentAmount;
      goal = percentageGoal.toStringAsFixed(1);
      if (percentageGoal < 0) {
        percentageGoal = 0;
      } else if (percentageGoal > 100) {
        percentageGoal = 100;
      }
    });
  }

  void _addOrRemoveMoney(double amount) {
    setState(() {
      widget.category['startingAmount'] += amount;
      _updatePercentages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 400,
              child: Stack(
                children: <Widget>[
                  PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      centerSpaceRadius: 120,
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 0,
                      sections: [
                        PieChartSectionData(
                          value: percentageCurrentAmount,
                          color: Colors.grey,
                          radius: 55,
                          title: '$currentAmount%',
                          titleStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          value: percentageGoal,
                          color: const Color.fromARGB(255, 75, 75, 75),
                          radius: 50,
                          title: '$goal%',
                          titleStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Meta: R\$ ${widget.category['goal'].toStringAsFixed(2)}",
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                  ),
                        ),
                        Text(
                          "Saldo Atual: R\$ ${widget.category['startingAmount'].toStringAsFixed(2)}",
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              ElevatedButton(
                onPressed: () => _showAddOrRemoveDialog(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Adicionar Valor"),
              ),
              ElevatedButton(
                onPressed: () => _showAddOrRemoveDialog(context, false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Remover Valor"),
              )
            ])
          ],
        ),
      ),
    );
  }

  void _showAddOrRemoveDialog(BuildContext context, bool isAddingMoney) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Adicionar/Remover Valor"),
        content: TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Valor"),
        ),
        actions: [
          isAddingMoney
              ? TextButton(
                  onPressed: () {
                    final amount =
                        double.tryParse(amountController.text) ?? 0.0;
                    _addOrRemoveMoney(amount);
                    Navigator.of(context).pop();
                  },
                  child: const Text("Adicionar"),
                )
              : TextButton(
                  onPressed: () {
                    final amount =
                        -(double.tryParse(amountController.text) ?? 0.0);
                    _addOrRemoveMoney(amount);
                    Navigator.of(context).pop();
                  },
                  child: const Text("Remover"),
                ),
        ],
      ),
    );
  }
}
