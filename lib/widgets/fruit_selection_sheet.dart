import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../models/fruit.dart';
import '../providers/fruit_provider.dart';
import 'fruit_art.dart';

class FruitSelectionSheet extends StatelessWidget {
  final Fruit originalFruit;
  final Function(Fruit) onSelected;

  const FruitSelectionSheet({
    super.key,
    required this.originalFruit,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final fruits = context.watch<FruitProvider>().fruits;
    // กรองผลไม้ออกตัวหนึ่งเพื่อไม่ให้เปรียบเทียบตัวเดิม
    final comparisonOptions = fruits.where((f) => f.id != originalFruit.id).toList();

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('เลือกผลไม้เพื่อเปรียบเทียบ', style: titleStyle(size: 20)),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: comparisonOptions.length,
              separatorBuilder: (_, _) => const Divider(color: AppColors.border),
              itemBuilder: (context, index) {
                final fruit = comparisonOptions[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: SizedBox(
                    width: 48,
                    height: 48,
                    child: FruitArt(kind: fruit.kind),
                  ),
                  title: Text(fruit.name, style: titleStyle(size: 16)),
                  subtitle: Text('${fruit.kcal} kcal', style: bodyStyle(color: AppColors.muted)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: () => onSelected(fruit),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
