# ภาพรวมโปรเจกต์ Fruit Nutrition Application

> ตรวจจากไฟล์ Flutter ปัจจุบัน วันที่ 8 ตุลาคม 2569 ขอบเขตคือ root ของ app_ar_v1 และโค้ดใน lib ไม่รวมโปรเจกต์ Unity ตามคำยืนยันของผู้ใช้ ไม่แก้ไข source หรือ configuration สถานะจากการอ่านโค้ดไม่เท่ากับผลทดสอบบนอุปกรณ์

## โปรเจกต์นี้คืออะไร
แอป Flutter สำหรับจำแนกชนิดผลไม้จากภาพถ่าย แล้วอ่านข้อมูลโภชนาการจาก SQLite ในเครื่อง ผู้ใช้เลือกผลไม้เองได้ ดูรายละเอียด เปรียบเทียบสองชนิด บันทึกรายการโปรด และดูประวัติ ชื่อใน MaterialApp ยังเป็น Fruit Nutrition AR แต่ Flutter ไม่มีระบบ AR ที่ใช้งานจริง หน้า AR Mode เป็นภาพกล้องกับข้อมูลซ้อนแบบ 2D

หลักฐานหลัก: [lib/main.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/main.dart), [lib/core/detection_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/detection_helper.dart), [lib/core/database_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/database_helper.dart) และ [pubspec.yaml](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/pubspec.yaml)

## ปัญหาและวัตถุประสงค์
แบบเสนอโครงร่างโครงงาน APP.pdf ระบุแนวคิดช่วยให้ผู้ใช้เข้าถึงข้อมูลพลังงาน น้ำตาล และวิตามินเพื่อประกอบการเลือกผลไม้ กลุ่มที่กล่าวถึงคือผู้ควบคุมน้ำหนัก ผู้ที่ออกกำลังกาย และผู้ที่ต้องการควบคุมปริมาณน้ำตาล เป็นกลุ่มเป้าหมายที่เสนอไว้ ยังไม่มีผลวิจัยผู้ใช้หรือผลประเมินความเหมาะสมทางสุขภาพ

วัตถุประสงค์ของ Flutter ที่ตรวจได้คือแสดงข้อมูลผลไม้ เชื่อมกล้องกับการจำแนกภาพ และทำให้ผู้ใช้ดูข้อมูลหรือเปรียบเทียบได้ในแอปเดียว วัตถุประสงค์เดิมเรื่อง AR ในโครงร่างยังไม่เป็นความสามารถของ Flutter ปัจจุบัน

ข้อมูลผู้จัดทำจากโครงร่าง: นายศุภโชค แสงจันทร์ รหัส 67543210066-6 และนายวรรธนะ คำมาลัย รหัส 67543210023-7 ส่วนชื่ออาจารย์ของวิชา Flutter ยังไม่มีหลักฐานที่ยืนยันได้ ไม่ใช้ชื่ออาจารย์จากรายงาน Unity แทน

## เทคโนโลยีและโครงสร้าง

| ชั้น | หน้าที่ | หลักฐาน |
|---|---|---|
| Flutter และ Dart | หน้าจอ การนำทางและปฏิสัมพันธ์ | [lib/main.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/main.dart) |
| Screens และ Widgets | หน้าแอปและองค์ประกอบที่ใช้ซ้ำ | [lib/screens/detail_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/detail_screen.dart), [lib/widgets/fruit_cards.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/fruit_cards.dart) |
| Provider | เก็บข้อมูลในหน่วยความจำและแจ้ง UI เมื่อเปลี่ยน | [lib/providers/fruit_provider.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/providers/fruit_provider.dart) |
| SQLite ผ่าน sqflite | ผลไม้ สถานะรายการโปรด และประวัติ | [lib/core/database_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/database_helper.dart) |
| camera | ภาพสดและการถ่ายภาพเมื่อแตะปุ่ม | [lib/screens/scan_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/scan_screen.dart) |
| TFLite และ ML Kit | จำแนกชนิดภาพผลไม้และเส้นทางสำรอง | [lib/core/detection_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/detection_helper.dart) |
| CustomPainter | รูปผลไม้ 2D กรอบและการตกแต่ง | [lib/widgets/fruit_art.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/fruit_art.dart) |

State management หมายถึงการจัดการข้อมูลที่หลายหน้าจออ่านร่วมกัน ส่วน inference หมายถึงการนำภาพเข้าโมเดลที่มีอยู่แล้วเพื่อให้โมเดลทำนายชนิด ไม่ได้หมายถึงการฝึกโมเดลในแอป

