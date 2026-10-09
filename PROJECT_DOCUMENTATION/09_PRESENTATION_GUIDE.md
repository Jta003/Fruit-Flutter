# คู่มือพูดนำเสนอโปรเจกต์ Flutter

> บทเตรียมนำเสนอจาก source Flutter วันที่ 8 ตุลาคม 2569 ไม่รวม Unity และไม่อ้างผลทดสอบที่ไม่มีหลักฐาน ชื่อ AR Mode ใน Flutter เป็นข้อมูลซ้อนบนกล้อง 2D เอกสารนี้ยังไม่ใช่ไฟล์สไลด์

## 1 ที่มาและความสำคัญ
“โครงงานของเราเป็นแอปพลิเคชันโภชนาการผลไม้ครับ จุดเริ่มต้นคืออยากให้ผู้ใช้เข้าถึงข้อมูลพลังงาน น้ำตาลและสารอาหารของผลไม้ได้ง่ายขึ้น แนวคิดในโครงร่างมุ่งให้ข้อมูลประกอบการเลือกบริโภค ส่วนงาน Flutter ที่นำเสนอวันนี้เชื่อมหน้าจอ กล้อง ระบบจำแนกภาพและข้อมูลในเครื่องเข้าด้วยกันครับ”

หลักฐาน: แบบเสนอโครงร่าง APP ของผู้ใช้ และ [lib/main.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/main.dart) ไม่อ้างสถิติผู้บริโภคที่ไม่ได้เก็บ

## 2 ปัญหาที่ต้องการแก้ไข
“เราเน้นความสะดวกในการเปิดดูข้อมูลของผลไม้และเทียบสองชนิด ผู้ใช้เลือกจากรายการได้ หรือกดถ่ายภาพให้โมเดลช่วยระบุชนิด แล้วดูค่าจากฐานข้อมูลต่อครับ ข้อมูลที่แสดงช่วยประกอบการพิจารณา แต่ยังไม่ได้ประเมินว่าช่วยเปลี่ยนพฤติกรรมสุขภาพจริงมากน้อยแค่ไหน”

หลักฐาน: [lib/screens/scan_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/scan_screen.dart), [lib/screens/detail_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/detail_screen.dart)

## 3 วัตถุประสงค์
“เป้าหมายของส่วน Flutter คือแสดงโภชนาการผลไม้ ให้ผู้ใช้เข้าถึงรายละเอียดได้ทั้งจากการเลือกและภาพถ่าย และเปรียบเทียบผลไม้ได้ครับ ในโครงร่างเดิมมีแนวคิด AR แต่ Flutter ปัจจุบันยังไม่มี AR ที่ใช้งานจริง โหมดที่ชื่อ AR Mode เป็นการ์ดข้อมูลซ้อนบนกล้องแบบสองมิติครับ”

หลักฐาน: [lib/screens/ar_scan_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/ar_scan_screen.dart) และ [pubspec.yaml](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/pubspec.yaml) ห้ามอธิบายว่ามี ARCore/โมเดล 3D ใน Flutter

## 4 เทคโนโลยีที่ใช้
“เราใช้ Flutter และภาษา Dart ทำหน้าจอ ใช้ Provider จัดการข้อมูลร่วม และ sqflite เก็บข้อมูลใน SQLite สำหรับกล้องใช้ camera ส่วนการจำแนกภาพใช้ TensorFlow Lite และมี Google ML Kit เป็นทางสำรองครับ”

หลักฐาน: [pubspec.yaml](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/pubspec.yaml), [lib/providers/fruit_provider.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/providers/fruit_provider.dart), [lib/core/detection_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/detection_helper.dart)

## 5 ภาพรวมการทำงาน
“เมื่อเปิดแอป ระบบโหลดข้อมูลผลไม้กับประวัติจากฐานข้อมูลแล้วแสดง Home ถ้าผู้ใช้กดสแกน จะเปิดกล้องและรอให้กดถ่าย ระบบเตรียมภาพให้โมเดลจำแนกชนิด จากนั้นนำชื่อที่ได้ไปจับคู่กับข้อมูลผลไม้แล้วเปิดรายละเอียดครับ หากเลือกจากรายการก็ไปยังรายละเอียดได้โดยไม่ต้องใช้กล้อง”

