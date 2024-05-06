import 'package:equatable/equatable.dart';
import '../../data/models/transaction_model.dart';

sealed class StatsState extends Equatable {
  const StatsState();

  @override
  List<Object> get props => [];
}

class StatsLoadingState extends StatsState {}

class StatsLoadedState extends StatsState {
  final List<TransactionModel> transactions;
  final Set<DateTime> statsDates;

  const StatsLoadedState(
      {required this.transactions, required this.statsDates});

  @override
  List<Object> get props => [transactions];
}

class StatsErrorState extends StatsState {
  final String errorMessage;

  const StatsErrorState(this.errorMessage);
}

class StatsDeleteSuccessState extends StatsState {
  final String statsDeleteSucessMessage;

  const StatsDeleteSuccessState(this.statsDeleteSucessMessage);
}
