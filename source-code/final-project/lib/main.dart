import 'package:blocify/blocs/add_transaction_bloc/add_transaction_bloc.dart';
import 'package:blocify/blocs/stats_bloc/stats_bloc.dart';
import 'package:blocify/config/routes/app_route.dart';
import 'package:blocify/config/theme/app_theme.dart';
import 'package:blocify/cubits/home_cubit/home_cubit.dart';
import 'package:blocify/data/repositories/transaction_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/models/transaction_model.dart';
import 'utils/category_model_adapter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive and register adapters
  await Hive.initFlutter();
  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(TransactionTypeAdapter());
  Hive.registerAdapter(TransactionModelAdapter());

  // Open Transaction Box
  Box<TransactionModel> transactionBox =
      await Hive.openBox<TransactionModel>('transactions');
  runApp(MyApp(transactionBox: transactionBox));
}

class MyApp extends StatelessWidget {
  final Box<TransactionModel> transactionBox;
  const MyApp({super.key, required this.transactionBox});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => TransactionRepository(transactionBox),
      child: MultiBlocProvider(
        providers: [
          // BlocProvider(create: (context) => LoadImageBloc()),
          // BlocProvider(create: (context) => LoadImageCubit()),
          BlocProvider(
              create: (context) =>
                  AddTransactionBloc(context.read<TransactionRepository>())),
          BlocProvider(
              create: (context) =>
                  HomeCubit(context.read<TransactionRepository>())),
          BlocProvider(
              create: (context) =>
                  StatsBloc(context.read<TransactionRepository>())),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Blocify',
          theme: appTheme,
          initialRoute: AppRoutes.dashboard,
          onGenerateRoute: AppRouter.onGenerateRoute,
        ),
      ),
    );
  }
}
