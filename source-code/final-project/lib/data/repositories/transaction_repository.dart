import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction_model.dart';

class TransactionRepository {
  late final Box<TransactionModel> _transactionBox;

  TransactionRepository(Box<TransactionModel> transactionBox) {
    _transactionBox = transactionBox;
  }

  // Add a new transaction with id key to the box
  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      if (transaction.amount > 0) {
        await _transactionBox.put(transaction.id, transaction);
      } else {
        throw Exception("Amount should be greater than 0");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Get all transactions from the hive box
  List<TransactionModel> getAllTransactions() {
    return _transactionBox.values.toList();
  }

  // To retrieve the latest 10 or custom number of transactions
  List<TransactionModel> getLatestTransactions({int count = 10}) {
    final allTransactions = getAllTransactions();
    final latestTransactions = allTransactions.reversed.take(count).toList();
    return latestTransactions;
  }

// Delete a transaction of a specific id
  Future<void> deleteTransaction(int transactionId) async {
    await _transactionBox.delete(transactionId);
  }

// Calculates and returns the total income amount from all transactions.
  double getTotalIncome() {
    final allTransactions = getAllTransactions();
    return allTransactions
        .where((transaction) => transaction.type == TransactionType.income)
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  // Calculates and returns the total expenses amount from all transactions.
  double getTotalExpenses() {
    final allTransactions = getAllTransactions();
    return allTransactions
        .where((transaction) => transaction.type == TransactionType.expense)
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  //  Computes the total balance by subtracting total expenses from total income.
  double getTotalBalance() {
    double totalIncome = getTotalIncome();
    double totalExpenses = getTotalExpenses();
    return totalIncome - totalExpenses;
  }

  // Retreive only the unique set of month-year in which atleast one transaction happened.
  Set<DateTime> getUniqueTransactionMonths() {
    final transactions = getAllTransactions();
    final uniqueMonths = <DateTime>{};
    for (var transaction in transactions) {
      final monthYear = DateTime(transaction.date.year, transaction.date.month);
      uniqueMonths.add(monthYear);
    }
    return uniqueMonths;
  }

  // Retreive transactions for a specified month, or if no date is provided then then latest month with transactions.
  // It filters transactions based on the specified month and sorts them chronologically.
  List<TransactionModel> getStatsTransactions({DateTime? statsDate}) {
    final transactions = getAllTransactions();

    // If statsDate is not provided, find the latest month with transactions
    if (statsDate == null) {
      // Get unique months from transactions
      final uniqueMonths = transactions
          .map((transaction) =>
              DateTime(transaction.date.year, transaction.date.month))
          .toSet();

      if (uniqueMonths.isEmpty) {
        // Handle case where no transactions are available
        return [];
      }

      // Find the latest month
      final latestMonth = uniqueMonths.reduce((a, b) => a.isAfter(b) ? a : b);

      // Use the latest month as the statsDate
      statsDate = latestMonth;
    }

    // Filter transactions for the specified statsDate
    final statsTransactions = transactions
        .where((transaction) =>
            transaction.date.year == statsDate!.year &&
            transaction.date.month == statsDate.month)
        .toList();

    // Sort transactions chronologically
    statsTransactions.sort((a, b) => a.date.compareTo(b.date));

    return statsTransactions;
  }
}
