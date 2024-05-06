import 'package:flutter/material.dart';
import '../../presentation/screens/add_transaction_screen.dart';
import '../../presentation/screens/dashboard_screen.dart';

class AppRoutes {
  static const String dashboard = '/';
  static const String addTransaction = '/add_transaction';
}

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case AppRoutes.addTransaction:
        return MaterialPageRoute(
            builder: (_) => const AddTransactionScreen(),
            fullscreenDialog: true);
      default:
        // Navigate to an error screen
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                    body: Center(
                  child: Text(
                    "Something went wrong ! \n No route defined for '${settings.name}'",
                  ),
                )));
    }
  }
}
