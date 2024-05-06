import 'package:blocify/data/repositories/transaction_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_transaction_event.dart';
import 'add_transaction_state.dart';

class AddTransactionBloc
    extends Bloc<AddTransactionEvent, AddTransactionState> {
  TransactionRepository transactionRepository;

  AddTransactionBloc(this.transactionRepository)
      : super(AddTransactionInitial()) {
    on<SubmitTransactionEvent>((event, emit) async {
      emit(AddTransactionInProgress());
      try {
        await transactionRepository.addTransaction(event.transaction);
        emit(const AddTransactionSuccess("Transaction added successfully !"));
      } catch (e) {
        emit(AddTransactionError(e.toString()));
      }
    });
  }
}
