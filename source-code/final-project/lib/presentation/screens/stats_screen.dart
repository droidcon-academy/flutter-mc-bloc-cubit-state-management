import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/stats_bloc/stats_bloc.dart';
import '../../blocs/stats_bloc/stats_event.dart';
import '../../blocs/stats_bloc/stats_state.dart';
import '../../utils/constants.dart';
import '../../utils/show_snackbar.dart';
import '../widgets/message_widget.dart';
import '../widgets/month_picker_button.dart';
import '../widgets/transaction_card.dart';
import '../widgets/transaction_pie_chart.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  DateTime? currentSelectedDate;

  @override
  Widget build(BuildContext context) {
    // Trigger transaction loading once when the screen is first built
    context.read<StatsBloc>().add(const LoadStatsEvent());

    return BlocConsumer<StatsBloc, StatsState>(
      listener: (context, state) {
        if (state is StatsDeleteSuccessState) {
          context
              .read<StatsBloc>()
              .add(LoadStatsEvent(statsDate: currentSelectedDate));
          showSnackBar(context, state.statsDeleteSucessMessage);
        }
      },
      builder: (context, state) {
        return BlocBuilder<StatsBloc, StatsState>(
          builder: (context, state) {
            if (state is StatsLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is StatsLoadedState) {
              if (state.transactions.isEmpty && state.statsDates.isEmpty) {
                return const MessageWidget(
                  icon: Icons.calendar_month,
                  message: "No monthly stats available yet",
                );
              }

              if (state.transactions.isNotEmpty) {
                currentSelectedDate = state.transactions.first.date;
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(defaultSpacing),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MonthPickerButton(
                        statsDates: state.statsDates,
                        transactionDate: currentSelectedDate ?? DateTime.now(),
                        onDateSelected: (selectedDate) {
                          currentSelectedDate = selectedDate;
                          context
                              .read<StatsBloc>()
                              .add(StatsDateChangedEvent(selectedDate));
                        },
                      ),
                      const SizedBox(height: defaultSpacing),
                      state.transactions.isNotEmpty
                          ? Column(
                              children: [
                                TransactionPieChart(
                                    transactions: state.transactions),
                                const SizedBox(height: defaultSpacing),
                                ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: state.transactions.length,
                                    itemBuilder: (context, index) {
                                      return TransactionCard(
                                          transaction:
                                              state.transactions[index],
                                          onDelete: () {
                                            context.read<StatsBloc>().add(
                                                DeleteTransactionEvent(state
                                                    .transactions[index].id));
                                            // If that transaction was last for that month then show the previous latest month chart
                                            if (state.transactions.length ==
                                                1) {
                                              currentSelectedDate = null;
                                            }
                                          });
                                    }),
                              ],
                            )
                          : const SizedBox(
                              height: 400,
                              child: MessageWidget(
                                icon: Icons.playlist_remove_outlined,
                                message: "No stats available for this month",
                              ),
                            ),
                    ],
                  ),
                ),
              );
            } else if (state is StatsErrorState) {
              return MessageWidget(
                icon: Icons.error_rounded,
                message: state.errorMessage,
              );
            } else {
              return const MessageWidget(
                icon: Icons.broken_image,
                message: "Something Went Wrong",
              );
            }
          },
        );
      },
    );
  }
}
