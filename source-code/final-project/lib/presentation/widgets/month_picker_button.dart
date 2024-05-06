import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';

import '../../utils/format_date.dart';

class MonthPickerButton extends StatelessWidget {
  final DateTime transactionDate;
  final Set<DateTime> statsDates;
  final Function(DateTime) onDateSelected;

  const MonthPickerButton({
    super.key,
    required this.transactionDate,
    required this.statsDates,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Determine minimum and maximum month-year values
    DateTime minDate =
        statsDates.reduce((min, curr) => min.isBefore(curr) ? min : curr);
    DateTime maxDate =
        statsDates.reduce((max, curr) => max.isAfter(curr) ? max : curr);

    return ElevatedButton(
      onPressed: () {
        showMonthPicker(
          context,
          firstYear: minDate.year,
          lastYear: maxDate.year,
          firstEnabledMonth: minDate.month,
          lastEnabledMonth: maxDate.month,
          initialSelectedMonth: transactionDate.month,
          initialSelectedYear: transactionDate.year,
          highlightColor: Colors.black,
          onSelected: (month, year) {
            onDateSelected(DateTime(year, month));
          },
        );
      },
      child: Text(
        'Selected Month: ${formatDateByMonth(transactionDate)}',
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }
}
