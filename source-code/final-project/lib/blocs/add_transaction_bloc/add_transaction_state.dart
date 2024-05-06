import 'package:equatable/equatable.dart';

sealed class AddTransactionState extends Equatable {
  const AddTransactionState();

  @override
  List<Object> get props => [];
}

class AddTransactionInitial extends AddTransactionState {}

class AddTransactionInProgress extends AddTransactionState {}

class AddTransactionSuccess extends AddTransactionState {
  final String sucessMessage;

  const AddTransactionSuccess(this.sucessMessage);
}

class AddTransactionError extends AddTransactionState {
  final String errorMessage;

  const AddTransactionError(this.errorMessage);
}
