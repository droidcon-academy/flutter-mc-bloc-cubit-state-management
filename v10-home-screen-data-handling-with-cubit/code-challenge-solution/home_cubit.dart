import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/summary_model.dart';
import '../../data/repositories/transaction_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final TransactionRepository transactionRepository;

  HomeCubit(this.transactionRepository) : super(HomeLoadingState());

  
  SummaryModel calculateSummary() {
    // Calculate total income, expenses, and balance
    double totalIncome = transactionRepository.getTotalIncome();
    double totalExpenses = transactionRepository.getTotalExpenses();
    double totalBalance = transactionRepository.getTotalBalance();
    return SummaryModel(
        totalIncome: totalIncome,
        totalExpenses: totalExpenses,
        totalBalance: totalBalance);
  }

 Future<void> loadTransactions() async {
    try {
      final transactions = transactionRepository.getLatestTransactions();
      final summary = calculateSummary();
      emit(HomeLoadedState(transactions, summary));
    } catch (e) {
      emit(HomeErrorState('Failed to load transactions'));
    }
  }
}
