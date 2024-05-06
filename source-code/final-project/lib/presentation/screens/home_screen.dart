import 'package:blocify/cubits/home_cubit/home_cubit.dart';
import 'package:blocify/cubits/home_cubit/home_state.dart';
import 'package:blocify/presentation/widgets/transaction_card.dart';
import 'package:blocify/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/constants.dart';
import '../widgets/message_widget.dart';
import '../widgets/summary_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger transaction loading once when the screen is first built
    context.read<HomeCubit>().loadTransactions();

    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is HomeDeleteSuccessState) {
          context.read<HomeCubit>().loadTransactions();
          showSnackBar(context, state.homeDeleteSucessMessage);
        }
      },
      builder: (context, state) {
        if (state is HomeLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is HomeLoadedState) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(defaultSpacing),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SummaryCard(
                    label: "Total balance",
                    amount: "\$${state.summary.totalBalance}",
                    icon: Icons.account_balance,
                    color: primaryDark,
                  ),
                  const SizedBox(
                    height: defaultSpacing,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: SummaryCard(
                        label: "Income",
                        amount: "\$${state.summary.totalIncome}",
                        icon: Icons.arrow_upward_rounded,
                        color: secondaryDark,
                      )),
                      const SizedBox(
                        width: defaultSpacing,
                      ),
                      Expanded(
                          child: SummaryCard(
                        label: "Expense",
                        amount: "-\$${state.summary.totalExpenses}",
                        icon: Icons.arrow_downward_rounded,
                        color: accentColor,
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: defaultSpacing * 2,
                  ),
                  Text(
                    "Recent Transactions",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: defaultSpacing,
                  ),
                  state.transactions.isEmpty
                      ? const SizedBox(
                          height: 250,
                          child: MessageWidget(
                            icon: Icons.money_off,
                            message: "No transactions added yet",
                          ))
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.transactions.length,
                          itemBuilder: (context, index) {
                            return TransactionCard(
                                transaction: state.transactions[index],
                                onDelete: () {
                                  context.read<HomeCubit>().deleteTransaction(
                                      state.transactions[index].id);
                                });
                          }),
                ],
              ),
            ),
          );
        } else if (state is HomeErrorState) {
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
  }
}
