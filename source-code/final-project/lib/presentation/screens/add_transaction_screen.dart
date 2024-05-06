import 'package:blocify/blocs/add_transaction_bloc/add_transaction_bloc.dart';
import 'package:blocify/blocs/add_transaction_bloc/add_transaction_state.dart';
import 'package:blocify/blocs/stats_bloc/stats_bloc.dart';
import 'package:blocify/data/models/category_model.dart';
import 'package:blocify/utils/category_list.dart';
import 'package:blocify/utils/constants.dart';
import 'package:blocify/utils/format_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/add_transaction_bloc/add_transaction_event.dart';
import '../../blocs/stats_bloc/stats_event.dart';
import '../../cubits/home_cubit/home_cubit.dart';
import '../../data/models/transaction_model.dart';
import '../../utils/show_snackbar.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  TransactionType _selectedType = TransactionType.expense; // Initial type
  CategoryModel _selectedCategory =
      expenseCategoryList.first; // Initial Category
  DateTime _selectedDate = DateTime.now(); // Initial Date
  int _transactionId =
      DateTime.now().millisecondsSinceEpoch % (1 << 28); // Generate ID
  final TextEditingController _amountController =
      TextEditingController(text: ""); // Initial amount

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(DateTime.now().year, 1,
          1), // Set firstDate to beginning of current year
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<CategoryModel>> categoryItems =
        _selectedType == TransactionType.expense
            ? expenseCategoryList
                .map((category) => _buildCategoryItem(category))
                .toList()
            : incomeCategoryList
                .map((category) => _buildCategoryItem(category))
                .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Transaction"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(defaultSpacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Transaction Type Radio Buttons
              Row(
                children: [
                  _buildRadioButton(TransactionType.expense, 'Expense'),
                  const SizedBox(width: defaultSpacing),
                  _buildRadioButton(TransactionType.income, 'Income'),
                ],
              ),
              const SizedBox(height: defaultSpacing),

              // Category Dropdown based on selected type
              DropdownButtonFormField<CategoryModel>(
                items: categoryItems,
                value: _selectedCategory,
                onChanged: (value) {
                  // Handle category selection
                  _selectedCategory = value!;
                },
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: defaultSpacing),

              // Amount Textfield
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Amount (\$)",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: defaultSpacing),

              TextButton(
                onPressed: () => _selectDate(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(defaultSpacing + 6.0),
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(defaultRadius / 2)),
                    side: BorderSide(color: Colors.black), // Add a border
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatDate(_selectedDate),
                      style: const TextStyle(
                          color: Colors.black, fontSize: defaultFontSize),
                    ),
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: defaultSpacing),

              // Submit Button
              BlocConsumer<AddTransactionBloc, AddTransactionState>(
                listener: (context, state) {
                  if (state is AddTransactionSuccess) {
                    context.read<HomeCubit>().loadTransactions();
                    context.read<StatsBloc>().add(const LoadStatsEvent());
                    showSnackBar(context, state.sucessMessage);
                    setState(() {
                      _amountController.text = "";
                      _selectedDate = DateTime.now();
                      _transactionId =
                          DateTime.now().millisecondsSinceEpoch % (1 << 28);
                    });
                  } else if (state is AddTransactionError) {
                    showSnackBar(context, state.errorMessage);
                  }
                },
                builder: (context, state) {
                  if (state is AddTransactionInProgress) {
                    return const CircularProgressIndicator();
                  }
                  return ElevatedButton(
                    onPressed: () {
                      // Check for only integar or decimal input. No signs.
                      if (RegExp(r'^[0-9]+(\.[0-9]+)?$')
                              .hasMatch(_amountController.text) &&
                          _amountController.text.trim().isNotEmpty) {
                        TransactionModel transaction = TransactionModel(
                            id: _transactionId,
                            amount: double.parse(_amountController.text),
                            category: _selectedCategory,
                            type: _selectedType,
                            date: _selectedDate);
                        context
                            .read<AddTransactionBloc>()
                            .add(SubmitTransactionEvent(transaction));
                      } else {
                        showSnackBar(
                            context, "Only Integer and decimal amount allowed");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColorDark,
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                          fontSize: defaultFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioButton(TransactionType type, String label) {
    return Row(
      children: [
        Radio(
          value: type,
          groupValue: _selectedType,
          activeColor: Theme.of(context).primaryColor,
          onChanged: (TransactionType? value) {
            setState(() {
              _selectedType = value!;
              _selectedCategory = value == TransactionType.expense
                  ? expenseCategoryList.first
                  : incomeCategoryList.first;
            });
          },
        ),
        Text(label),
      ],
    );
  }

  DropdownMenuItem<CategoryModel> _buildCategoryItem(CategoryModel category) {
    return DropdownMenuItem(
      value: category,
      child: Row(
        children: [
          Icon(category.icon, color: category.color),
          const SizedBox(width: defaultSpacing / 2),
          Text(category.name),
        ],
      ),
    );
  }
}
