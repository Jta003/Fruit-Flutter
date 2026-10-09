import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'core/constants.dart';
import 'models/fruit.dart';
import 'providers/fruit_provider.dart';
import 'screens/home_screen.dart';
import 'screens/scan_screen.dart';
import 'screens/ar_scan_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/history_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/search_screen.dart';
import 'widgets/fruit_cards.dart';

late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // โหลดรายการกล้องที่มีในเครื่อง
  try {
    cameras = await availableCameras();
  } catch (e) {
    debugPrint('Error fetching cameras: $e');
    cameras = [];
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FruitProvider()..loadInitialData()),
      ],
      child: const FruitNutritionArApp(),
    ),
  );
}

class FruitNutritionArApp extends StatelessWidget {
  const FruitNutritionArApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fruit Nutrition AR',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.green,
          brightness: Brightness.light,
        ),
      ),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _tab = 0;
  bool _arMode = false; // false = Normal Scan, true = AR Scan

  Future<void> _openDetail(Fruit fruit) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DetailScreen(fruit: fruit)),
    );
  }

  void _openScan() {
    setState(() => _tab = 1);
  }

  @override
  Widget build(BuildContext context) {
    // เมื่ออยู่หน้า scan (tab=1) ให้แสดง mode toggle bar ด้านบน
    final Widget scanWidget = _arMode
        ? ArScanScreen(
            cameras: cameras,
            onClose: () => setState(() => _tab = 0),
            onDetected: (fruit) async {
              context.read<FruitProvider>().addScanHistory(fruit);
              await _openDetail(fruit);
            },
          )
        : ScanScreen(
            cameras: cameras,
            onClose: () => setState(() => _tab = 0),
            onDetected: (fruit) async {
              context.read<FruitProvider>().addScanHistory(fruit);
              await _openDetail(fruit);
            },
          );

    final pages = [
      HomeScreen(onScan: _openScan, onOpenFruit: _openDetail),
      scanWidget,
      HistoryScreen(onOpenFruit: _openDetail),
      const FavoritesScreen(),
      SearchScreen(onOpenFruit: _openDetail),
    ];

    return Scaffold(
      body: Stack(
        children: [
          pages[_tab],
          // Mode Toggle Bar (แสดงเฉพาะหน้า Scan)
          if (_tab == 1)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildScanModeToggle(),
            ),
        ],
      ),
      bottomNavigationBar: _tab == 1
          ? null
          : PremiumBottomNav(
              selectedIndex: _tab,
              onChanged: (value) => setState(() => _tab = value),
            ),
    );
  }

  /// Toggle bar สลับระหว่าง Normal Scan และ AR Scan
  Widget _buildScanModeToggle() {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(200),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withAlpha(40)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(100),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _modeTab(
              label: 'Normal Scan',
              icon: Icons.camera_alt_rounded,
              selected: !_arMode,
              onTap: () => setState(() => _arMode = false),
            ),
            _modeTab(
              label: 'AR Mode',
              icon: Icons.view_in_ar_rounded,
              selected: _arMode,
              onTap: () => setState(() => _arMode = true),
              isHighlight: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _modeTab({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
    bool isHighlight = false,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? (isHighlight ? AppColors.green : Colors.white.withAlpha(220))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: (isHighlight ? AppColors.green : Colors.white).withAlpha(80),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 17,
                color: selected
                    ? (isHighlight ? Colors.white : AppColors.greenDark)
                    : Colors.white.withAlpha(160),
              ),
              const SizedBox(width: 7),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: selected
                      ? (isHighlight ? Colors.white : AppColors.greenDark)
                      : Colors.white.withAlpha(160),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

