import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../models/fruit.dart';
import '../providers/fruit_provider.dart';
import '../widgets/mock_widgets.dart';
import '../widgets/fruit_cards.dart';

import '../widgets/fruit_art.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key, required this.onOpenFruit});

  final ValueChanged<Fruit> onOpenFruit;

  void _showDeleteDialog(BuildContext context, int historyId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ลบประวัติ', style: titleStyle()),
        content: Text('คุณต้องการลบรายการนี้ใช่หรือไม่?', style: bodyStyle()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ยกเลิก', style: bodyStyle(color: AppColors.muted)),
          ),
          TextButton(
            onPressed: () {
              context.read<FruitProvider>().removeHistoryItem(historyId);
              Navigator.pop(context);
            },
            child: Text('ลบ', style: bodyStyle(color: AppColors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final historyItems = context.watch<FruitProvider>().history;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(32, 18, 32, 112),
        children: [
          const StatusBarMock(),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Scan History', style: titleStyle(size: 28)),
              if (historyItems.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.delete_sweep_rounded, color: AppColors.muted),
                  onPressed: () => context.read<FruitProvider>().clearAllHistory(),
                ),
            ],
          ),
          const SizedBox(height: 18),
          if (historyItems.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Column(
                  children: [
                    const Icon(Icons.history_rounded, size: 64, color: AppColors.border),
                    const SizedBox(height: 16),
                    Text('ยังไม่มีประวัติการสแกน', style: bodyStyle(color: AppColors.muted)),
                  ],
                ),
              ),
            )
          else
            ...historyItems.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: GestureDetector(
                  onLongPress: () => _showDeleteDialog(context, item.historyId),
                  child: HistoryRow(
                    fruit: item.fruit,
                    onTap: () => onOpenFruit(item.fruit),
                    // เพิ่มเวลาที่สแกนจริง
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ปรับปรุง HistoryRow ให้รับค่าเวลาเพิ่มเติม
class HistoryRowWithTime extends StatelessWidget {
  final Fruit fruit;
  final String scanTime;
  final VoidCallback onTap;

  const HistoryRowWithTime({
    super.key,
    required this.fruit,
    required this.scanTime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: premiumCardDecoration(radius: 24),
        child: Row(
          children: [
            SizedBox(width: 52, height: 52, child: FruitArt(kind: fruit.kind)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(fruit.name, style: titleStyle(size: 16)),
                  const SizedBox(height: 4),
                  Text(scanTime, style: bodyStyle(size: 13, color: AppColors.muted)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${fruit.score}', style: titleStyle(size: 18, color: AppColors.green)),
                Text('score', style: bodyStyle(size: 11, color: AppColors.muted)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
