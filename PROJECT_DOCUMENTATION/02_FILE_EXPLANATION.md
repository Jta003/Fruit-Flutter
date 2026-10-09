# อธิบายไฟล์และโครงสร้างโปรเจกต์ Flutter

> ตรวจวันที่ 8 ตุลาคม 2569 เฉพาะ Flutter ตามขอบเขตที่ผู้ใช้ยืนยัน ไม่รวม source ของ Unity ไม่แก้ไขไฟล์เดิม รายการนี้แยกไฟล์ runtime, การตั้งค่า, สำเนาส่งต่อ และไฟล์สร้างอัตโนมัติออกจากกัน

## โครงสร้างที่ใช้จริง

```text
app_ar_v1/
  lib/
    main.dart
    core/        theme ฐานข้อมูล และ ML
    models/      Fruit และประวัติ
    providers/   สถานะผลไม้และประวัติ
    screens/     หน้าจอหลัก กล้อง รายละเอียดและเปรียบเทียบ
    widgets/     การ์ด ปุ่ม รูปผลไม้และ painter
  assets/        โมเดล TFLite และ labels
  test/          smoke test ของ Flutter
  android/       host และ build ของ Android
  ios/ macos/    host ของ Apple
  windows/ linux/ web/  host ของแพลตฟอร์มอื่น
  pubspec.yaml   dependencies และ asset bundle
  pubspec.lock   เวอร์ชันที่ resolve ไว้
  handover_bundle/ สำเนาส่งต่อ ไม่ใช่ entrypoint ปัจจุบัน
  PROJECT_DOCUMENTATION/ เอกสารชุดนี้
```

ทั้ง 21 ไฟล์ Dart ใน lib ตรวจตาม class, function และจุดเรียกใช้ด้านล่าง การมีไฟล์อยู่ไม่เท่ากับมีเมนูที่เรียกใช้ เช่น EmptyTabScreen และ CameraPreviewMock ไม่เชื่อมกับหน้าหลักปัจจุบัน

## 1 โค้ด Dart ทุกไฟล์ใน lib

### [lib/core/constants.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/constants.dart)

**หน้าที่:** ค่ากลางของหน้าจอ

AppColors กำหนดสี titleStyle/bodyStyle กำหนดตัวอักษร premiumCardDecoration และ softShadow ใช้ตกแต่งการ์ด formatNumber แสดงจำนวนเต็มโดยไม่เติมทศนิยมที่ไม่จำเป็น

**ส่วนที่ใช้:** หน้าจอและ widgets ที่ import theme

**Class/enum:** `AppColors`

**สัมพันธ์กับไฟล์ในโปรเจกต์:** เป็นโครงสร้างข้อมูลหรืออ่านผ่านแพ็กเกจภายนอก ไม่มี relative import เพิ่มเติม

### [lib/core/database_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/database_helper.dart)

**หน้าที่:** ฐานข้อมูล SQLite และข้อมูลเริ่มต้น

DatabaseHelper singleton เปิด fruit_nutrition_v4.db version 4 สร้าง fruits และ scan_history ใส่ผลไม้ 9 ชนิด readAllFruits แปลงแถวเป็น Fruit readHistory JOIN ผลไม้ คำสั่ง insert/delete/clear history และ updateFavorite อัปเดตข้อมูล _upgradeDB ลบทั้งสองตารางแล้วสร้างใหม่

**ส่วนที่ใช้:** FruitProvider เรียกใช้เพื่อโหลดและเปลี่ยนข้อมูล

**Class/enum:** `DatabaseHelper`

**Function สำคัญที่ประกาศ:** `_initDB`, `_upgradeDB`, `_createDB`, `_prepopulateData`, `readAllFruits`, `readHistory`, `insertHistory`, `deleteHistory`, `clearHistory`, `updateFavorite`

**สัมพันธ์กับไฟล์ในโปรเจกต์:** [lib/models/fruit.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/models/fruit.dart)

### [lib/core/detection_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/detection_helper.dart)

**หน้าที่:** ตัวช่วยจำแนกภาพและผลลัพธ์

FruitDetectionResult เก็บ label/index/confidence/source DetectionHelper singleton โหลด labels และลองโมเดลหลาย path initialize ML Kit สำรอง classifyImagePath อ่านไฟล์ crop และเลือก TFLite/ML Kit classifyDecodedImage เตรียม RGB และคะแนนสูงสุด processCameraFrame กับ _extract224x224Tensor รองรับเฟรม YUV/BGRA แต่ยังไม่ถูกเรียกต่อเนื่องจากหน้าสแกน dispose ปิด interpreter/labeler

**ส่วนที่ใช้:** ScanScreen และ ArScanScreen ใช้ถ่ายแล้วจำแนก

**Class/enum:** `FruitDetectionResult`, `DetectionHelper`

**Function สำคัญที่ประกาศ:** `toString`, `initialize`, `processCameraFrame`, `classifyImagePath`, `dispose`

**สัมพันธ์กับไฟล์ในโปรเจกต์:** เป็นโครงสร้างข้อมูลหรืออ่านผ่านแพ็กเกจภายนอก ไม่มี relative import เพิ่มเติม

### [lib/main.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/main.dart)

**หน้าที่:** จุดเริ่มแอปและตัวควบคุมการนำทาง

main โหลดรายการกล้อง สร้าง MultiProvider และ FruitProvider.loadInitialData จากนั้น FruitNutritionArApp สร้าง MaterialApp แบบ Material 3 AppShell เก็บแท็บและโหมดสแกน เปิด Detail ด้วย Navigator callback ของสองโหมดเริ่มบันทึก history โดยไม่ await แล้วเปิด Detail

**ส่วนที่ใช้:** ทุกหน้าจอผ่าน AppShell

**Class/enum:** `FruitNutritionArApp`, `AppShell`, `_AppShellState`

**Function สำคัญที่ประกาศ:** `build`, `_openDetail`, `_openScan`, `_buildScanModeToggle`, `_modeTab`

**สัมพันธ์กับไฟล์ในโปรเจกต์:** เป็นโครงสร้างข้อมูลหรืออ่านผ่านแพ็กเกจภายนอก ไม่มี relative import เพิ่มเติม

### [lib/models/fruit.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/models/fruit.dart)

**หน้าที่:** โครงสร้างผลไม้และชนิด

FruitKind มี 9 ค่า Fruit มีฟิลด์โภชนาการ ชื่อ id และ favorite fromJson แปลงข้อมูล SQLite score อ่านจาก healthScore และ copyWith เปลี่ยนเฉพาะ favorite

**ส่วนที่ใช้:** ทุกหน้าจอที่แสดงผลไม้และ DatabaseHelper

**Class/enum:** `FruitKind`, `Fruit`

**Function สำคัญที่ประกาศ:** `copyWith`, `fromJson`

**สัมพันธ์กับไฟล์ในโปรเจกต์:** เป็นโครงสร้างข้อมูลหรืออ่านผ่านแพ็กเกจภายนอก ไม่มี relative import เพิ่มเติม

### [lib/models/scan_history.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/models/scan_history.dart)

**หน้าที่:** โครงสร้างรายการประวัติ

ScanHistoryItem มี historyId, Fruit และ scanTime factory fromJson แปลงผล JOIN โดยใช้ Fruit.fromJson

**ส่วนที่ใช้:** FruitProvider และหน้าประวัติ/หน้าแรก

**Class/enum:** `ScanHistoryItem`

**สัมพันธ์กับไฟล์ในโปรเจกต์:** เป็นโครงสร้างข้อมูลหรืออ่านผ่านแพ็กเกจภายนอก ไม่มี relative import เพิ่มเติม

