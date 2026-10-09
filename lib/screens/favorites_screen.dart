import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../models/fruit.dart';
import '../providers/fruit_provider.dart';
import '../widgets/mock_widgets.dart';
import '../widgets/fruit_art.dart';
import '../widgets/custom_painters.dart';
import 'detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FruitProvider>().favorites;

    return SafeArea(
      child: favorites.isEmpty
          ? _buildEmptyState()
          : _buildFavoritesList(context, favorites),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(32, 18, 32, 112),
      children: [
        const StatusBarMock(),
        const SizedBox(height: 28),
        _buildHeader(),
        const SizedBox(height: 60),
        Center(
          child: Column(
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: const BoxDecoration(
                  color: AppColors.lime,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite_border_rounded,
                  size: 52,
                  color: AppColors.green,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'ยังไม่มีรายการโปรด',
                style: titleStyle(size: 20),
              ),
              const SizedBox(height: 10),
              Text(
                'กดไอคอน ❤️ ในหน้าข้อมูลผลไม้\nเพื่อบันทึกไว้ที่นี่',
                textAlign: TextAlign.center,
                style: bodyStyle(color: AppColors.muted, size: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFavoritesList(BuildContext context, List<Fruit> favorites) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 112),
      children: [
        const StatusBarMock(),
        const SizedBox(height: 28),
        _buildHeader(),
        const SizedBox(height: 6),
        Text(
          '${favorites.length} รายการที่บันทึกไว้',
          style: bodyStyle(color: AppColors.muted, size: 13),
        ),
        const SizedBox(height: 20),
        _buildSummaryBar(favorites),
        const SizedBox(height: 24),
        ...List.generate(favorites.length, (index) {
          final fruit = favorites[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _FavoriteCard(fruit: fruit),
          );
        }),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE4E8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.favorite_rounded, size: 13, color: Color(0xFFD63B38)),
              SizedBox(width: 4),
              Text(
                'รายการโปรดของฉัน',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD63B38),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text('My Favorites', style: titleStyle(size: 26)),
      ],
    );
  }

  Widget _buildSummaryBar(List<Fruit> favorites) {
    final avgKcal = favorites.isEmpty
        ? 0.0
        : favorites.map((f) => f.kcal).reduce((a, b) => a + b) /
            favorites.length;
    final avgScore = favorites.isEmpty
        ? 0.0
        : favorites.map((f) => f.score.toDouble()).reduce((a, b) => a + b) /
            favorites.length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF0F0), Color(0xFFFFE4E8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFD0D6)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryStatItem(
              icon: Icons.local_fire_department_rounded,
              iconColor: AppColors.orange,
              label: 'เฉลี่ย kcal',
              value: '${avgKcal.toStringAsFixed(0)} kcal',
            ),
          ),
          Container(
              width: 1, height: 36, color: const Color(0xFFFFD0D6)),
          Expanded(
            child: _SummaryStatItem(
              icon: Icons.star_rounded,
              iconColor: const Color(0xFFD49A00),
              label: 'คะแนนเฉลี่ย',
              value: '${avgScore.toStringAsFixed(0)}/100',
            ),
          ),
          Container(
              width: 1, height: 36, color: const Color(0xFFFFD0D6)),
          Expanded(
            child: _SummaryStatItem(
              icon: Icons.favorite_rounded,
              iconColor: const Color(0xFFD63B38),
              label: 'รายการ',
              value: '${favorites.length} ชนิด',
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryStatItem extends StatelessWidget {
  const _SummaryStatItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.muted),
        ),
      ],
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  const _FavoriteCard({required this.fruit});

  final Fruit fruit;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<FruitProvider>();

    return Dismissible(
      key: ValueKey(fruit.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFD63B38).withAlpha(230),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.heart_broken_rounded, color: Colors.white, size: 26),
            SizedBox(height: 4),
            Text(
              'นำออก',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      onDismissed: (_) => provider.toggleFavorite(fruit),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => DetailScreen(fruit: fruit)),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: softShadow(),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              // Fruit Art
              Container(
                width: 64,
                height: 64,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: FruitArt(kind: fruit.kind),
              ),
              const SizedBox(width: 14),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            fruit.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(Icons.favorite_rounded,
                            size: 16, color: Color(0xFFD63B38)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      fruit.scientificName,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.muted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _NutriBadge(
                          label: '${fruit.kcal.toInt()} kcal',
                          color: AppColors.orange,
                          bgColor: const Color(0xFFFFF3E0),
                        ),
                        _NutriBadge(
                          label: 'C ${fruit.vitaminC.toStringAsFixed(0)} mg',
                          color: AppColors.green,
                          bgColor: AppColors.lime,
                        ),
                        _NutriBadge(
                          label: '⭐ ${fruit.score}',
                          color: const Color(0xFFD49A00),
                          bgColor: const Color(0xFFFFF8DC),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Score ring
              CustomPaint(
                size: const Size(42, 42),
                painter: ScoreRingPainter(progress: fruit.score / 100),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NutriBadge extends StatelessWidget {
  const _NutriBadge({
    required this.label,
    required this.color,
    required this.bgColor,
  });

  final String label;
  final Color color;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
