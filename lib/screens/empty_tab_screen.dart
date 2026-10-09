import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../widgets/mock_widgets.dart';

class EmptyTabScreen extends StatelessWidget {
  const EmptyTabScreen({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 18, 32, 112),
        child: Column(
          children: [
            const StatusBarMock(),
            const Spacer(),
            Container(
              width: 84,
              height: 84,
              decoration: const BoxDecoration(
                color: AppColors.lime,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.green, size: 38),
            ),
            const SizedBox(height: 20),
            Text(title, style: titleStyle(size: 26)),
            const SizedBox(height: 8),
            Text(message, style: bodyStyle(color: AppColors.muted)),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
