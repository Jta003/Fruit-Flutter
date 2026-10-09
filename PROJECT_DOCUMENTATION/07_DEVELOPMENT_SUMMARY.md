# สิ่งที่พัฒนาแล้วและระดับหลักฐาน

> ตรวจจาก source Flutter ปัจจุบัน วันที่ 8 ตุลาคม 2569 ไม่รวม Unity ตามขอบเขตผู้ใช้ ไม่มีการแก้โค้ดหรือ configuration และไม่รัน build/test ที่อาจสร้างไฟล์นอก PROJECT_DOCUMENTATION การพบโค้ดไม่เท่ากับผลทดสอบ runtime

## วิธีอ่านสถานะ
แยก 3 ระดับคือมีโค้ด มี caller เชื่อมเข้าระบบ และมีหลักฐานทดสอบจริง เอกสารนี้ยืนยันสองระดับแรกจาก source ส่วนระดับสามไม่ยืนยันเพียงจาก APK หรือคำว่าเสร็จแล้วในบันทึก

## ตารางสถานะ

| ฟีเจอร์ | สิ่งที่ทำได้จากเส้นทางโค้ด | ไฟล์และหลักฐาน | มีโค้ด | เชื่อมระบบ | หลักฐานทดสอบจริง |
|---|---|---|---|---|---|
| เริ่มแอปและนำทาง | โหลดกล้อง Provider และ 5 แท็บ | [lib/main.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/main.dart) main, AppShell | มี | มี | ยังไม่ยืนยันในการตรวจนี้ |
| ข้อมูลผลไม้ 9 ชนิด | seed SQLite และแปลง Fruit | [lib/core/database_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/database_helper.dart) _prepopulateData | มี | มี ผ่าน Provider | ยังไม่ยืนยันฐานข้อมูลบนอุปกรณ์ |
| Home | รายการทั้งหมดและ recent สูงสุด 6 | [lib/screens/home_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/home_screen.dart) build | มี | มี แท็บ 0 | ยังไม่ยืนยัน runtime |
| คำแนะนำตามหมวด | กรองข้อความคงที่ตาม goal | [lib/screens/home_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/home_screen.dart) _buildSmartRecommendationSection | มี | มี | ยังไม่ยืนยัน runtime ไม่ใช่โมเดลแนะนำ |
| ถ่ายและจำแนก | TFLite พร้อม ML Kit fallback | [lib/screens/scan_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/scan_screen.dart), [lib/core/detection_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/detection_helper.dart) _captureAndAnalyze | มี | มี | ไม่มี accuracy/latency report |
| เลือกผลไม้จำลอง | ใช้ค่าคะแนน 0.99 ที่ตั้งไว้ | [lib/screens/scan_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/scan_screen.dart), [lib/screens/ar_scan_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/ar_scan_screen.dart) | มี | มี | แยกจากผล AI |
| ข้อมูลซ้อนบนกล้อง | การ์ดผลลัพธ์ก่อนยืนยัน | [lib/screens/ar_scan_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/ar_scan_screen.dart) _showArResult | มี | มี | ยังไม่ยืนยัน runtime เป็น 2D |
| โภชนาการ | ค่าชื่อ หน่วยและสารอาหาร | [lib/screens/detail_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/detail_screen.dart) DetailBottomSheet | มี | มี | หน่วย/ที่มาต้องตรวจเพิ่ม |
| เปรียบเทียบ | คู่ผลไม้เปลี่ยนซ้ายขวาได้ | [lib/screens/detail_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/detail_screen.dart), [lib/widgets/fruit_selection_sheet.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/fruit_selection_sheet.dart) | มี | มี | ยังไม่ยืนยัน runtime |
| รายการโปรด | หัวใจ update และปัดนำออก | [lib/providers/fruit_provider.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/providers/fruit_provider.dart), [lib/screens/favorites_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/favorites_screen.dart) | มี | มี | ยังไม่ยืนยัน persistence |
| สรุปรายการโปรด | เฉลี่ย kcal/score ของชุดที่เลือก | [lib/screens/favorites_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/favorites_screen.dart) _buildSummaryBar | มี | มี | ยังไม่ยืนยัน runtime |
| ประวัติ | เพิ่ม ดู ลบ และล้าง | [lib/core/database_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/database_helper.dart), [lib/screens/history_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/history_screen.dart) | มี | มี | เรียงเวลาและ UI เวลามีข้อจำกัด |
| พิมพ์ค้นหา | ช่องเป็น Text ตกแต่ง | [lib/screens/search_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/search_screen.dart) | UI บางส่วน | แท็บมี รายการเลือกได้ | ไม่มี query ที่เชื่อม |
| กล้องสดจำแนกทุกเฟรม | processCameraFrame มี helper | [lib/core/detection_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/detection_helper.dart) | มี helper | ไม่พบ caller ในหน้าสแกน | ไม่ยืนยันเป็นฟีเจอร์ปัจจุบัน |
| ARCore/3D | ไม่พบใน Flutter | [pubspec.yaml](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/pubspec.yaml), [lib/screens/ar_scan_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/ar_scan_screen.dart) | ไม่พบ | ไม่มี | ไม่อยู่ในผลที่พัฒนาแล้ว |