### [lib/providers/fruit_provider.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/providers/fruit_provider.dart)

**หน้าที่:** ข้อมูลร่วมและการแจ้งอัปเดต UI

FruitProvider ใช้ ChangeNotifier เก็บ _fruits/_history/_isLoading favorites กรอง isFavorite loadInitialData/loadHistory อ่านฐานข้อมูล addScanHistory จัดเวลาข้อความ removeHistoryItem/clearAllHistory ลบข้อมูล toggleFavorite เปลี่ยน Fruit และรายการ history ที่อ้างชนิดเดียวกันก่อน notifyListeners

**ส่วนที่ใช้:** Provider ที่ main สร้าง หน้าจออ่านผ่าน watch/read

**Class/enum:** `FruitProvider`

**Function สำคัญที่ประกาศ:** `loadInitialData`, `loadHistory`, `addScanHistory`, `removeHistoryItem`, `clearAllHistory`, `toggleFavorite`

**สัมพันธ์กับไฟล์ในโปรเจกต์:** [lib/models/fruit.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/models/fruit.dart), [lib/models/scan_history.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/models/scan_history.dart), [lib/core/database_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/database_helper.dart)

### [lib/screens/ar_scan_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/ar_scan_screen.dart)

**หน้าที่:** หน้าข้อมูลซ้อนบนกล้องแบบ 2D

ArScanScreen ใช้ CameraPreview และ CustomPainter พร้อม animation 4 ตัว _showArResult แสดงการ์ด ยังไม่ callback _confirmAndNavigate ยืนยันผลและรีเซ็ต _quickSelect ใช้ 0.99 _resetScan เริ่มใหม่ _MiniScoreRing วาด score ไม่มี AR session, plane หรือ anchor

**ส่วนที่ใช้:** AppShell แท็บ Scan เมื่อ _arMode=true ชื่อใน UI เป็น AR Mode

**Class/enum:** `ArScanScreen`, `_ArScanScreenState`, `_MiniScoreRing`

**Function สำคัญที่ประกาศ:** `initState`, `_initAnimations`, `_initializeCamera`, `_isSameFruitType`, `_findFruitMatch`, `_captureAndAnalyze`, `_showArResult`, `_quickSelect`, `_resetScan`, `_confirmAndNavigate`, `dispose`, `build`, `_buildVignette`, `_buildArFrame`, `_buildTopBar`, `_glassButton`, `_buildBottomControls`, `_buildArInfoCard`, `_buildCardHeader`, `_nutriStat`, `_healthScoreStat`, `paint`, `shouldRepaint`

**สัมพันธ์กับไฟล์ในโปรเจกต์:** [lib/core/constants.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/constants.dart), [lib/models/fruit.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/models/fruit.dart), [lib/providers/fruit_provider.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/providers/fruit_provider.dart), [lib/widgets/fruit_art.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/fruit_art.dart), [lib/widgets/ar_overlay_painter.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/ar_overlay_painter.dart), [lib/widgets/mock_widgets.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/mock_widgets.dart), [lib/core/detection_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/detection_helper.dart)

### [lib/screens/detail_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/detail_screen.dart)

**หน้าที่:** รายละเอียดและการเปรียบเทียบ

DetailScreen อ่าน Fruit ล่าสุดตาม id จาก Provider DetailBottomSheet แสดงชื่อหน่วยบริโภค score และสารอาหาร กดหัวใจได้ _openComparison เปิด sheet เลือกคู่ CompareScreen เก็บ _left/_right และ _changeFruit เปลี่ยนคู่ การ์ด AI Insight เป็นข้อความตามตำแหน่งซ้ายขวา ไม่คำนวณเงื่อนไขจากค่าพลังงาน

**ส่วนที่ใช้:** เปิดจาก Home/Search/History/Favorites/ผลสแกน

**Class/enum:** `DetailScreen`, `DetailBottomSheet`, `CompareScreen`, `_CompareScreenState`

**Function สำคัญที่ประกาศ:** `build`, `_openComparison`, `initState`, `_changeFruit`

**สัมพันธ์กับไฟล์ในโปรเจกต์:** [lib/core/constants.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/constants.dart), [lib/models/fruit.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/models/fruit.dart), [lib/providers/fruit_provider.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/providers/fruit_provider.dart), [lib/widgets/mock_widgets.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/mock_widgets.dart), [lib/widgets/fruit_cards.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/fruit_cards.dart), [lib/widgets/fruit_art.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/fruit_art.dart), [lib/widgets/fruit_selection_sheet.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/fruit_selection_sheet.dart)

### [lib/screens/empty_tab_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/empty_tab_screen.dart)

**หน้าที่:** หน้าสำรองแสดงข้อความว่าง

EmptyTabScreen รับ icon/title/message เพื่อสร้างหน้าแจ้งข้อมูล แต่ไม่พบการใช้ใน AppShell ปัจจุบัน

**ส่วนที่ใช้:** ยังไม่เชื่อมกับเมนูปัจจุบัน

**Class/enum:** `EmptyTabScreen`

**Function สำคัญที่ประกาศ:** `build`

**สัมพันธ์กับไฟล์ในโปรเจกต์:** [lib/core/constants.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/constants.dart), [lib/widgets/mock_widgets.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/mock_widgets.dart)

### [lib/screens/favorites_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/favorites_screen.dart)

**หน้าที่:** รายการโปรดและสถิติสรุป

FavoritesScreen watch favorites แสดง empty/list _buildSummaryBar คำนวณเฉลี่ย kcal และ score _FavoriteCard แตะเปิด Detail และ Dismissible นำออกด้วย toggleFavorite _SummaryStatItem/_NutriBadge แสดงค่าภายในหน้า

**ส่วนที่ใช้:** AppShell แท็บ 3

**Class/enum:** `FavoritesScreen`, `_SummaryStatItem`, `_FavoriteCard`, `_NutriBadge`

**Function สำคัญที่ประกาศ:** `build`, `_buildEmptyState`, `_buildFavoritesList`, `_buildHeader`, `_buildSummaryBar`

**สัมพันธ์กับไฟล์ในโปรเจกต์:** [lib/core/constants.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/constants.dart), [lib/models/fruit.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/models/fruit.dart), [lib/providers/fruit_provider.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/providers/fruit_provider.dart), [lib/widgets/mock_widgets.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/mock_widgets.dart), [lib/widgets/fruit_art.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/fruit_art.dart), [lib/widgets/custom_painters.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/custom_painters.dart)

### [lib/screens/history_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/history_screen.dart)

**หน้าที่:** ดูและลบประวัติ

HistoryScreen watch history กดค้างเปิด _showDeleteDialog ยืนยันลบรายรายการ กดปุ่มบนหัวล้างทั้งหมดทันที รายการจริงใช้ HistoryRow โดยไม่ส่ง scanTime จึงเห็นข้อความ fallback HistoryRowWithTime มี class แต่ไม่ใช้ในรายการปัจจุบัน

**ส่วนที่ใช้:** AppShell แท็บ 2

**Class/enum:** `HistoryScreen`, `HistoryRowWithTime`

**Function สำคัญที่ประกาศ:** `_showDeleteDialog`, `build`

**สัมพันธ์กับไฟล์ในโปรเจกต์:** [lib/core/constants.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/constants.dart), [lib/models/fruit.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/models/fruit.dart), [lib/providers/fruit_provider.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/providers/fruit_provider.dart), [lib/widgets/mock_widgets.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/mock_widgets.dart), [lib/widgets/fruit_cards.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/fruit_cards.dart), [lib/widgets/fruit_art.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/fruit_art.dart)

### [lib/screens/home_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/home_screen.dart)

**หน้าที่:** หน้าแรกและเนื้อหาแนะนำ

