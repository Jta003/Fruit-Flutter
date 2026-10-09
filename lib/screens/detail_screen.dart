import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../models/fruit.dart';
import '../providers/fruit_provider.dart';
import '../widgets/mock_widgets.dart';
import '../widgets/fruit_cards.dart';
import '../widgets/fruit_art.dart';
import '../widgets/fruit_selection_sheet.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.fruit});

  final Fruit fruit;

  @override
  Widget build(BuildContext context) {
    // ใช้ watch เพื่อให้ UI อัปเดตเมื่อสถานะ favorite เปลี่ยน
    final currentFruit = context.watch<FruitProvider>().fruits.firstWhere(
      (f) => f.id == fruit.id,
      orElse: () => fruit,
    );

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 252,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFDDF4C7), Color(0xFFFFE8B5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(26, 18, 26, 0),
                  child: Column(
                    children: [
                      const StatusBarMock(),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          CircleIconButton(
                            icon: Icons.arrow_back_ios_new_rounded,
                            onTap: () => Navigator.pop(context),
                          ),
                          const Spacer(),
                          Text('Nutrition Detail', style: titleStyle(size: 19)),
                          const Spacer(),
                          const SizedBox(width: 38),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                SizedBox(
                  width: 160,
                  height: 140,
                  child: FruitArt(kind: currentFruit.kind),
                ),
                Expanded(
                  child: DetailBottomSheet(fruit: currentFruit),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailBottomSheet extends StatelessWidget {
  const DetailBottomSheet({super.key, required this.fruit});

  final Fruit fruit;

  void _openComparison(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => FruitSelectionSheet(
        originalFruit: fruit,
        onSelected: (selectedFruit) {
          Navigator.pop(context); // ปิด Bottom Sheet
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CompareScreen(left: fruit, right: selectedFruit),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 28),
      decoration: const BoxDecoration(
        color: Color(0xFFFDFEFA),
        borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Center(
            child: Container(
              width: 66,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          const SizedBox(height: 26),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(fruit.name, style: titleStyle(size: 28)),
                  Text(fruit.scientificName, style: bodyStyle(color: AppColors.muted)),
                ],
              ),
              const Spacer(),
              CircleIconButton(
                icon: fruit.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                onTap: () => context.read<FruitProvider>().toggleFavorite(fruit),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'หน่วยบริโภค: ${fruit.servingSize}',
            style: bodyStyle(color: AppColors.greenDark, height: 1.4),
          ),
          const SizedBox(height: 22),
          HealthScoreCard(fruit: fruit),
          const SizedBox(height: 28),
          // แก้ไข: ใช้ GridView หรือ Row แบบไม่มี Expanded ภายใน ListView
          // หรือกำหนดความสูงที่แน่นอน
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              MetricCard(
                icon: Icons.local_fire_department_rounded,
                value: formatNumber(fruit.kcal),
                unit: 'kcal',
                label: 'Energy',
              ),
              MetricCard(
                icon: Icons.eco_rounded,
                value: formatNumber(fruit.fiber),
                unit: 'g',
                label: 'Fiber',
              ),
              MetricCard(
                icon: Icons.cake_rounded,
                value: formatNumber(fruit.sugar),
                unit: 'g',
                label: 'Sugar',
              ),
              MetricCard(
                icon: Icons.opacity_rounded,
                value: formatNumber(fruit.fat),
                unit: 'g',
                label: 'Fat',
              ),
            ],
          ),
          const SizedBox(height: 30),
          Text('Nutrition Facts (ต่อ 100g)', style: titleStyle(size: 18)),
          const SizedBox(height: 14),
          NutritionRow(label: 'Carbohydrate', value: '${formatNumber(fruit.carbs)} g'),
          NutritionRow(label: 'Protein', value: '${formatNumber(fruit.protein)} g'),
          NutritionRow(label: 'Fat', value: '${formatNumber(fruit.fat)} g'),
          NutritionRow(label: 'Vitamin C', value: '${formatNumber(fruit.vitaminC)} mg'),
          const SizedBox(height: 20),
          PremiumButton(
            icon: Icons.compare_arrows_rounded,
            label: 'เปรียบเทียบกับผลไม้อื่น',
            onPressed: () => _openComparison(context),
          ),
        ],
      ),
    );
  }
}

class CompareScreen extends StatefulWidget {
  final Fruit left;
  final Fruit right;

  const CompareScreen({super.key, required this.left, required this.right});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  late Fruit _left;
  late Fruit _right;

  @override
  void initState() {
    super.initState();
    _left = widget.left;
    _right = widget.right;
  }

  void _changeFruit(bool isLeft) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => FruitSelectionSheet(
        originalFruit: isLeft ? _right : _left,
        onSelected: (selectedFruit) {
          setState(() {
            if (isLeft) {
              _left = selectedFruit;
            } else {
              _right = selectedFruit;
            }
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(32, 18, 32, 112),
          children: [
            const StatusBarMock(),
            const SizedBox(height: 18),
            Row(
              children: [
                CircleIconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => Navigator.pop(context),
                ),
                const Spacer(),
                Text('Compare Fruits', style: titleStyle(size: 22)),
                const Spacer(),
                const SizedBox(width: 38),
              ],
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _changeFruit(true),
                    child: CompareFruitCard(fruit: _left),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: AppColors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        'VS',
                        style: titleStyle(size: 13, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _changeFruit(false),
                    child: CompareFruitCard(fruit: _right),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 34),
            Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
              decoration: premiumCardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nutrition comparison', style: titleStyle(size: 18)),
                  const SizedBox(height: 24),
                  CompareBar(label: 'Energy', left: _left.kcal, right: _right.kcal, unit: ''),
                  CompareBar(label: 'Fiber', left: _left.fiber, right: _right.fiber, unit: 'g'),
                  CompareBar(label: 'Sugar', left: _left.sugar, right: _right.sugar, unit: 'g'),
                  CompareBar(label: 'Vitamin C', left: _left.vitaminC, right: _right.vitaminC, unit: 'mg'),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: premiumCardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('AI Insight', style: titleStyle(size: 15, color: AppColors.greenDark)),
                  const SizedBox(height: 8),
                  Text(
                    '${_left.name} เหมาะกว่าเมื่อเน้นพลังงานต่ำ ส่วน ${_right.name} เหมาะก่อนออกกำลังกาย',
                    style: bodyStyle(height: 1.35),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