หลักฐาน: [lib/main.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/main.dart), [lib/core/database_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/database_helper.dart), [lib/screens/scan_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/scan_screen.dart) บอกว่ากดถ่าย ไม่พูดว่าวิเคราะห์ต่อเนื่องทุกเฟรม

## 6 ฟีเจอร์หลัก
“ข้อมูลในแอปมีผลไม้ 9 ชนิด หน้ารายละเอียดแสดงพลังงาน สารอาหารและหน่วยบริโภค ผู้ใช้เลือกอีกชนิดเพื่อเทียบพลังงาน ใยอาหาร น้ำตาลและวิตามินซีได้ นอกจากนี้ยังบันทึกรายการโปรด ดูประวัติ และลบประวัติได้ครับ ส่วนหน้า Search ปัจจุบันเลือกผลไม้จากรายการได้ แต่ยังพิมพ์ค้นหาไม่ได้”

หลักฐาน: [lib/models/fruit.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/models/fruit.dart), [lib/screens/detail_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/detail_screen.dart), [lib/screens/favorites_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/favorites_screen.dart), [lib/screens/history_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/history_screen.dart), [lib/screens/search_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/search_screen.dart)

## 7 ขั้นตอนการพัฒนา
“จากโครงสร้างไฟล์ เราอธิบายงานพัฒนาเป็นส่วนข้อมูลและฐานข้อมูล ส่วนหน้าจอและ Provider ส่วนกล้องกับโมเดล และส่วนรายการโปรดกับประวัติครับ โค้ดแยกไว้ใน models, core, providers, screens และ widgets ทำให้ดูหน้าที่ของแต่ละส่วนได้ชัดเจน”

นี่เป็นการจัดหมวดตาม source ปัจจุบัน ไม่ใช่การยืนยันลำดับเวลาจริง หากต้องเล่าวันที่พัฒนาหรือผู้ที่รับผิดชอบแต่ละส่วน ต้องยืนยันกับผู้พัฒนาอีกครั้ง บันทึก [ประวัติการแก้ไข.md](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ประวัติการแก้ไข.md) เป็นข้อมูลประวัติที่อาจไม่ตรงกับสถานะปัจจุบัน

## 8 ผลลัพธ์ที่ได้
“ผลที่ยืนยันจากโค้ดคือมีข้อมูลผลไม้ 9 ชนิดและเส้นทางเชื่อมหน้าจอ กล้อง การจำแนก SQLite รายการโปรด ประวัติและการเปรียบเทียบเข้าด้วยกันครับ มี smoke test ของ UI แต่ในการตรวจครั้งนี้ยังไม่ได้รันทดสอบบนอุปกรณ์ จึงยังไม่รายงานความแม่นยำหรือความเร็วเป็นตัวเลข”

หลักฐาน: [test/widget_test.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/test/widget_test.dart) และ [07 ตารางสถานะ](07_DEVELOPMENT_SUMMARY.md)

## 9 ข้อจำกัด
“ข้อจำกัดหลักคือช่องค้นหายังไม่รับข้อความ AR จริงยังไม่มี และต้องตรวจความถูกต้องของหน่วยกับแหล่งโภชนาการเพิ่มเติมครับ ด้าน ML ยังต้องปรับเกณฑ์รับผลและการจับคู่ให้ชัดเจน รวมถึงเก็บชุดทดสอบเพื่อวัดความแม่นยำ ส่วนคำแนะนำใน Home และข้อความบางส่วนใน Compare เป็นข้อความที่กำหนดไว้ ไม่ใช่การวิเคราะห์สุขภาพรายบุคคล”

หลักฐาน: [lib/core/detection_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/detection_helper.dart), [lib/screens/home_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/home_screen.dart), [lib/screens/detail_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/detail_screen.dart) และ [08 ข้อจำกัด](08_LIMITATIONS.md)

## 10 แนวทางพัฒนาต่อ
“เราควรเริ่มจากตรวจหน่วยข้อมูล แก้การจับคู่ผลไม้และเกณฑ์คะแนน ปรับเวลาในประวัติและ migration แล้วเพิ่มการค้นหาจริงครับ หลังจากนั้นทดสอบบน Android ด้วยแสงและมุมที่หลากหลายและเก็บผลวัดที่ทำซ้ำได้ ส่วน AR จริงหรือการอัปเดตข้อมูลออนไลน์สามารถกำหนดเป็นงานต่อยอดครับ ขอบคุณครับ”