HomeScreen เป็น StatefulWidget เก็บหมวดเป้าหมาย สร้าง scan hero แสดงจำนวนผลไม้และประวัติ _buildSmartRecommendationSection กรองข้อความคงที่ _buildRecentScanSection แสดงสูงสุด 6 records และเวลา _buildAllFruitsSection แสดงรายการทั้งหมด callback เปิด Scan หรือ Detail

**ส่วนที่ใช้:** AppShell แท็บ 0

**Class/enum:** `HomeScreen`, `_HomeScreenState`

**Function สำคัญที่ประกาศ:** `build`, `_buildScanHeroBanner`, `_buildSmartRecommendationSection`, `_buildRecentScanSection`, `_buildAllFruitsSection`

**สัมพันธ์กับไฟล์ในโปรเจกต์:** [lib/core/constants.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/constants.dart), [lib/models/fruit.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/models/fruit.dart), [lib/providers/fruit_provider.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/providers/fruit_provider.dart), [lib/widgets/mock_widgets.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/mock_widgets.dart), [lib/widgets/fruit_art.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/fruit_art.dart)

### [lib/screens/scan_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/scan_screen.dart)

**หน้าที่:** หน้ากล้องและถ่ายภาพแบบปกติ

เริ่ม CameraController กล้องแรก medium ปิดเสียง initialize helper _captureAndAnalyze เรียก takePicture/classifyImagePath _findFruitMatch จับคู่ชื่อก่อนแล้วสำรองตาม index _selectFruit รอ 500 ms แล้วส่ง onDetected ปุ่มไฟฉาย torch/off และแถบเลือกเองที่ใช้ confidence 0.99 เมื่อไม่พร้อม UI เป็นหน้ากำลังโหลด

**ส่วนที่ใช้:** AppShell แท็บ Scan เมื่อ _arMode=false

**Class/enum:** `ScanScreen`, `_ScanScreenState`

**Function สำคัญที่ประกาศ:** `initState`, `_initializeCamera`, `_isSameFruitType`, `_findFruitMatch`, `_captureAndAnalyze`, `_selectFruit`, `dispose`, `build`

**สัมพันธ์กับไฟล์ในโปรเจกต์:** [lib/core/constants.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/constants.dart), [lib/models/fruit.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/models/fruit.dart), [lib/providers/fruit_provider.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/providers/fruit_provider.dart), [lib/widgets/mock_widgets.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/mock_widgets.dart), [lib/widgets/custom_painters.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/custom_painters.dart), [lib/widgets/fruit_art.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/fruit_art.dart), [lib/core/detection_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/detection_helper.dart)

### [lib/screens/search_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/search_screen.dart)

**หน้าที่:** รายการผลไม้ในแท็บ Search

SearchScreen watch fruits แล้วแสดง HistoryRow เพื่อเปิด Detail แถบ search ใช้ Text ไม่มีการรับคำค้นหรือกรอง query

**ส่วนที่ใช้:** AppShell แท็บ 4

**Class/enum:** `SearchScreen`

**Function สำคัญที่ประกาศ:** `build`

**สัมพันธ์กับไฟล์ในโปรเจกต์:** [lib/core/constants.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/constants.dart), [lib/models/fruit.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/models/fruit.dart), [lib/providers/fruit_provider.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/providers/fruit_provider.dart), [lib/widgets/mock_widgets.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/mock_widgets.dart), [lib/widgets/fruit_cards.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/fruit_cards.dart)

### [lib/widgets/ar_overlay_painter.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/ar_overlay_painter.dart)

**หน้าที่:** กรอบและเส้นบนภาพกล้อง

ArScanFramePainter รับ scanProgress/isDetected/pulseValue แล้ววาดเส้นสแกนหรือ pulse ArConnectorPainter วาดเส้นเชื่อมจากจุดที่ส่งเข้ามา เป็นพิกัด UI ไม่ได้ติดตามวัตถุในโลกจริง

**ส่วนที่ใช้:** ArScanScreen

**Class/enum:** `ArScanFramePainter`, `ArConnectorPainter`

**Function สำคัญที่ประกาศ:** `paint`, `shouldRepaint`

**สัมพันธ์กับไฟล์ในโปรเจกต์:** [lib/core/constants.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/constants.dart)

### [lib/widgets/custom_painters.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/custom_painters.dart)

**หน้าที่:** วงคะแนนและกรอบช่วยเล็ง

ScoreRingPainter วาดวงตาม progress และตรวจ shouldRepaint FocusRingPainter วาดกรอบจากขนาดหน้าจอ ไม่มีการหากรอบวัตถุจาก detector

**ส่วนที่ใช้:** HealthScoreCard/Favorites และ ScanScreen

**Class/enum:** `ScoreRingPainter`, `FocusRingPainter`

**Function สำคัญที่ประกาศ:** `paint`, `shouldRepaint`

**สัมพันธ์กับไฟล์ในโปรเจกต์:** [lib/core/constants.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/constants.dart)

### [lib/widgets/fruit_art.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/fruit_art.dart)

**หน้าที่:** รูปผลไม้สองมิติที่วาดด้วยโค้ด

FruitArt ใช้ CustomPaint และ FruitPainter เลือกวาดตาม FruitKind ทั้ง 9 ชนิด _apple ถึง _cherry ใช้ Canvas และ Paint รูปใน Flutter ไม่ได้โหลดภาพผลไม้จาก asset PNG และไม่ใช่โมเดล 3D

**ส่วนที่ใช้:** การ์ด Home/Detail/Compare/Favorites และรายการ

**Class/enum:** `FruitArt`, `FruitPainter`

**Function สำคัญที่ประกาศ:** `build`, `paint`, `_apple`, `_banana`, `_orange`, `_mango`, `_grapes`, `_strawberry`, `_kiwi`, `_chickoo`, `_cherry`, `shouldRepaint`

**สัมพันธ์กับไฟล์ในโปรเจกต์:** [lib/models/fruit.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/models/fruit.dart)

### [lib/widgets/fruit_cards.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/fruit_cards.dart)

**หน้าที่:** การ์ดและเมนูที่ใช้ซ้ำ

PremiumBottomNav สร้าง 5 แท็บ PremiumButton เป็นปุ่มหลัก MetricCard/NutritionRow แสดงค่าต่าง ๆ CompareFruitCard แสดงคู่ CompareBar ใช้ max(left,right) กำหนดความยาวแถบ HistoryRow ใช้ scanTime หรือข้อความ fallback HealthScoreCard ข้อความสุขภาพคงที่ HealthSummaryCard/RecommendationCard/FruitMiniCard เป็นส่วนประกอบเดิม ไม่พบเรียกจาก Home เวอร์ชันปัจจุบัน

**ส่วนที่ใช้:** รายละเอียด เปรียบเทียบ History/Search และ AppShell

**Class/enum:** `HealthSummaryCard`, `PremiumButton`, `FruitMiniCard`, `RecommendationCard`, `HealthScoreCard`, `MetricCard`, `NutritionRow`, `CompareFruitCard`, `CompareBar`, `HistoryRow`, `PremiumBottomNav`

**Function สำคัญที่ประกาศ:** `build`

**สัมพันธ์กับไฟล์ในโปรเจกต์:** [lib/core/constants.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/constants.dart), [lib/models/fruit.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/models/fruit.dart)

### [lib/widgets/fruit_selection_sheet.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/fruit_selection_sheet.dart)

**หน้าที่:** รายการเลือกคู่เปรียบเทียบ

FruitSelectionSheet อ่าน fruits แล้วตัด id ของ originalFruit ออก แต่ละ ListTile คืนผลผ่าน onSelected Detail ใช้ตัดชนิดแรก Compare ใช้ตัดอีกฝั่ง

