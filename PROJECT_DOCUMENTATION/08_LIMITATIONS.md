# ข้อจำกัดและแนวทางตรวจสอบเพิ่มเติม

> ตรวจจาก source Flutter ปัจจุบัน วันที่ 8 ตุลาคม 2569 ไม่รวม Unity ตามขอบเขตผู้ใช้ ไม่มีการแก้โค้ดหรือ configuration และไม่รัน build/test ที่อาจสร้างไฟล์นอก PROJECT_DOCUMENTATION การพบโค้ดไม่เท่ากับผลทดสอบ runtime

## แยกข้อเท็จจริงออกจากผลที่ยังไม่ยืนยัน
ตารางแรกเป็นพฤติกรรมหรือ configuration ที่ยืนยันจาก source ส่วนความเสียหายหรือผลบนอุปกรณ์อธิบายเป็นความเสี่ยง ไม่อ้างว่าพบ crash จริงถ้ายังไม่มีผลทดสอบ ส่วนตารางหลังเป็นข้อเสนอพัฒนาต่อ

## ข้อจำกัดจากไฟล์ปัจจุบัน

| เรื่อง | สิ่งที่พบจริง | ผลหรือความเสี่ยงที่ต้องตรวจ | หลักฐาน |
|---|---|---|---|
| AR | CameraPreview/Stack/CustomPainter ไม่มี AR session | การ์ดไม่ยึดกับตำแหน่งโลกจริง ใช้อธิบายเป็น 2D overlay | [lib/screens/ar_scan_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/ar_scan_screen.dart) |
| Search | Text แสดง Search nutrition ไม่มี TextField/query | ผู้ใช้ยังพิมพ์ค้นหาไม่ได้ | [lib/screens/search_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/search_screen.dart) |
| เกณฑ์ ML | classifyImagePath คืน bestResult ต่ำกว่า 0.55 ได้ และ caller ไม่ตรวจซ้ำ | ผลต่ำกว่าเกณฑ์อาจถูกยอมรับ | [lib/core/detection_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/detection_helper.dart), [lib/screens/scan_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/scan_screen.dart) |
| จับคู่ index | fallback ใช้ fruits[index] แต่ labels เรียงคนละลำดับกับ seed | ผลไม้ผิดชนิดในกรณีชื่อจับคู่ไม่ได้ เป็นข้อสรุปจากลำดับ ไม่ใช่ผลทดสอบภาพ | [assets/models/labels.txt](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/assets/models/labels.txt), [lib/core/database_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/database_helper.dart) |
| การจำแนกสด | หน้าจอใช้ takePicture ไม่มีการเรียก processCameraFrame ต่อเนื่อง | ไม่ควรอ้าง real-time ทุกเฟรม | [lib/screens/scan_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/scan_screen.dart), [lib/screens/ar_scan_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/ar_scan_screen.dart) |
| ผลจำลอง | แตะผลไม้เองใช้ confidence 0.99 | ถ้าแสดงเป็น AI ยืนยันอาจทำให้เข้าใจผิด | [lib/screens/ar_scan_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/ar_scan_screen.dart) |
| ประวัติเวลา | เก็บ dd/MM/yyyy HH:mm และ ORDER BY แบบ text | ข้ามเดือน/ปีอาจเรียงผิด | [lib/providers/fruit_provider.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/providers/fruit_provider.dart), [lib/core/database_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/database_helper.dart) |
| UI เวลา History | ไม่ส่ง scanTime ไป HistoryRow | แสดงสแกนเมื่อสักครู่แทนเวลาที่เก็บจริง | [lib/screens/history_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/history_screen.dart), [lib/widgets/fruit_cards.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/fruit_cards.dart) |
| Migration | onUpgrade ลบ fruits และ scan_history ก่อนสร้างใหม่ | ข้อมูลเก่าไม่ถูกรักษา | [lib/core/database_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/database_helper.dart) |
| Foreign key | schema ประกาศ แต่ไม่พบเปิด PRAGMA ใน onConfigure | ยังไม่ยืนยัน constraint/ON DELETE CASCADE บังคับจริง | [lib/core/database_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/database_helper.dart) |
| บันทึกก่อน Detail | AppShell ไม่ await addScanHistory | หน้าเปิดได้ก่อน write เสร็จ ยังต้องทดสอบ error ของฐานข้อมูล | [lib/main.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/main.dart) |
| หน่วยสารอาหาร | ต่อ 100g และ servingSize แสดงคู่กัน ไม่มีคำนวณน้ำหนัก | ต้องตรวจหน่วยและค่าจากแหล่งต้นทาง | [lib/screens/detail_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/detail_screen.dart), [lib/core/database_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/database_helper.dart) |
| Health Score | ค่า seed คงที่ ข้อความ HealthScoreCard เหมือนกันทุกชนิด | ไม่ใช่การประเมินสุขภาพเฉพาะบุคคล | [lib/widgets/fruit_cards.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/fruit_cards.dart) |
| AI Insight | ประโยคว่า left พลังงานต่ำกว่าและ right เหมาะออกกำลังกาย ไม่มี if เปรียบเทียบค่า | ถ้าสลับคู่ข้อความอาจไม่ตรงกับข้อมูล | [lib/screens/detail_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/detail_screen.dart) |
| คำแนะนำ | recommendations เป็นข้อความคงที่กรองหมวด | ไม่มีโมเดลเรียนรู้เป้าหมายสุขภาพ | [lib/screens/home_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/home_screen.dart) |
| Permission iOS | Info.plist ไม่มี NSCameraUsageDescription | ต้องเตรียม config ก่อนยืนยันกล้องบน iOS | [ios/Runner/Info.plist](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner/Info.plist) |
| Camera error UI | controller ไม่พร้อมแสดง loading แม้ state บันทึก error แล้ว | บางกรณีอาจแสดงกำลังโหลดค้าง ยังไม่ทดสอบ runtime | [lib/screens/scan_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/scan_screen.dart), [lib/screens/ar_scan_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/ar_scan_screen.dart) |
| Singleton ML | สองหน้าใช้ DetectionHelper instance เดียวและ dispose เอง | ต้องทดสอบสลับโหมดระหว่าง initialize/dispose | [lib/core/detection_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/detection_helper.dart) |
| Release | buildTypes.release ใช้ debug signing | ยังไม่ยืนยันพร้อมเผยแพร่ใน store | [android/app/build.gradle.kts](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/android/app/build.gradle.kts) |

