import 'package:equatable/equatable.dart';

import '../../data/models/transaction_model.dart';

sealed class AddTransactionEvent extends Equatable {
  const AddTransactionEvent();

  @override
  List<Object> get props => [];
}

class SubmitTransactionEvent extends AddTransactionEvent {
  final TransactionModel transaction;
  const SubmitTransactionEvent(this.transaction);

  @override
  List<Object> get props => [transaction];
}