**ส่วนที่ใช้:** DetailBottomSheet และ CompareScreen

**Class/enum:** `FruitSelectionSheet`

**Function สำคัญที่ประกาศ:** `build`

**สัมพันธ์กับไฟล์ในโปรเจกต์:** [lib/core/constants.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/constants.dart), [lib/models/fruit.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/models/fruit.dart), [lib/providers/fruit_provider.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/providers/fruit_provider.dart)

### [lib/widgets/mock_widgets.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/mock_widgets.dart)

**หน้าที่:** องค์ประกอบทั่วไปและส่วนจำลองเก่า

StatusBarMock ปัจจุบันคืน SizedBox สูง 12 เท่านั้น CircleIconButton ใช้ gesture และ blur เมื่อ isGlass GlassDetectionPill สร้างป้ายผล และ CameraPreviewMock สร้างพื้นหลังจำลอง ไม่พบสอง class หลังในหน้าสแกนปัจจุบัน

**ส่วนที่ใช้:** CircleIconButton และช่องว่าง StatusBarMock ใช้หลายหน้า

**Class/enum:** `StatusBarMock`, `CircleIconButton`, `GlassDetectionPill`, `CameraPreviewMock`

**Function สำคัญที่ประกาศ:** `build`

**สัมพันธ์กับไฟล์ในโปรเจกต์:** [lib/core/constants.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/constants.dart)

## 2 Assets ทุกไฟล์
โมเดลเป็นไฟล์ binary จึงตรวจขนาดและ SHA256 เทียบสำเนา ไม่อนุมาน accuracy หรือ tensor metadata จากชื่อไฟล์

| Path | หน้าที่และผู้ใช้ | ขนาด bytes | SHA256 |
|---|---|---:|---|
| [assets/labels.txt](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/assets/labels.txt) | ป้ายกำกับ 9 class โหลดผ่าน DetectionHelper | 136 | `52c565b58b0123a1e812506f11265a9ede13952804d52b94e37cf0b5086d8cbc` |
| [assets/model_unquant.tflite](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/assets/model_unquant.tflite) | โมเดล TFLite โหลดผ่าน DetectionHelper ตามลำดับ candidate | 2093132 | `e28a0735dff5c7e896ecfb433d6a756d1affcabb7f9b06d570139238bd1f7460` |
| [assets/models/fruit_model.tflite](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/assets/models/fruit_model.tflite) | โมเดล TFLite โหลดผ่าน DetectionHelper ตามลำดับ candidate | 2093132 | `e28a0735dff5c7e896ecfb433d6a756d1affcabb7f9b06d570139238bd1f7460` |
| [assets/models/labels.txt](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/assets/models/labels.txt) | ป้ายกำกับ 9 class โหลดผ่าน DetectionHelper | 136 | `52c565b58b0123a1e812506f11265a9ede13952804d52b94e37cf0b5086d8cbc` |

โมเดลสอง path มี hash ตรงกัน และ labels สอง path มี hash ตรงกัน candidate assets/fruit_model.tflite ถูกกล่าวถึงใน helper แต่ไม่มีไฟล์นี้ใน assets ที่ตรวจ ไม่ถือเป็น asset ที่ใช้งานได้

## 3 Configuration ของ root

| ไฟล์ | หน้าที่และความสัมพันธ์ |
|---|---|
| [pubspec.yaml](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/pubspec.yaml) | ชื่อ package/version, Dart constraint, dependencies, assets และ override win32 เป็นแหล่งหลักที่ Flutter อ่าน |
| [pubspec.lock](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/pubspec.lock) | เวอร์ชัน package ที่ resolve จริง ต่างจากช่วง ^ ใน pubspec.yaml |
| [analysis_options.yaml](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/analysis_options.yaml) | เปิด flutter_lints และ exclude handover_bundle จาก analyzer |
| [README.md](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/README.md) | README จาก template Flutter ยังไม่อธิบายฟีเจอร์จริง |
| [app_ar_v1.iml](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/app_ar_v1.iml) | ข้อมูล module สำหรับ IDE ไม่ใช่ business logic |
| [.metadata](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/.metadata) | Flutter template/migration revision และ platforms ไม่ใช่หลักฐานเวอร์ชัน SDK ที่ใช้อยู่จริง |
| [.gitignore](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/.gitignore) | รูปแบบไฟล์ที่ Git ไม่ติดตาม เช่น build และ cache |
| [.flutter-plugins-dependencies](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/.flutter-plugins-dependencies) | ไฟล์สร้างอัตโนมัติที่ Flutter บันทึก plugin/dependency ต่อ platform ไม่ใช่ source ของแอป |

## 4 Native host และ configuration ทุกแพลตฟอร์ม
ไฟล์ต่อไปนี้ตรวจในขอบเขต Flutter รวมรายการ source และไฟล์ประกอบที่อยู่จริง Native host คือโปรแกรมตัวห่อที่เปิด Flutter Engine บนแต่ละระบบ ไม่ใช่ระบบโภชนาการอีกชุด การมี host ไม่ยืนยันว่า plugin ทุกตัวรองรับ platform นั้น

