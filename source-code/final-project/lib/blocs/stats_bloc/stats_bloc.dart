import 'package:blocify/blocs/stats_bloc/stats_event.dart';
import 'package:blocify/blocs/stats_bloc/stats_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/transaction_repository.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  TransactionRepository transactionRepository;

  StatsBloc(this.transactionRepository) : super(StatsLoadingState()) {
    on<LoadStatsEvent>((event, emit) async {
      try {
        emit(StatsLoadingState());
        final transactions = transactionRepository.getStatsTransactions(
            statsDate: event.statsDate);
        final statsDates = transactionRepository.getUniqueTransactionMonths();
        emit(StatsLoadedState(
            transactions: transactions, statsDates: statsDates));
      } catch (e) {
        emit(StatsErrorState(e.toString()));
      }
    });

    on<StatsDateChangedEvent>((event, emit) async {
      try {
        emit(StatsLoadingState());
        final transactions = transactionRepository.getStatsTransactions(
            statsDate: event.statsDate);
        final statsDates = transactionRepository.getUniqueTransactionMonths();
        emit(StatsLoadedState(
            transactions: transactions, statsDates: statsDates));
      } catch (e) {
        emit(StatsErrorState(e.toString()));
      }
    });

    on<DeleteTransactionEvent>((event, emit) async {
      try {
        await transactionRepository.deleteTransaction(event.transactionId);
        emit(const StatsDeleteSuccessState(
            "Transaction deleted successfully !"));
      } catch (e) {
        emit(StatsErrorState(e.toString()));
      }
    });
  }
}