## Smoke test ที่ควรตรวจซ้ำ
[test/widget_test.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/test/widget_test.dart) ค้น Text ชื่อ Fruit Nutrition แต่ [HomeScreen](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/home_screen.dart) แสดง Fruit Scanner ส่วน Fruit Nutrition AR ใน main เป็น MaterialApp.title จึงมีความเสี่ยงว่า test expectation ล้าสมัย ยังไม่ได้รันเพื่อสรุปว่า test ผ่านหรือไม่ผ่าน

## ข้อมูลและหลักฐานที่ยังขาด
- ไม่พบ training dataset, test set, confusion matrix หรือ formal accuracy report ไม่มีหลักฐานรองรับ 100%
- ไม่ยืนยัน tensor metadata จากการรัน Interpreter โค้ดจัด input [1,224,224,3] แต่ยังไม่ได้ตรวจ binary ผ่าน runtime
- แหล่งโภชนาการ: บันทึกเดิมอ้าง Thai FCD/มหิดล แต่ seed ไม่แนบ source URL, food record ID, วันที่อ้างอิงหรือหน่วยของแต่ละค่า จึงยังรับรอง provenance ไม่ได้
- ไม่พบผลวัดเวลาหลังสแกนภายใน 3 วินาที หรือแบบสอบถามที่ยืนยันระดับความพึงพอใจ
- ไม่มี screenshot Flutter จริงที่ยืนยันได้จากไฟล์ที่สำรวจ และไม่ใช้ screenshot Unity ทดแทน
- มี platform folders ไม่ใช่หลักฐานรองรับ iOS/Web/Desktop ครบ SQLite และ plugin ของ ML ต้องตรวจแยกแต่ละ platform

เอกสารเดิม [สิ่งที่ต้องทำ.md](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/สิ่งที่ต้องทำ.md), [สิ่งที่ทำวันนี้.md](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/สิ่งที่ทำวันนี้.md), [ประวัติการแก้ไข.md](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ประวัติการแก้ไข.md) และ [handover_bundle/system_documentation.md](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/handover_bundle/system_documentation.md) มีข้อมูลเก่า เช่น QR/mock/จำนวนผลไม้ จึงต้องอ่านเทียบ source วันนี้

## ข้อเสนอพัฒนาต่อ

| ลำดับ | งานเสนอ | วิธีตรวจผลเมื่อได้รับอนุญาตพัฒนา |
|---|---|---|
| 1 | mapping label เป็น FruitKind และเกณฑ์รับผลชัดเจน | test label ครบ 9 class กรณีชื่อไม่ตรงและคะแนนต่ำ |
| 2 | timestamp/ISO 8601 และส่ง scanTime ไป UI | test ข้ามเดือน/ปี พร้อมตรวจเวลาใน History |
| 3 | migration ที่เก็บข้อมูลเดิม | เปิด DB เก่า เพิ่ม favorite/history แล้วอัปเกรดและตรวจข้อมูล |
| 4 | ตรวจหน่วยและอ้างอิงโภชนาการราย record | เทียบแหล่งทางการและระบุฐานน้ำหนักที่ใช้ |
| 5 | Search ที่รับ query จริง | ทดสอบชื่อไทย อังกฤษ ไม่พบผล และล้างคำค้น |
| 6 | ข้อความ Compare/Health Score ตามข้อมูล | test สลับซ้ายขวาและคะแนนต่างกัน |
| 7 | permission/error/lifecycle ของ camera | ทดสอบปฏิเสธสิทธิ์ ไม่มีกล้อง สลับโหมด และเข้าออกซ้ำ |
| 8 | accuracy/latency และทดสอบผู้ใช้ | ใช้ test set แยกจาก train พร้อมระบุอุปกรณ์และวิธีวัด |
| 9 | AR จริงหรือข้อมูลออนไลน์ถ้าจะเพิ่ม | ตั้ง scope ใหม่และแยกจากฟีเจอร์ปัจจุบัน |

ตารางนี้เป็นแผนเสนอ ไม่ใช่งานที่แก้แล้วในการตรวจครั้งนี้
