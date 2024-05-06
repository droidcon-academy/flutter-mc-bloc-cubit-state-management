import 'package:equatable/equatable.dart';

import '../../data/models/summary_model.dart';
import '../../data/models/transaction_model.dart';

sealed class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeLoadingState extends HomeState {}

class HomeLoadedState extends HomeState {
  final List<TransactionModel> transactions;
  final SummaryModel summary;

  HomeLoadedState(this.transactions, this.summary);

  @override
  List<Object?> get props => [transactions, summary];
}

class HomeErrorState extends HomeState {
  final String errorMessage;

  HomeErrorState(this.errorMessage);
}

class HomeDeleteSuccessState extends HomeState {
  final String homeDeleteSucessMessage;

  HomeDeleteSuccessState(this.homeDeleteSucessMessage);
}
