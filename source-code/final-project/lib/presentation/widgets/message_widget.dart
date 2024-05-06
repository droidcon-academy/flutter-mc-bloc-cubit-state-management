import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class MessageWidget extends StatelessWidget {
  final IconData icon;
  final String message;
  final double iconSize;
  final double messageFontSize;

  const MessageWidget({
    super.key,
    required this.icon,
    required this.message,
    this.iconSize = defaultIconSize,
    this.messageFontSize = defaultFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: iconSize, color: Colors.grey),
          const SizedBox(height: defaultSpacing),
          Text(
            message,
            style: TextStyle(fontSize: messageFontSize),
          ),
        ],
      ),
    );
  }
}