เนื้อหานี้เป็นแนวทางเสนอ ยังไม่ได้ดำเนินการแก้โค้ดในงานเอกสาร

## ตัวอย่างโค้ดสำหรับอธิบายอย่างสั้น

### ตัวอย่าง A การอ่านรายละเอียดจากสถานะร่วม
จาก [lib/screens/detail_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/detail_screen.dart)

```dart
final currentFruit = context.watch<FruitProvider>().fruits.firstWhere(
  (f) => f.id == fruit.id,
  orElse: () => fruit,
);
```

“หน้านี้ค้นข้อมูลล่าสุดด้วย id จาก Provider ครับ เมื่อกดหัวใจข้อมูลใน provider เปลี่ยน หน้ารายละเอียดจึงอ่านสถานะใหม่และแสดงให้ตรงกัน”

### ตัวอย่าง B การตัดชนิดซ้ำจากตัวเลือกเปรียบเทียบ
จาก [lib/widgets/fruit_selection_sheet.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/fruit_selection_sheet.dart)

```dart
final fruits = context.watch<FruitProvider>().fruits;
final comparisonOptions = fruits.where((f) => f.id != originalFruit.id).toList();
```

“เราอ่านผลไม้ทั้งหมดแล้วตัดผลไม้ของอีกฝั่งออก ทำให้ตัวเลือกไม่เสนอชนิดเดียวกับที่กำลังเทียบครับ เมื่อผู้ใช้เลือก ระบบส่ง Fruit กลับให้หน้ารายละเอียดหรือ Compare”

ตัวอย่างในคู่มือนี้ใช้บรรทัดจริงแบบย่อ เมื่อต้องทำสไลด์สามารถขยายบริบทรอบข้างให้ตรงจำนวนบรรทัดที่กำหนดได้โดยไม่แก้ source

## สิ่งที่ต้องเตรียมก่อนสาธิตจริง
1. ยืนยันชื่ออาจารย์และรายละเอียดรายวิชาของ Flutter จากผู้จัดทำ
2. เตรียมอุปกรณ์ Android และทดสอบกล้องก่อนนำเสนอ ไม่อ้างอุปกรณ์ที่ยังไม่ได้ใช้
3. เก็บ screenshot Flutter จากการเปิดแอปจริง ไม่ใช้ภาพ Unity หรือภาพโทรศัพท์ที่สร้างขึ้นแทน UI
4. แยกสาธิตจากปุ่มถ่ายภาพจริงกับแถบเลือกผลไม้ที่ให้ค่า 0.99
5. ถ้าจะกล่าวถึงผลทดสอบ ให้มีชุดภาพ วิธีวัด อุปกรณ์และผลลัพธ์ตรวจสอบได้

## ประโยคที่ควรใช้ให้ตรงหลักฐาน

| ประเด็น | ประโยคที่ตรงกับงานปัจจุบัน |
|---|---|
| Accuracy | มีโมเดลและโค้ดจำแนกแล้ว แต่ยังไม่มีผลวัดความแม่นยำที่ยืนยันได้ |
| Nutrients | แอปอ่านค่าที่บันทึกไว้ตามชนิดผลไม้ ไม่ได้วัดสารอาหารจากภาพ |
| AR | Flutter แสดงข้อมูลซ้อนบนกล้องแบบ 2D ยังไม่มี ARCore |
| Search | เลือกผลไม้จากรายการได้ แต่ยังไม่มีการพิมพ์ค้นหา |
| Recommendations | ใช้ข้อความที่กำหนดไว้และกรองตามหมวด |
| Platform | มี host หลาย platform แต่ยังไม่ยืนยันครบฟีเจอร์ทุกระบบ |

## เอกสารที่ผู้ใช้ให้ประกอบที่มา

[แบบเสนอโครงร่างโครงงาน APP](<C:/Users/jtaku/OneDrive/Desktop/งานปี 3/งาน Mobile Dev/แบบเสนอโครงร่างโครงงาน APP.pdf>) ใช้เป็นที่มาของวัตถุประสงค์เดิมและกลุ่มเป้าหมาย ไม่ใช้ยืนยันฟีเจอร์ที่ยังไม่มีใน source ปัจจุบัน
