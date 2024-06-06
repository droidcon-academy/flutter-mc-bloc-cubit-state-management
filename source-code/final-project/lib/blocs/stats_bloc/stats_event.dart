import 'package:equatable/equatable.dart';

sealed class StatsEvent extends Equatable {
  const StatsEvent();

  @override
  List<Object> get props => [];
}

class LoadStatsEvent extends StatsEvent {
  final DateTime? statsDate;
  const LoadStatsEvent(this.statsDate);
}

class StatsDateChangedEvent extends StatsEvent {
  final DateTime statsDate;
  const StatsDateChangedEvent(this.statsDate);
}

class DeleteTransactionEvent extends StatsEvent {
  final int transactionId;
  const DeleteTransactionEvent(this.transactionId);
}
