import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'category_model.dart';
part 'transaction_model.g.dart';

@HiveType(typeId: 0)
enum TransactionType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense
}

@HiveType(typeId: 1)
class TransactionModel extends HiveObject with EquatableMixin {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final double amount;
  @HiveField(2)
  final CategoryModel category;
  @HiveField(3)
  final TransactionType type;
  @HiveField(4)
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.category,
    required this.type,
    required this.date,
  });

  @override
  List<Object?> get props => [id, amount, category, type, date];
}
