import 'package:intl/intl.dart';

String formatDate(DateTime dateTime){
  return DateFormat("d MMM, yyyy").format(dateTime);
}


String formatDateByMonth(DateTime dateTime){
  return DateFormat("MMM, y ").format(dateTime);
}