| Path | หน้าที่ ความสัมพันธ์ และสถานะ |
|---|---|
| [android/.gitignore](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/android/.gitignore) | ไฟล์ประกอบแพลตฟอร์มที่ตรวจ inventory แล้ว ไม่พบ logic โภชนาการในไฟล์นี้ |
| [android/.kotlin/errors/errors-1789706261669.log](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/android/.kotlin/errors/errors-1789706261669.log) | ไฟล์ประกอบแพลตฟอร์มที่ตรวจ inventory แล้ว ไม่พบ logic โภชนาการในไฟล์นี้ |
| [android/app/build.gradle.kts](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/android/app/build.gradle.kts) | Build app Android namespace/applicationId com.example.app_ar_v1; JVM 17; noCompress tflite; SDK อิง Flutter; release ยังใช้ debug signing |
| [android/app/src/debug/AndroidManifest.xml](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/android/app/src/debug/AndroidManifest.xml) | Manifest ของ debug/profile เพิ่มสิทธิ์ INTERNET เพื่อเครื่องมือพัฒนา ไม่ใช่ backend ของแอป |
| [android/app/src/main/AndroidManifest.xml](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/android/app/src/main/AndroidManifest.xml) | ประกาศ CAMERA และ camera feature เชื่อม MainActivity ไม่มี ARCore metadata |
| [android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java) | สร้างอัตโนมัติ ลงทะเบียน plugin หรือรายชื่อ plugin สำหรับ native host ตรวจประเภทแต่ไม่ใช่โค้ดธุรกิจ |
| [android/app/src/main/kotlin/com/example/app_ar_v1/MainActivity.kt](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/android/app/src/main/kotlin/com/example/app_ar_v1/MainActivity.kt) | MainActivity สืบทอด FlutterActivity ไม่มี method channel เพิ่มเติม |
| [android/app/src/main/res/drawable/launch_background.xml](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/android/app/src/main/res/drawable/launch_background.xml) | พื้นหลังขณะเปิดแอปก่อน Flutter แสดงเฟรมแรก |
| [android/app/src/main/res/drawable-v21/launch_background.xml](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/android/app/src/main/res/drawable-v21/launch_background.xml) | พื้นหลังขณะเปิดแอปก่อน Flutter แสดงเฟรมแรก |
| [android/app/src/main/res/mipmap-hdpi/ic_launcher.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/android/app/src/main/res/mipmap-hdpi/ic_launcher.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [android/app/src/main/res/mipmap-mdpi/ic_launcher.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/android/app/src/main/res/mipmap-mdpi/ic_launcher.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [android/app/src/main/res/mipmap-xhdpi/ic_launcher.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/android/app/src/main/res/mipmap-xhdpi/ic_launcher.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [android/app/src/main/res/values/styles.xml](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/android/app/src/main/res/values/styles.xml) | Android launch/normal theme ผูกกับ Manifest แยกค่าตามกลางวันหรือกลางคืน |
| [android/app/src/main/res/values-night/styles.xml](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/android/app/src/main/res/values-night/styles.xml) | Android launch/normal theme ผูกกับ Manifest แยกค่าตามกลางวันหรือกลางคืน |
| [android/app/src/profile/AndroidManifest.xml](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/android/app/src/profile/AndroidManifest.xml) | Manifest ของ debug/profile เพิ่มสิทธิ์ INTERNET เพื่อเครื่องมือพัฒนา ไม่ใช่ backend ของแอป |
| [android/app_ar_v1_android.iml](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/android/app_ar_v1_android.iml) | ข้อมูล module ของ Android Studio/IDE ไม่ใช้เป็น runtime logic |
| [android/build.gradle.kts](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/android/build.gradle.kts) | ตั้ง repositories และย้าย build directory ออกไป root/build; มี clean task |
| [android/gradle/wrapper/gradle-wrapper.jar](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/android/gradle/wrapper/gradle-wrapper.jar) | Gradle wrapper binary ใช้ bootstrap build ไม่ใช่โมเดลผลไม้ |
| [android/gradle/wrapper/gradle-wrapper.properties](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/android/gradle/wrapper/gradle-wrapper.properties) | กำหนด Gradle 9.1.0 ผ่าน distributionUrl |
| [android/gradle.properties](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/android/gradle.properties) | JVM memory, AndroidX, flags ของ Kotlin/DSL และข้าม validation ความตรงกันของ JVM targets |
| [android/gradlew](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/android/gradlew) | Gradle wrapper launcher สำหรับ Unix/Windows ใช้ wrapper jar/properties |
| [android/gradlew.bat](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/android/gradlew.bat) | Gradle wrapper launcher สำหรับ Unix/Windows ใช้ wrapper jar/properties |
| [android/local.properties](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/android/local.properties) | path SDK/Flutter ของเครื่องและข้อมูล build ที่เครื่องมือใช้ ไม่มีความหมายเป็น config พกพา |
| [android/settings.gradle.kts](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/android/settings.gradle.kts) | โหลด Flutter Gradle loader 1.0.0, AGP 9.0.1 และ Kotlin 2.3.20 ผ่าน SDK จาก local.properties |
| [ios/.gitignore](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/.gitignore) | ไฟล์ประกอบแพลตฟอร์มที่ตรวจ inventory แล้ว ไม่พบ logic โภชนาการในไฟล์นี้ |
| [ios/Flutter/AppFrameworkInfo.plist](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Flutter/AppFrameworkInfo.plist) | metadata ของ Flutter framework สำหรับ iOS packaging |
| [ios/Flutter/Debug.xcconfig](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Flutter/Debug.xcconfig) | ตั้งค่า build ของ Flutter/Xcode ตาม Debug/Release หรือ warnings |
| [ios/Flutter/flutter_export_environment.sh](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Flutter/flutter_export_environment.sh) | สร้างอัตโนมัติ environment script ของ Flutter build ไม่ใช่ runtime feature |
| [ios/Flutter/Generated.xcconfig](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Flutter/Generated.xcconfig) | สร้างอัตโนมัติ path SDK/build จาก Flutter ไม่บันทึกค่าของเครื่องเป็นข้อเท็จจริงที่พกพาได้ |
| [ios/Flutter/Release.xcconfig](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Flutter/Release.xcconfig) | ตั้งค่า build ของ Flutter/Xcode ตาม Debug/Release หรือ warnings |
| [ios/Runner/AppDelegate.swift](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner/AppDelegate.swift) | AppDelegate เปิด Flutter และ register plugin ผ่าน implicit engine delegate |
| [ios/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json) | รายการไฟล์ขนาดและ scale ของ Apple asset catalog |
| [ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@1x.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@1x.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1x.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1x.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3x.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3x.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@1x.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@1x.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1x.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1x.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [ios/Runner/Assets.xcassets/LaunchImage.imageset/Contents.json](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner/Assets.xcassets/LaunchImage.imageset/Contents.json) | รายการไฟล์ขนาดและ scale ของ Apple asset catalog |
| [ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@2x.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@2x.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@3x.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@3x.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [ios/Runner/Assets.xcassets/LaunchImage.imageset/README.md](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner/Assets.xcassets/LaunchImage.imageset/README.md) | คำแนะนำเปลี่ยนภาพ launch ใน asset catalog |
| [ios/Runner/Base.lproj/LaunchScreen.storyboard](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner/Base.lproj/LaunchScreen.storyboard) | UIKit storyboard สำหรับ host/launch screen ไม่ใช่ Flutter screens |
| [ios/Runner/Base.lproj/Main.storyboard](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner/Base.lproj/Main.storyboard) | UIKit storyboard สำหรับ host/launch screen ไม่ใช่ Flutter screens |
| [ios/Runner/GeneratedPluginRegistrant.h](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner/GeneratedPluginRegistrant.h) | สร้างอัตโนมัติ ลงทะเบียน plugin หรือรายชื่อ plugin สำหรับ native host ตรวจประเภทแต่ไม่ใช่โค้ดธุรกิจ |
| [ios/Runner/GeneratedPluginRegistrant.m](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner/GeneratedPluginRegistrant.m) | สร้างอัตโนมัติ ลงทะเบียน plugin หรือรายชื่อ plugin สำหรับ native host ตรวจประเภทแต่ไม่ใช่โค้ดธุรกิจ |
| [ios/Runner/Info.plist](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner/Info.plist) | ชื่อแอป orientation และ scene configuration ไม่พบ NSCameraUsageDescription |
| [ios/Runner/Runner-Bridging-Header.h](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner/Runner-Bridging-Header.h) | เชื่อม GeneratedPluginRegistrant กับ Swift |
| [ios/Runner/SceneDelegate.swift](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner/SceneDelegate.swift) | SceneDelegate สืบทอด FlutterSceneDelegate ดูแล UIKit scene ไม่ใช่ Unity Scene |
| [ios/Runner.xcodeproj/project.pbxproj](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner.xcodeproj/project.pbxproj) | Xcode project ตั้ง targets, file references, build settings และ Flutter build phases |
| [ios/Runner.xcodeproj/project.xcworkspace/contents.xcworkspacedata](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner.xcodeproj/project.xcworkspace/contents.xcworkspacedata) | ความสัมพันธ์ project/workspace ที่ Xcode เปิด |
| [ios/Runner.xcodeproj/project.xcworkspace/xcshareddata/IDEWorkspaceChecks.plist](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner.xcodeproj/project.xcworkspace/xcshareddata/IDEWorkspaceChecks.plist) | การตั้งค่า workspace/check ของ Xcode IDE ไม่ใช่ business logic |
| [ios/Runner.xcodeproj/project.xcworkspace/xcshareddata/WorkspaceSettings.xcsettings](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner.xcodeproj/project.xcworkspace/xcshareddata/WorkspaceSettings.xcsettings) | การตั้งค่า workspace/check ของ Xcode IDE ไม่ใช่ business logic |
| [ios/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme) | Xcode scheme ระบุ run/build/test ของ Runner |
| [ios/Runner.xcworkspace/contents.xcworkspacedata](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner.xcworkspace/contents.xcworkspacedata) | ความสัมพันธ์ project/workspace ที่ Xcode เปิด |
| [ios/Runner.xcworkspace/xcshareddata/IDEWorkspaceChecks.plist](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner.xcworkspace/xcshareddata/IDEWorkspaceChecks.plist) | การตั้งค่า workspace/check ของ Xcode IDE ไม่ใช่ business logic |
| [ios/Runner.xcworkspace/xcshareddata/WorkspaceSettings.xcsettings](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner.xcworkspace/xcshareddata/WorkspaceSettings.xcsettings) | การตั้งค่า workspace/check ของ Xcode IDE ไม่ใช่ business logic |
| [ios/RunnerTests/RunnerTests.swift](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/RunnerTests/RunnerTests.swift) | testExample ว่าง ไม่มี assertion ยืนยันฟีเจอร์ |
| [macos/.gitignore](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/macos/.gitignore) | ไฟล์ประกอบแพลตฟอร์มที่ตรวจ inventory แล้ว ไม่พบ logic โภชนาการในไฟล์นี้ |
| [macos/Flutter/Flutter-Debug.xcconfig](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/macos/Flutter/Flutter-Debug.xcconfig) | ตั้งค่า build ของ Flutter/Xcode ตาม Debug/Release หรือ warnings |
| [macos/Flutter/Flutter-Release.xcconfig](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/macos/Flutter/Flutter-Release.xcconfig) | ตั้งค่า build ของ Flutter/Xcode ตาม Debug/Release หรือ warnings |
| [macos/Flutter/GeneratedPluginRegistrant.swift](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/macos/Flutter/GeneratedPluginRegistrant.swift) | สร้างอัตโนมัติ ลงทะเบียน plugin หรือรายชื่อ plugin สำหรับ native host ตรวจประเภทแต่ไม่ใช่โค้ดธุรกิจ |
| [macos/Runner/AppDelegate.swift](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/macos/Runner/AppDelegate.swift) | FlutterAppDelegate สำหรับ lifecycle แอปบน macOS |
| [macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_1024.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_1024.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_128.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_128.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_16.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_16.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_256.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_256.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_32.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_32.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_512.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_512.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_64.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_64.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [macos/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/macos/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json) | รายการไฟล์ขนาดและ scale ของ Apple asset catalog |
| [macos/Runner/Base.lproj/MainMenu.xib](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/macos/Runner/Base.lproj/MainMenu.xib) | macOS interface ของ native window/menu เชื่อม MainFlutterWindow |
| [macos/Runner/Configs/AppInfo.xcconfig](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/macos/Runner/Configs/AppInfo.xcconfig) | ชื่อ app_ar_v1, bundle identifier และ copyright ของ template |
| [macos/Runner/Configs/Debug.xcconfig](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/macos/Runner/Configs/Debug.xcconfig) | ตั้งค่า build ของ Flutter/Xcode ตาม Debug/Release หรือ warnings |
| [macos/Runner/Configs/Release.xcconfig](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/macos/Runner/Configs/Release.xcconfig) | ตั้งค่า build ของ Flutter/Xcode ตาม Debug/Release หรือ warnings |
| [macos/Runner/Configs/Warnings.xcconfig](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/macos/Runner/Configs/Warnings.xcconfig) | ตั้งค่า build ของ Flutter/Xcode ตาม Debug/Release หรือ warnings |
| [macos/Runner/DebugProfile.entitlements](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/macos/Runner/DebugProfile.entitlements) | สิทธิ์ sandbox/JIT/network server สำหรับ debug ไม่มี entitlement camera |
| [macos/Runner/Info.plist](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/macos/Runner/Info.plist) | metadata ของแอป macOS ไม่พบคำอธิบาย permission camera |
| [macos/Runner/MainFlutterWindow.swift](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/macos/Runner/MainFlutterWindow.swift) | สร้าง FlutterViewController และ register plugin ในหน้าต่าง NSWindow |
| [macos/Runner/Release.entitlements](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/macos/Runner/Release.entitlements) | เปิด app sandbox สำหรับ release ไม่มี entitlement camera |
| [macos/Runner.xcodeproj/project.pbxproj](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/macos/Runner.xcodeproj/project.pbxproj) | Xcode project ตั้ง targets, file references, build settings และ Flutter build phases |
| [macos/Runner.xcodeproj/project.xcworkspace/xcshareddata/IDEWorkspaceChecks.plist](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/macos/Runner.xcodeproj/project.xcworkspace/xcshareddata/IDEWorkspaceChecks.plist) | การตั้งค่า workspace/check ของ Xcode IDE ไม่ใช่ business logic |
| [macos/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/macos/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme) | Xcode scheme ระบุ run/build/test ของ Runner |
| [macos/Runner.xcworkspace/contents.xcworkspacedata](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/macos/Runner.xcworkspace/contents.xcworkspacedata) | ความสัมพันธ์ project/workspace ที่ Xcode เปิด |
| [macos/Runner.xcworkspace/xcshareddata/IDEWorkspaceChecks.plist](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/macos/Runner.xcworkspace/xcshareddata/IDEWorkspaceChecks.plist) | การตั้งค่า workspace/check ของ Xcode IDE ไม่ใช่ business logic |
| [macos/RunnerTests/RunnerTests.swift](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/macos/RunnerTests/RunnerTests.swift) | testExample ว่าง ไม่มี assertion ยืนยันฟีเจอร์ |
| [windows/.gitignore](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/windows/.gitignore) | ไฟล์ประกอบแพลตฟอร์มที่ตรวจ inventory แล้ว ไม่พบ logic โภชนาการในไฟล์นี้ |
| [windows/CMakeLists.txt](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/windows/CMakeLists.txt) | CMake ระดับแอป ตั้งชื่อ binary, build modes, ติดตั้ง bundle และรวม runner/plugin |
| [windows/flutter/CMakeLists.txt](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/windows/flutter/CMakeLists.txt) | CMake ประกอบ Flutter engine/wrapper และเชื่อม ephemeral build กับ native host |
| [windows/flutter/generated_plugin_registrant.cc](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/windows/flutter/generated_plugin_registrant.cc) | สร้างอัตโนมัติ ลงทะเบียน plugin หรือรายชื่อ plugin สำหรับ native host ตรวจประเภทแต่ไม่ใช่โค้ดธุรกิจ |
| [windows/flutter/generated_plugin_registrant.h](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/windows/flutter/generated_plugin_registrant.h) | สร้างอัตโนมัติ ลงทะเบียน plugin หรือรายชื่อ plugin สำหรับ native host ตรวจประเภทแต่ไม่ใช่โค้ดธุรกิจ |
| [windows/flutter/generated_plugins.cmake](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/windows/flutter/generated_plugins.cmake) | สร้างอัตโนมัติ ลงทะเบียน plugin หรือรายชื่อ plugin สำหรับ native host ตรวจประเภทแต่ไม่ใช่โค้ดธุรกิจ |
| [windows/runner/CMakeLists.txt](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/windows/runner/CMakeLists.txt) | CMake รวม source ของ runner และ link Flutter/ระบบปฏิบัติการ |
| [windows/runner/flutter_window.cpp](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/windows/runner/flutter_window.cpp) | FlutterWindow สร้าง FlutterViewController, register plugins และจัด lifecycle/ข้อความหน้าต่าง |
| [windows/runner/flutter_window.h](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/windows/runner/flutter_window.h) | ประกาศ FlutterWindow ที่สืบทอด Win32Window |
| [windows/runner/main.cpp](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/windows/runner/main.cpp) | wWinMain เตรียม COM/DartProject ตั้งหน้าต่าง 1280×720 และ message loop |
| [windows/runner/resource.h](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/windows/runner/resource.h) | รหัส resource ที่ Runner.rc ใช้ |
| [windows/runner/resources/app_icon.ico](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/windows/runner/resources/app_icon.ico) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [windows/runner/runner.exe.manifest](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/windows/runner/runner.exe.manifest) | manifest ของ executable เช่นการรับรู้ DPI |
| [windows/runner/Runner.rc](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/windows/runner/Runner.rc) | icon และ version metadata ของ executable อ้าง resource.h |
| [windows/runner/utils.cpp](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/windows/runner/utils.cpp) | สร้าง console และแปลง command line arguments ให้ Dart entrypoint |
| [windows/runner/utils.h](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/windows/runner/utils.h) | ประกาศ helper ของ utils.cpp |
| [windows/runner/win32_window.cpp](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/windows/runner/win32_window.cpp) | Win32Window และ WindowClassRegistrar สร้างหน้าต่าง ดูแล DPI และการทำลายทรัพยากร |
| [windows/runner/win32_window.h](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/windows/runner/win32_window.h) | สัญญาของ Win32Window ขนาด ตำแหน่ง child content และ lifecycle |
| [linux/.gitignore](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/linux/.gitignore) | ไฟล์ประกอบแพลตฟอร์มที่ตรวจ inventory แล้ว ไม่พบ logic โภชนาการในไฟล์นี้ |
| [linux/CMakeLists.txt](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/linux/CMakeLists.txt) | CMake ระดับแอป ตั้งชื่อ binary, build modes, ติดตั้ง bundle และรวม runner/plugin |
| [linux/flutter/CMakeLists.txt](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/linux/flutter/CMakeLists.txt) | CMake ประกอบ Flutter engine/wrapper และเชื่อม ephemeral build กับ native host |
| [linux/flutter/generated_plugin_registrant.cc](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/linux/flutter/generated_plugin_registrant.cc) | สร้างอัตโนมัติ ลงทะเบียน plugin หรือรายชื่อ plugin สำหรับ native host ตรวจประเภทแต่ไม่ใช่โค้ดธุรกิจ |
| [linux/flutter/generated_plugin_registrant.h](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/linux/flutter/generated_plugin_registrant.h) | สร้างอัตโนมัติ ลงทะเบียน plugin หรือรายชื่อ plugin สำหรับ native host ตรวจประเภทแต่ไม่ใช่โค้ดธุรกิจ |
| [linux/flutter/generated_plugins.cmake](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/linux/flutter/generated_plugins.cmake) | สร้างอัตโนมัติ ลงทะเบียน plugin หรือรายชื่อ plugin สำหรับ native host ตรวจประเภทแต่ไม่ใช่โค้ดธุรกิจ |
| [linux/runner/CMakeLists.txt](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/linux/runner/CMakeLists.txt) | CMake รวม source ของ runner และ link Flutter/ระบบปฏิบัติการ |
| [linux/runner/main.cc](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/linux/runner/main.cc) | main สร้าง MyApplication และเรียก g_application_run |
| [linux/runner/my_application.cc](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/linux/runner/my_application.cc) | MyApplication/GTK สร้าง window 1280×720, FlView และ register plugins พร้อม lifecycle |
| [linux/runner/my_application.h](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/linux/runner/my_application.h) | ประกาศ MyApplication สำหรับ main.cc |
| [web/favicon.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/web/favicon.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [web/icons/Icon-192.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/web/icons/Icon-192.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [web/icons/Icon-512.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/web/icons/Icon-512.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [web/icons/Icon-maskable-192.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/web/icons/Icon-maskable-192.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [web/icons/Icon-maskable-512.png](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/web/icons/Icon-maskable-512.png) | ไอคอนแอปหรือภาพ launch ตามชุด asset/platform ไม่ใช่ screenshot ฟีเจอร์ |
| [web/index.html](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/web/index.html) | HTML host โหลด flutter_bootstrap.js และผูก manifest/icons |
| [web/manifest.json](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/web/manifest.json) | ชื่อ สี orientation และรายการ icons ของ web template |

## 5 Tests
[test/widget_test.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/test/widget_test.dart) สร้าง MultiProvider กับ FruitNutritionArApp โดยตั้ง cameras=[] แล้ว expect ข้อความ Fruit Nutrition มีอย่างน้อยหนึ่งตำแหน่ง เป็น smoke test ของ UI ไม่เปิดกล้องหรือฐานข้อมูลจริง และไม่ได้รันในงานนี้

## 6 สำเนา handover_bundle ทุกไฟล์
ชุดนี้ไม่ถูกใช้จาก imports ของ lib และ analysis_options.yaml exclude จาก analyzer การมีโค้ดต่างจาก lib จึงไม่ใช่ implementation ปัจจุบัน รายการเทียบ bytes ต่อไปนี้อ้าง lib/<path> สำหรับไฟล์ Dart

| Path | หน้าที่และความสัมพันธ์กับ source ปัจจุบัน |
|---|---|
| [handover_bundle/core/constants.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/handover_bundle/core/constants.dart) | สำเนา [lib/core/constants.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/constants.dart) (bytes เหมือน) ไม่ใช่ runtime entrypoint |
| [handover_bundle/core/database_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/handover_bundle/core/database_helper.dart) | สำเนา [lib/core/database_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/database_helper.dart) (bytes ต่าง) ไม่ใช่ runtime entrypoint |
| [handover_bundle/core/detection_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/handover_bundle/core/detection_helper.dart) | สำเนา [lib/core/detection_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/detection_helper.dart) (bytes ต่าง) ไม่ใช่ runtime entrypoint |
| [handover_bundle/main.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/handover_bundle/main.dart) | สำเนา [lib/main.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/main.dart) (bytes ต่าง) ไม่ใช่ runtime entrypoint |
| [handover_bundle/models/fruit.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/handover_bundle/models/fruit.dart) | สำเนา [lib/models/fruit.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/models/fruit.dart) (bytes ต่าง) ไม่ใช่ runtime entrypoint |
| [handover_bundle/models/scan_history.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/handover_bundle/models/scan_history.dart) | สำเนา [lib/models/scan_history.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/models/scan_history.dart) (bytes เหมือน) ไม่ใช่ runtime entrypoint |
| [handover_bundle/providers/fruit_provider.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/handover_bundle/providers/fruit_provider.dart) | สำเนา [lib/providers/fruit_provider.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/providers/fruit_provider.dart) (bytes เหมือน) ไม่ใช่ runtime entrypoint |
| [handover_bundle/pubspec.yaml](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/handover_bundle/pubspec.yaml) | dependencies ของชุดส่งต่อ ไม่ใช่ pubspec ที่ root ใช้ |
| [handover_bundle/screens/detail_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/handover_bundle/screens/detail_screen.dart) | สำเนา [lib/screens/detail_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/detail_screen.dart) (bytes เหมือน) ไม่ใช่ runtime entrypoint |
| [handover_bundle/screens/empty_tab_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/handover_bundle/screens/empty_tab_screen.dart) | สำเนา [lib/screens/empty_tab_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/empty_tab_screen.dart) (bytes เหมือน) ไม่ใช่ runtime entrypoint |
| [handover_bundle/screens/favorites_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/handover_bundle/screens/favorites_screen.dart) | สำเนา [lib/screens/favorites_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/favorites_screen.dart) (bytes ต่าง) ไม่ใช่ runtime entrypoint |
| [handover_bundle/screens/history_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/handover_bundle/screens/history_screen.dart) | สำเนา [lib/screens/history_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/history_screen.dart) (bytes เหมือน) ไม่ใช่ runtime entrypoint |
| [handover_bundle/screens/home_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/handover_bundle/screens/home_screen.dart) | สำเนา [lib/screens/home_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/home_screen.dart) (bytes ต่าง) ไม่ใช่ runtime entrypoint |
| [handover_bundle/screens/scan_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/handover_bundle/screens/scan_screen.dart) | สำเนา [lib/screens/scan_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/scan_screen.dart) (bytes ต่าง) ไม่ใช่ runtime entrypoint |
| [handover_bundle/screens/search_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/handover_bundle/screens/search_screen.dart) | สำเนา [lib/screens/search_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/search_screen.dart) (bytes เหมือน) ไม่ใช่ runtime entrypoint |
| [handover_bundle/system_documentation.md](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/handover_bundle/system_documentation.md) | เอกสาร/บันทึกประกอบชุดส่งต่อ ต้องตรวจเทียบ source ใหม่ ไม่ถือเป็นผลทดสอบ |
| [handover_bundle/widgets/custom_painters.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/handover_bundle/widgets/custom_painters.dart) | สำเนา [lib/widgets/custom_painters.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/custom_painters.dart) (bytes เหมือน) ไม่ใช่ runtime entrypoint |
| [handover_bundle/widgets/fruit_art.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/handover_bundle/widgets/fruit_art.dart) | สำเนา [lib/widgets/fruit_art.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/fruit_art.dart) (bytes ต่าง) ไม่ใช่ runtime entrypoint |
| [handover_bundle/widgets/fruit_cards.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/handover_bundle/widgets/fruit_cards.dart) | สำเนา [lib/widgets/fruit_cards.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/fruit_cards.dart) (bytes เหมือน) ไม่ใช่ runtime entrypoint |
| [handover_bundle/widgets/fruit_selection_sheet.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/handover_bundle/widgets/fruit_selection_sheet.dart) | สำเนา [lib/widgets/fruit_selection_sheet.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/fruit_selection_sheet.dart) (bytes เหมือน) ไม่ใช่ runtime entrypoint |
| [handover_bundle/widgets/mock_widgets.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/handover_bundle/widgets/mock_widgets.dart) | สำเนา [lib/widgets/mock_widgets.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/mock_widgets.dart) (bytes เหมือน) ไม่ใช่ runtime entrypoint |
| [handover_bundle/ประวัติการแก้ไข.md](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/handover_bundle/ประวัติการแก้ไข.md) | เอกสาร/บันทึกประกอบชุดส่งต่อ ต้องตรวจเทียบ source ใหม่ ไม่ถือเป็นผลทดสอบ |
| [handover_bundle/สิ่งที่ต้องทำ.md](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/handover_bundle/สิ่งที่ต้องทำ.md) | เอกสาร/บันทึกประกอบชุดส่งต่อ ต้องตรวจเทียบ source ใหม่ ไม่ถือเป็นผลทดสอบ |

## 7 เอกสารและผลงานอื่นที่ไม่ใช่ runtime

| ไฟล์หรือโฟลเดอร์ | เหตุผลและวิธีใช้ |
|---|---|
| [Fruit_Nutrition_AR_Presentation.pptx](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/Fruit_Nutrition_AR_Presentation.pptx) | รายงาน/สไลด์/คู่มือประกอบงาน ไม่ได้ถูกโหลดโดยแอป Flutter แหล่งเกี่ยวกับ Unity ไม่นำมาเป็น implementation ของ Flutter |
| [Fruit_Nutrition_AR_Presentation_Updated.pptx](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/Fruit_Nutrition_AR_Presentation_Updated.pptx) | รายงาน/สไลด์/คู่มือประกอบงาน ไม่ได้ถูกโหลดโดยแอป Flutter แหล่งเกี่ยวกับ Unity ไม่นำมาเป็น implementation ของ Flutter |
| [PRESENTATION_PLAN.md](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/PRESENTATION_PLAN.md) | รายงาน/สไลด์/คู่มือประกอบงาน ไม่ได้ถูกโหลดโดยแอป Flutter แหล่งเกี่ยวกับ Unity ไม่นำมาเป็น implementation ของ Flutter |
| [PROJECT_QUICK_GUIDE.md](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/PROJECT_QUICK_GUIDE.md) | รายงาน/สไลด์/คู่มือประกอบงาน ไม่ได้ถูกโหลดโดยแอป Flutter แหล่งเกี่ยวกับ Unity ไม่นำมาเป็น implementation ของ Flutter |
| [ประวัติการแก้ไข.md](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ประวัติการแก้ไข.md) | บันทึก Flutter เก่า มีรายละเอียดที่ขัดกับ source ปัจจุบัน ต้องใช้เป็นประวัติ ไม่ใช่สถานะยืนยัน |
| [รายงานโครงการ_Flutter_Fruit_Nutrition.docx](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/รายงานโครงการ_Flutter_Fruit_Nutrition.docx) | รายงาน/สไลด์/คู่มือประกอบงาน ไม่ได้ถูกโหลดโดยแอป Flutter แหล่งเกี่ยวกับ Unity ไม่นำมาเป็น implementation ของ Flutter |
| [สิ่งที่ต้องทำ.md](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/สิ่งที่ต้องทำ.md) | บันทึก Flutter เก่า มีรายละเอียดที่ขัดกับ source ปัจจุบัน ต้องใช้เป็นประวัติ ไม่ใช่สถานะยืนยัน |
| [สิ่งที่ทำวันนี้.md](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/สิ่งที่ทำวันนี้.md) | บันทึก Flutter เก่า มีรายละเอียดที่ขัดกับ source ปัจจุบัน ต้องใช้เป็นประวัติ ไม่ใช่สถานะยืนยัน |
| presentation_output/, .presentation-build/, .report-work/ | ผลงานและเครื่องมือสร้างรายงาน/สไลด์จากงานก่อนหน้า ไม่อยู่ใน Flutter runtime จึงไม่ไล่ source authoring เป็นฟีเจอร์แอป |
| unity_fruit_starter/, UiValidation/, .ui-validation/, Builds/ | งาน Unity/validation และผลงาน build แยกจาก Flutter ผู้ใช้ระบุให้นำออกจากขอบเขต ไม่ถือว่ามี Scene/Prefab/AR ใน Flutter |

## 8 ไฟล์สร้างอัตโนมัติและ cache ที่ข้าม

- .dart_tool/, build/, android/.gradle/ และ native ephemeral/ เก็บ tool state, package resolution, compiler output และ cache ไม่ใช่ source ที่ผู้พัฒนาแก้เพื่อกำหนดฟีเจอร์
- .idea/ และ *.iml เป็นการตั้งค่า IDE ข้อมูลโมดูลไม่ใช่ business logic
- Library/, Temp/, Logs/ ใน Unity เป็นไฟล์สร้างอัตโนมัติและอยู่นอกขอบเขต Flutter
- GeneratedPluginRegistrant, generated_plugins.cmake, Generated.xcconfig และ flutter_export_environment.sh แม้สร้างอัตโนมัติแต่มีผลเชื่อม build จึงลงรายการพร้อมบทบาทในตารางแล้ว ไม่คัดเนื้อหาทั้งหมด
- ไม่แก้ไข ไม่ลบ และไม่สร้าง build output ใหม่ในการตรวจครั้งนี้

## 9 แหล่งข้อมูลภายนอกที่ผู้ใช้ให้
แบบเสนอโครงร่าง APP ใช้สำหรับที่มา ผู้จัดทำ และขอบเขตเดิม ส่วนรายงาน Fruit ใช้เป็นต้นแบบรายงาน ไม่ถือเป็นหลักฐานของ runtime Flutter เนื้อหาเอกสารเก่าที่กล่าวถึงความแม่นยำ 100% หรือ QR แยกไว้ใน [08 ข้อจำกัด](08_LIMITATIONS.md)
