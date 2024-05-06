import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../data/models/transaction_model.dart';

class TransactionPieChart extends StatelessWidget {
  final List<TransactionModel> transactions;

  const TransactionPieChart({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate total income and total expense from transactions list
    double totalIncome = 0;
    double totalExpense = 0;

    for (var transaction in transactions) {
      if (transaction.type == TransactionType.income) {
        totalIncome += transaction.amount;
      } else if (transaction.type == TransactionType.expense) {
        totalExpense += transaction.amount;
      }
    }

    return SizedBox(
      height: 300,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: totalIncome,
              title: 'Income\n\$${totalIncome.toStringAsFixed(2)}',
              color: Colors.green,
              radius: 70,
              titleStyle: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
            PieChartSectionData(
              value: totalExpense,
              title: 'Expense\n-\$${totalExpense.toStringAsFixed(2)}',
              color: Colors.red,
              radius: 70,
              titleStyle: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
