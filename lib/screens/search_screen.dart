import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../models/fruit.dart';
import '../providers/fruit_provider.dart';
import '../widgets/mock_widgets.dart';
import '../widgets/fruit_cards.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key, required this.onOpenFruit});

  final ValueChanged<Fruit> onOpenFruit;

  @override
  Widget build(BuildContext context) {
    final fruits = context.watch<FruitProvider>().fruits;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(32, 18, 32, 112),
        children: [
          const StatusBarMock(),
          const SizedBox(height: 28),
          Text('Search Fruits', style: titleStyle(size: 28)),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, color: AppColors.green),
                const SizedBox(width: 10),
                Text('Search nutrition...', style: bodyStyle(color: AppColors.muted)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ...fruits.map(
            (fruit) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: HistoryRow(fruit: fruit, onTap: () => onOpenFruit(fruit)),
            ),
          ),
        ],
      ),
    );
  }
}