## ผู้ใช้ทำอะไรได้ตามเส้นทางที่เชื่อมไว้
1. ดูผลไม้ 9 ชนิดจาก Home หรือ Search Fruits และเปิดรายละเอียด
2. กดถ่ายภาพเพื่อจำแนก แล้วเปิดรายละเอียด หรือใช้ทางเลือกแตะผลไม้เองเพื่อจำลองผล
3. ดูชื่อวิทยาศาสตร์ ข้อความหน่วยบริโภค พลังงาน สารอาหาร และ Health Score
4. เลือกผลไม้สองชนิดและเปลี่ยนคู่ที่เทียบได้
5. เพิ่มหรือนำรายการโปรดออก รวมถึงปัดนำออกในหน้า Favorites
6. ดูประวัติ ลบรายรายการด้วยการกดค้างและยืนยัน หรือล้างทั้งหมด
7. เลือกหมวดเป้าหมายเพื่อกรองคำแนะนำที่กำหนดไว้ใน Home
8. ใช้โหมดข้อมูลซ้อนบนกล้องและดูผลก่อนยืนยันเข้ารายละเอียด

ช่องค้นหายังเป็น Text ตกแต่ง จึงไม่รวมการพิมพ์ค้นหาเป็นฟีเจอร์สำเร็จ การจำแนกจริง ความเร็วและความแม่นยำยังต้องยืนยันบนอุปกรณ์

## ข้อมูลผลไม้และจุดเด่น
มี apple, banana, orange, mango, grapes, strawberry, kiwi, chickoo และ cherry ใน [lib/models/fruit.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/models/fruit.dart) และข้อมูลเริ่มต้นใน DatabaseHelper จุดเด่นที่ยืนยันจากโครงสร้างคือใช้ข้อมูลชุดเดียวสำหรับรายละเอียด เปรียบเทียบ และรายการโปรด พร้อมเก็บข้อมูลในเครื่องโดยไม่มี backend ของแอป

โภชนาการและ Health Score เป็นค่าที่กำหนดไว้ ไม่ได้วัดจากภาพ น้ำหนักหรือขนาดผลไม้ คำว่า AI Suggest ใน Home หมายถึง UI ของคำแนะนำคงที่ที่กรองตามหมวด ไม่พบโมเดลแนะนำเฉพาะบุคคล

## หลักฐานและความต่างจากเอกสารเก่า
[สิ่งที่ทำวันนี้.md](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/สิ่งที่ทำวันนี้.md), [สิ่งที่ต้องทำ.md](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/สิ่งที่ต้องทำ.md) และ [ประวัติการแก้ไข.md](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ประวัติการแก้ไข.md) มีบันทึก QR, real-time และ 100% แต่ dependencies และเส้นทางปัจจุบันใช้ camera, TFLite และปุ่มถ่าย ไม่มีรายงานชุดทดสอบที่รองรับ 100% จึงใช้โค้ดปัจจุบันเป็นหลัก

พบ APK ที่ build/app/outputs/flutter-apk/app-debug.apk จากงานก่อนหน้า แต่ไฟล์ build ไม่ยืนยันว่า APK ตรงกับ source วันนี้หรือทดสอบครบแล้ว ไม่มี Screenshot Flutter จริงที่ยืนยันได้จากการสำรวจไฟล์ในขอบเขตนี้

## วิธีอ่านชุดเอกสาร
[02 อธิบายไฟล์](02_FILE_EXPLANATION.md), [03 ฟีเจอร์](03_FEATURES.md), [04 Flow](04_SYSTEM_FLOW.md), [05 Architecture](05_ARCHITECTURE.md), [06 เทคโนโลยี](06_TECHNOLOGIES.md), [07 สถานะ](07_DEVELOPMENT_SUMMARY.md), [08 ข้อจำกัด](08_LIMITATIONS.md), [09 บทนำเสนอ](09_PRESENTATION_GUIDE.md) และ [10 คำถามเตรียมตอบ](10_QA_PREPARATION.md)

## เอกสารที่ผู้ใช้ให้ประกอบที่มา

[แบบเสนอโครงร่างโครงงาน APP](<C:/Users/jtaku/OneDrive/Desktop/งานปี 3/งาน Mobile Dev/แบบเสนอโครงร่างโครงงาน APP.pdf>) ใช้เป็นที่มาของวัตถุประสงค์เดิมและกลุ่มเป้าหมาย ไม่ใช้ยืนยันฟีเจอร์ที่ยังไม่มีใน source ปัจจุบัน
