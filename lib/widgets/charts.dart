import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './chart_bar.dart';
import '../models/transaction.dart';

class Charts extends StatelessWidget {
  final List<Transaction> recentTransaction;

  Charts(this.recentTransaction);

  double get totalSpending {
    return groupedTransactionsValues.fold(0.0, (sum, tx) {
      return sum + tx['amount'];
    });
  }

  List<Map<String, Object>> get groupedTransactionsValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalAmount = 0;

      recentTransaction.forEach((tx) {
        if (tx.date.day == weekDay.day &&
            tx.date.month == weekDay.month &&
            tx.date.year == weekDay.year) {
          totalAmount += tx.amount;
        }
      });

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalAmount,
      };
    }).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionsValues.map((tx) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                label: tx['day'],
                amount: tx['amount'],
                amountPercent: totalSpending == 0.0
                    ? 0.0
                    : (tx['amount'] as double) / totalSpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
