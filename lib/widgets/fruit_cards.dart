import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../models/fruit.dart';
import 'fruit_art.dart';
import 'custom_painters.dart';

class HealthSummaryCard extends StatelessWidget {
  const HealthSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 178,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          colors: [Color(0xFFE9F8D8), Color(0xFFFFFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: softShadow(),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Daily fruit balance', style: bodyStyle(color: AppColors.greenDark)),
              const SizedBox(height: 8),
              Text('2 / 3 portions', style: titleStyle(size: 32)),
              const SizedBox(height: 8),
              Text('เหลืออีก 1 ส่วนสำหรับวันนี้', style: bodyStyle(color: AppColors.muted)),
            ],
          ),
          Positioned(
            right: 0,
            top: 6,
            child: CustomPaint(
              size: const Size(78, 78),
              painter: ScoreRingPainter(progress: .68),
            ),
          ),
          const Positioned(
            right: 58,
            bottom: 4,
            child: SizedBox(width: 78, height: 78, child: FruitArt(kind: FruitKind.apple)),
          ),
          const Positioned(
            right: 2,
            bottom: 2,
            child: SizedBox(width: 63, height: 63, child: FruitArt(kind: FruitKind.orange)),
          ),
        ],
      ),
    );
  }
}

class PremiumButton extends StatelessWidget {
  const PremiumButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          padding: const EdgeInsets.symmetric(horizontal: 18),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(46), // 0.18 * 255 = 46
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 21),
            ),
            const SizedBox(width: 18),
            Text(label, style: titleStyle(size: 17, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class FruitMiniCard extends StatelessWidget {
  const FruitMiniCard({super.key, required this.fruit, required this.onTap});

  final Fruit fruit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
        decoration: premiumCardDecoration(radius: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 57, height: 57, child: FruitArt(kind: fruit.kind)),
            const SizedBox(height: 8),
            Text(fruit.name, maxLines: 1, style: titleStyle(size: 13)),
            const SizedBox(height: 4),
            Text('${formatNumber(fruit.kcal)} kcal', style: bodyStyle(size: 11, color: AppColors.muted)),
          ],
        ),
      ),
    );
  }
}

class RecommendationCard extends StatelessWidget {
  const RecommendationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
      decoration: premiumCardDecoration(radius: 28),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(color: AppColors.lime, shape: BoxShape.circle),
            child: const Icon(Icons.check_rounded, color: AppColors.green),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Smart recommendation', style: titleStyle(size: 15)),
                const SizedBox(height: 6),
                Text('ทานแอปเปิ้ลเพิ่มพลังงานยามบ่าย', style: bodyStyle(size: 13, color: AppColors.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HealthScoreCard extends StatelessWidget {
  const HealthScoreCard({super.key, required this.fruit});

  final Fruit fruit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: premiumCardDecoration(),
      child: Row(
        children: [
          CustomPaint(
            size: const Size(68, 68),
            painter: ScoreRingPainter(progress: fruit.score / 100),
          ),
          const SizedBox(width: 22),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${fruit.score}/100', style: titleStyle(size: 24)),
                Text('Excellent Health Score', style: titleStyle(size: 14, color: AppColors.green)),
                const SizedBox(height: 6),
                Text(
                  'เหมาะสำหรับมื้อว่างระหว่างวัน\nน้ำตาลไม่สูง',
                  style: bodyStyle(size: 12, color: AppColors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.icon,
    required this.value,
    required this.unit,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String unit;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: premiumCardDecoration(radius: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: AppColors.lime, borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, size: 16, color: AppColors.green),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(label, style: bodyStyle(size: 13, color: AppColors.muted))),
            ],
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: value, style: titleStyle(size: 22)),
                TextSpan(text: ' $unit', style: bodyStyle(size: 13, color: AppColors.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NutritionRow extends StatelessWidget {
  const NutritionRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border))),
      child: Row(
        children: [
          Text(label, style: bodyStyle(size: 15, color: AppColors.muted)),
          const Spacer(),
          Text(value, style: titleStyle(size: 15)),
        ],
      ),
    );
  }
}

class CompareFruitCard extends StatelessWidget {
  const CompareFruitCard({super.key, required this.fruit});

  final Fruit fruit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: premiumCardDecoration(radius: 20),
      child: Column(
        children: [
          SizedBox(width: 60, height: 60, child: FruitArt(kind: fruit.kind)),
          const SizedBox(height: 8),
          Text(fruit.name, style: titleStyle(size: 14)),
          const SizedBox(height: 2),
          Text('${formatNumber(fruit.kcal)} kcal', style: bodyStyle(size: 12, color: AppColors.muted)),
        ],
      ),
    );
  }
}

class CompareBar extends StatelessWidget {
  const CompareBar({
    super.key,
    required this.label,
    required this.left,
    required this.right,
    required this.unit,
  });

  final String label;
  final num left;
  final num right;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final maxVal = math.max(left.toDouble(), right.toDouble());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(label, style: bodyStyle(size: 13, color: AppColors.muted))),
          SizedBox(width: 40, child: Text(formatNumber(left), style: titleStyle(size: 13), textAlign: TextAlign.right)),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(4)),
                ),
                FractionallySizedBox(
                  widthFactor: maxVal == 0 ? 0 : left / maxVal,
                  child: Container(
                    height: 8,
                    margin: const EdgeInsets.only(left: 12),
                    decoration: BoxDecoration(color: AppColors.green, borderRadius: BorderRadius.circular(4)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 50,
            child: Text(
              '${formatNumber(right)}$unit',
              style: titleStyle(size: 13, color: AppColors.greenDark),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryRow extends StatelessWidget {
  const HistoryRow({super.key, required this.fruit, required this.onTap, this.scanTime});

  final Fruit fruit;
  final VoidCallback onTap;
  final String? scanTime;

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
                  Text(scanTime ?? 'สแกนเมื่อสักครู่', style: bodyStyle(size: 13, color: AppColors.muted)),
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

class PremiumBottomNav extends StatelessWidget {
  const PremiumBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.home_filled, 'Home'),
      (Icons.qr_code_scanner_rounded, 'Scan'),
      (Icons.history_rounded, 'History'),
      (Icons.favorite_rounded, 'Fav'),
      (Icons.search_rounded, 'Search'),
    ];

    return Container(
      height: 98,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF17211C).withAlpha(15), // 0.06 * 255 = 15
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final isSelected = selectedIndex == i;
          return GestureDetector(
            onTap: () => onChanged(i),
            child: SizedBox(
              width: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.green.withAlpha(26) : Colors.transparent, // 0.1 * 255 = 26
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      items[i].$1,
                      color: isSelected ? AppColors.green : AppColors.muted,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    items[i].$2,
                    style: bodyStyle(
                      size: 11,
                      color: isSelected ? AppColors.green : AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
