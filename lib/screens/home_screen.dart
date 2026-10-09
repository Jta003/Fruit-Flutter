import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../models/fruit.dart';
import '../providers/fruit_provider.dart';
import '../widgets/mock_widgets.dart';
import '../widgets/fruit_art.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.onScan,
    required this.onOpenFruit,
  });

  final VoidCallback onScan;
  final ValueChanged<Fruit> onOpenFruit;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedGoalIndex = 0;

  final List<String> _goals = [
    '✨ ทั้งหมด',
    '🛡️ ภูมิคุ้มกัน',
    '⚡ เพิ่มพลังงาน',
    '🥗 คุมน้ำหนัก',
    '🍒 ต้านอนุมูลอิสระ',
  ];

  @override
  Widget build(BuildContext context) {
    final fruitProvider = context.watch<FruitProvider>();
    final fruits = fruitProvider.fruits;
    final history = fruitProvider.history;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 110),
        children: [
          const StatusBarMock(),
          const SizedBox(height: 20),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.lime,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.auto_awesome_rounded, size: 13, color: AppColors.greenDark),
                        const SizedBox(width: 4),
                        Text(
                          'AI Fruit & Nutrition',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.greenDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('Fruit Scanner', style: titleStyle(size: 26)),
                  const SizedBox(height: 4),
                  Text(
                    'สแกนผลไม้จริง วิเคราะห์โภชนาการอัจฉริยะ',
                    style: bodyStyle(color: AppColors.muted, size: 13),
                  ),
                ],
              ),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: softShadow(),
                  border: Border.all(color: AppColors.border),
                ),
                child: Center(
                  child: IconButton(
                    icon: const Icon(Icons.qr_code_scanner_rounded, color: AppColors.green),
                    onPressed: widget.onScan,
                    tooltip: 'เปิดกล้องสแกน',
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // 1. AI Scan Hero Banner (แทนที่ Daily fruit balance แบบเดิม)
          _buildScanHeroBanner(fruits.length, history.length),

          const SizedBox(height: 28),

          // 2. Smart Recommendations Section (ขยายใหญ่ & มีข้อมูลเชิงลึก)
          _buildSmartRecommendationSection(fruits),

          const SizedBox(height: 28),

          // 3. Recent Scan History (ประวัติการสแกนจริง)
          _buildRecentScanSection(history, fruits),

          const SizedBox(height: 28),

          // 4. Explore All Fruits (สำรวจผลไม้ทั้ง 9 ชนิด)
          _buildAllFruitsSection(fruits, fruitProvider.isLoading),
        ],
      ),
    );
  }

  /// AI Scan Hero Banner แถบหลักสำหรับกดสแกนและดูสถานะ
  Widget _buildScanHeroBanner(int totalFruits, int scanCount) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF228B58), Color(0xFF135A37)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF228B58).withAlpha(80),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(40),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      'AI Vision Ready ($totalFruits ผลไม้)',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'สแกนแล้ว $scanCount ครั้ง',
                style: TextStyle(
                  color: Colors.white.withAlpha(200),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'สแกนผลไม้จริงด้วยกล้อง',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'ส่องกล้องไปที่ผลไม้เพื่อวิเคราะห์แคลอรี น้ำตาล และวิตามินทันที',
            style: TextStyle(
              color: Colors.white.withAlpha(220),
              fontSize: 13,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: widget.onScan,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.greenDark,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: AppColors.lime,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.center_focus_strong_rounded, size: 18, color: AppColors.greenDark),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'กดเพื่อเริ่มสแกนผลไม้ (Start AR Scan)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.greenDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ส่วน Smart Recommendations แนะนำผลไม้ตามโภชนาการและเป้าหมายสุขภาพ
  Widget _buildSmartRecommendationSection(List<Fruit> fruits) {
    // ข้อมูลคำแนะนำโภชนาการอัจฉริยะผูกกับผลไม้ที่มีในฐานข้อมูล
    final recommendations = [
      {
        'kind': FruitKind.kiwi,
        'tag': '🛡️ บูสต์ภูมิคุ้มกันสูงสุด',
        'goal': 1, // ภูมิคุ้มกัน
        'title': 'กีวี (Kiwi) ซูเปอร์ฟรุตวิตามินซี',
        'desc': 'วิตามิน C สูงถึง 92.7 mg (สูงกว่าส้ม 2 เท่า) ทานเพียง 1 ผลได้รับวิตามินซีเพียงพอตลอดวัน ช่วยสร้างภูมิคุ้มกันและบำรุงผิวพรรณ',
        'highlight': 'Vitamin C 92.7 mg',
        'badgeColor': const Color(0xFF6B9900),
      },
      {
        'kind': FruitKind.banana,
        'tag': '⚡ พลังงานก่อน/หลังออกกำลังกาย',
        'goal': 2, // พลังงาน
        'title': 'กล้วยหอม เติมพลังทันใจ',
        'desc': 'คาร์โบไฮเดรตย่อยง่าย 31 g และโพแทสเซียมสูง ช่วยป้องกันการเกิดตะคริวและฟื้นฟูกล้ามเนื้อได้อย่างรวดเร็ว',
        'highlight': 'Carbs 31 g • 132 kcal',
        'badgeColor': const Color(0xFFD49A00),
      },
      {
        'kind': FruitKind.chickoo,
        'tag': '🥗 ไฟเบอร์สูง อิ่มท้องนาน',
        'goal': 3, // คุมน้ำหนัก
        'title': 'ละมุด (Chickoo) เพื่อระบบย่อยอาหาร',
        'desc': 'มีไฟเบอร์ธรรมชาติสูงถึง 5.3 g สูงที่สุดในกลุ่มผลไม้ ช่วยให้ระบบขับถ่ายทำงานคล่องตัวและทำให้อิ่มท้องได้ยาวนาน',
        'highlight': 'Fiber 5.3 g',
        'badgeColor': const Color(0xFF9E652E),
      },
      {
        'kind': FruitKind.apple,
        'tag': '❤️ สุขภาพหัวใจ & แคลอรีต่ำ',
        'goal': 3, // คุมน้ำหนัก
        'title': 'แอปเปิลแดง ของว่างแคลอรีต่ำ',
        'desc': 'เพียง 52 kcal อุดมไปด้วยสารเพกติน (Pectin) ช่วยลดคอเลสเตอรอลและควบคุมระดับน้ำตาลในเลือดหลังอาหาร',
        'highlight': 'Low Kcal (52 kcal)',
        'badgeColor': const Color(0xFFD63B38),
      },
      {
        'kind': FruitKind.cherry,
        'tag': '🍒 สารต้านอนุมูลอิสระ & ฟื้นฟูการนอน',
        'goal': 4, // ต้านอนุมูลอิสระ
        'title': 'เชอร์รี คืนความสดชื่นชะลอวัย',
        'desc': 'อุดมด้วยสารแอนโทไซยานินและเมลาโทนินตามธรรมชาติ ช่วยลดการอักเสบในเซลล์และช่วยให้นอนหลับได้สนิทยิ่งขึ้น',
        'highlight': 'Antioxidants • Score 90',
        'badgeColor': const Color(0xFFB5173F),
      },
    ];

    // กรองตาม Goal ที่ผู้ใช้เลือก
    final filtered = _selectedGoalIndex == 0
        ? recommendations
        : recommendations.where((r) => r['goal'] == _selectedGoalIndex).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: AppColors.lime,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.lightbulb_rounded, color: AppColors.green, size: 18),
                ),
                const SizedBox(width: 8),
                Text('Smart Recommendations', style: titleStyle(size: 18)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.green.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'AI Suggest',
                style: TextStyle(
                  color: AppColors.green,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'คำแนะนำโภชนาการตามเป้าหมายสุขภาพเฉพาะคุณ',
          style: bodyStyle(color: AppColors.muted, size: 13),
        ),
        const SizedBox(height: 14),

        // แถบเลือกเป้าหมายสุขภาพ (Health Goal Filter Chips)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(_goals.length, (index) {
              final isSelected = _selectedGoalIndex == index;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(_goals[index]),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedGoalIndex = index);
                    }
                  },
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.text,
                  ),
                  backgroundColor: Colors.white,
                  selectedColor: AppColors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: BorderSide(
                      color: isSelected ? AppColors.green : AppColors.border,
                    ),
                  ),
                  showCheckmark: false,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                ),
              );
            }),
          ),
        ),

        const SizedBox(height: 14),

        // รายการการ์ดคำแนะนำ
        Column(
          children: filtered.map((rec) {
            final targetKind = rec['kind'] as FruitKind;
            final matchedFruit = fruits.firstWhere(
              (f) => f.kind == targetKind,
              orElse: () => fruits.isNotEmpty ? fruits.first : const Fruit(
                name: 'ผลไม้',
                scientificName: '',
                kind: FruitKind.apple,
                kcal: 50,
                fiber: 2,
                sugar: 10,
                carbs: 12,
                protein: 0.5,
                fat: 0.2,
                vitaminC: 10,
                score: 85,
                servingSize: '1 ผล',
              ),
            );

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => widget.onOpenFruit(matchedFruit),
                borderRadius: BorderRadius.circular(22),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: premiumCardDecoration(radius: 22),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // รูปผลไม้
                      Container(
                        width: 64,
                        height: 64,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: FruitArt(kind: matchedFruit.kind),
                      ),
                      const SizedBox(width: 14),
                      // ข้อมูลโภชนาการและคำแนะนำ
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: (rec['badgeColor'] as Color).withAlpha(25),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      rec['tag'] as String,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: rec['badgeColor'] as Color,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.lime,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${matchedFruit.score}/100',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.greenDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              rec['title'] as String,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              rec['desc'] as String,
                              style: const TextStyle(
                                fontSize: 12,
                                height: 1.35,
                                color: AppColors.muted,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.bolt_rounded, size: 14, color: AppColors.orange),
                                    const SizedBox(width: 3),
                                    Text(
                                      rec['highlight'] as String,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.greenDark,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text(
                                      'ดูข้อมูลโภชนาการ',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.green,
                                      ),
                                    ),
                                    Icon(Icons.chevron_right_rounded, size: 15, color: AppColors.green),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// ส่วนประวัติการสแกนล่าสุด (Recent Scan)
  Widget _buildRecentScanSection(List dynamicHistory, List<Fruit> fruits) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.history_rounded, size: 20, color: AppColors.green),
                const SizedBox(width: 8),
                Text('Recent Scans', style: titleStyle(size: 18)),
              ],
            ),
            if (dynamicHistory.isNotEmpty)
              Text(
                'ทั้งหมด (${dynamicHistory.length})',
                style: bodyStyle(color: AppColors.muted, size: 12),
              ),
          ],
        ),
        const SizedBox(height: 12),

        if (dynamicHistory.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: premiumCardDecoration(radius: 20),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.lime,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt_outlined, color: AppColors.green),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ยังไม่มีประวัติการสแกน',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'กดปุ่มสแกนด้านบนเพื่อส่องผลไม้ชิ้นแรกของคุณ',
                        style: bodyStyle(color: AppColors.muted, size: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        else
          SizedBox(
            height: 130,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: dynamicHistory.length > 6 ? 6 : dynamicHistory.length,
              separatorBuilder: (_, i) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = dynamicHistory[index];
                final fruit = item.fruit as Fruit;
                return GestureDetector(
                  onTap: () => widget.onOpenFruit(fruit),
                  child: Container(
                    width: 110,
                    padding: const EdgeInsets.all(10),
                    decoration: premiumCardDecoration(radius: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 48, height: 48, child: FruitArt(kind: fruit.kind)),
                        const SizedBox(height: 6),
                        Text(
                          fruit.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${item.scanTime ?? ''}',
                          style: TextStyle(fontSize: 10, color: AppColors.muted),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  /// ส่วนสำรวจผลไม้ทั้งหมด 9 ชนิดในระบบ
  Widget _buildAllFruitsSection(List<Fruit> fruits, bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Explore All Fruits (${fruits.length})', style: titleStyle(size: 18)),
            Text(
              'แตะเพื่อดูคุณค่าอาหาร',
              style: bodyStyle(color: AppColors.muted, size: 12),
            ),
          ],
        ),
        const SizedBox(height: 14),

        if (isLoading)
          const Center(child: CircularProgressIndicator(color: AppColors.green))
        else
          SizedBox(
            height: 128,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: fruits.length,
              separatorBuilder: (_, i) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final fruit = fruits[index];
                return GestureDetector(
                  onTap: () => widget.onOpenFruit(fruit),
                  child: Container(
                    width: 106,
                    padding: const EdgeInsets.all(10),
                    decoration: premiumCardDecoration(radius: 22),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 48, height: 48, child: FruitArt(kind: fruit.kind)),
                        const SizedBox(height: 8),
                        Text(
                          fruit.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.lime,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${fruit.kcal.toInt()} kcal',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.greenDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