## การทดสอบที่มีไฟล์รองรับ
[test/widget_test.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/test/widget_test.dart) มี smoke test ตั้ง cameras=[] สร้างแอปและตรวจข้อความ Fruit Nutrition แต่ไม่ initialize ข้อมูลจาก main และไม่ทดสอบ SQLite, camera, inference หรือความถูกต้อง Compare ไม่ได้รัน test ในงานนี้ จึงระบุ NOT_RUN ไม่ใช่ PASSED

[ios/RunnerTests/RunnerTests.swift](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/RunnerTests/RunnerTests.swift) และ [macos/RunnerTests/RunnerTests.swift](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/macos/RunnerTests/RunnerTests.swift) มี testExample ว่าง ไม่มี assertion ของฟีเจอร์

APK build/app/outputs/flutter-apk/app-debug.apk เป็น build artifact เก่า ไม่ทราบว่า source ตรงกับรุ่นที่ตรวจหรือไม่ ยังไม่มีผลทดสอบครบที่อ้างจากไฟล์นี้ได้ ไม่พบ screenshots Flutter จริงหรือรายงาน benchmark ในหลักฐานที่ตรวจ

## คำกล่าวในบันทึกกับหลักฐานปัจจุบัน
[สิ่งที่ทำวันนี้.md](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/สิ่งที่ทำวันนี้.md) กล่าวถึงความแม่นยำ 100% และ [ประวัติการแก้ไข.md](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ประวัติการแก้ไข.md) กล่าวถึงผ่านทดสอบ 100% แต่ไม่มีชุดข้อมูล วิธีวัด หรือ log ผลทดสอบประกอบ จึงจัดเป็นคำกล่าวในบันทึกที่ยังไม่ยืนยัน ไม่รายงานเป็นผลสำเร็จเชิงตัวเลข

## การตรวจงานเอกสารครั้งนี้
อ่าน source/caller, schemas, dependencies/lock, native configuration และเทียบ hash ของ model/labels แบบ read-only สร้างเพียง Markdown ใน PROJECT_DOCUMENTATION ไม่มีการแก้ code/configuration ไม่มีการฝึกโมเดล ไม่มีการติดตั้ง package และไม่มีการเพิ่มฟีเจอร์ใหม่

รายละเอียดข้อจำกัดและแผนตรวจเพิ่ม: [08_LIMITATIONS.md](08_LIMITATIONS.md)

## ข้อสังเกตเพิ่มเติมของ smoke test
ตัว test ค้นข้อความ Fruit Nutrition แต่ Home ปัจจุบันแสดง Fruit Scanner และพบ Fruit Nutrition AR เป็น MaterialApp.title เท่านั้น จึงมีความเสี่ยงว่า assertion ของ smoke test ไม่ตรงกับ UI ล่าสุด ข้อนี้เป็นการเทียบข้อความจาก source ไม่ใช่ผลรันทดสอบว่า FAILED แล้ว

## การรักษาไฟล์เดิม
เทียบ SHA256 ก่อนและหลังจัดทำเอกสารสำหรับไฟล์เดิม 198 ไฟล์ใน lib, test, assets, native host, handover_bundle และไฟล์ root ไม่พบไฟล์เปลี่ยนหรือไฟล์ใหม่ในชุดนั้น ผลตรวจลิงก์ในเอกสารทั้ง 10 ไฟล์ไม่พบลิงก์ local ที่หาย และ inventory ครอบคลุมทุกไฟล์ Flutter ที่อยู่ในชุดตรวจโดยเว้น cache/build ที่อธิบายไว้ใน 02
