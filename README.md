# Fruit Nutrition Application

แอปพลิเคชัน Flutter สำหรับดูข้อมูลโภชนาการของผลไม้ จำแนกชนิดผลไม้จากภาพถ่าย เปรียบเทียบสารอาหาร และจัดเก็บรายการโปรดกับประวัติไว้ในเครื่อง

โปรเจกต์นี้ครอบคลุมเฉพาะแอป Flutter ไม่มีระบบ AR จริงหรือส่วน Unity แม้ชื่อคลาสและบางหน้าจอจะยังมีคำว่า `AR` โดยหน้าดังกล่าวแสดงข้อมูลซ้อนบนภาพกล้องแบบ 2D

## ฟีเจอร์

- **รายการผลไม้** — ดูผลไม้ 9 ชนิดและเปิดหน้ารายละเอียด
- **สแกนจากภาพถ่าย** — ใช้กล้องถ่ายภาพเพื่อจำแนกชนิดด้วย TensorFlow Lite พร้อมเส้นทางสำรองผ่าน ML Kit
- **เลือกผลไม้ด้วยตนเอง** — เปิดข้อมูลผลไม้โดยไม่ต้องอาศัยผลการจำแนกภาพ
- **ข้อมูลโภชนาการ** — แสดงพลังงาน น้ำตาล สารอาหาร ชื่อวิทยาศาสตร์ และ Health Score จากข้อมูลที่กำหนดไว้
- **เปรียบเทียบ** — เลือกผลไม้สองชนิดเพื่อดูข้อมูลคู่กัน
- **รายการโปรด** — เพิ่มและนำผลไม้ออกจากรายการโปรด
- **ประวัติ** — ดูรายการที่บันทึก ลบรายรายการ หรือล้างประวัติทั้งหมด
- **คำแนะนำในหน้าแรก** — กรองคำแนะนำที่กำหนดไว้ตามหมวดเป้าหมาย

ผลไม้ในฐานข้อมูล: แอปเปิล กล้วย ส้ม มะม่วง องุ่น สตรอว์เบอร์รี กีวี ละมุด และเชอร์รี

## เทคโนโลยี

| เทคโนโลยี | หน้าที่ |
|---|---|
| Flutter / Dart | หน้าจอและการทำงานของแอป |
| Provider | จัดการข้อมูลร่วมกันระหว่างหน้าจอ |
| SQLite / sqflite | เก็บข้อมูลผลไม้ รายการโปรด และประวัติในเครื่อง |
| camera | แสดงภาพกล้องและถ่ายภาพ |
| tflite_flutter | เรียกใช้โมเดลจำแนกภาพที่แนบมากับแอป |
| Google ML Kit Image Labeling | เส้นทางสำรองสำหรับการจำแนกภาพ |
| image | เตรียมภาพก่อนส่งเข้าโมเดล |
| CustomPainter | วาดภาพผลไม้และองค์ประกอบ UI |

แอปไม่มี backend หรือระบบบัญชีผู้ใช้ของตนเอง ข้อมูลโภชนาการอ่านจากฐานข้อมูลในเครื่อง ไม่ได้คำนวณสารอาหารจากภาพถ่าย

## การติดตั้งและรัน

### สิ่งที่ต้องเตรียม

- Flutter SDK ที่มี Dart ตรงตามเงื่อนไข `^3.12.2` ใน [pubspec.yaml](pubspec.yaml)
- Android Studio และ Android SDK
- อุปกรณ์ Android หรือ Android Emulator สำหรับรันแอป โดยการทดสอบจำแนกภาพควรใช้อุปกรณ์ที่มีกล้อง

### ขั้นตอน

```bash
git clone https://github.com/Jta003/Fruit-Flutter.git
cd Fruit-Flutter
flutter doctor
flutter pub get
flutter devices
flutter run
```

หากมีหลายอุปกรณ์ ให้เลือกด้วย `flutter run -d <device-id>` และอนุญาตให้แอปใช้กล้องเมื่อระบบร้องขอ

สร้าง APK สำหรับทดสอบ:

```bash
flutter build apk --debug
```

ไฟล์ที่ได้อยู่ที่ `build/app/outputs/flutter-apk/app-debug.apk`

## โครงสร้างโปรเจกต์

```text
lib/
├── main.dart                 # เริ่มแอป ตั้งค่า Provider และการนำทาง
├── core/                     # ฐานข้อมูล การจำแนกภาพ และค่าที่ใช้ร่วมกัน
├── models/                   # โมเดลข้อมูลผลไม้และประวัติ
├── providers/                # สถานะข้อมูลและการแจ้ง UI เมื่อข้อมูลเปลี่ยน
├── screens/                  # หน้าจอของแอป
└── widgets/                  # องค์ประกอบ UI และภาพวาดที่ใช้ซ้ำ
assets/                       # โมเดล TensorFlow Lite และไฟล์ labels
test/                         # Widget test
PROJECT_DOCUMENTATION/        # เอกสารอธิบายโปรเจกต์
android/                      # การตั้งค่าแพลตฟอร์ม Android
ios/ linux/ macos/ web/ windows/ # ไฟล์แพลตฟอร์มอื่นของ Flutter
```

ไฟล์หลักสำหรับเริ่มอ่านโค้ด:

- [main.dart](lib/main.dart) — จุดเริ่มต้นของแอปและแท็บหลัก
- [fruit_provider.dart](lib/providers/fruit_provider.dart) — จัดการผลไม้ รายการโปรด และประวัติ
- [database_helper.dart](lib/core/database_helper.dart) — เปิด SQLite สร้างตาราง และจัดการข้อมูล
- [detection_helper.dart](lib/core/detection_helper.dart) — โหลดโมเดลและประมวลผลภาพ

## เอกสารโปรเจกต์

| เอกสาร | เนื้อหา |
|---|---|
| [01 Project Overview](PROJECT_DOCUMENTATION/01_PROJECT_OVERVIEW.md) | ภาพรวม วัตถุประสงค์ และขอบเขต |
| [02 File Explanation](PROJECT_DOCUMENTATION/02_FILE_EXPLANATION.md) | หน้าที่ของไฟล์และโค้ดแต่ละส่วน |
| [03 Features](PROJECT_DOCUMENTATION/03_FEATURES.md) | ฟีเจอร์และสถานะการทำงาน |
| [04 System Flow](PROJECT_DOCUMENTATION/04_SYSTEM_FLOW.md) | ลำดับการทำงานและการไหลของข้อมูล |
| [05 Architecture](PROJECT_DOCUMENTATION/05_ARCHITECTURE.md) | โครงสร้างและความสัมพันธ์ของระบบ |
| [06 Technologies](PROJECT_DOCUMENTATION/06_TECHNOLOGIES.md) | เทคโนโลยีและ dependencies |
| [07 Development Summary](PROJECT_DOCUMENTATION/07_DEVELOPMENT_SUMMARY.md) | สรุปสถานะการพัฒนา |
| [08 Limitations](PROJECT_DOCUMENTATION/08_LIMITATIONS.md) | ข้อจำกัดและแนวทางพัฒนาต่อ |
| [09 Presentation Guide](PROJECT_DOCUMENTATION/09_PRESENTATION_GUIDE.md) | แนวทางนำเสนอโปรเจกต์ |
| [10 QA Preparation](PROJECT_DOCUMENTATION/10_QA_PREPARATION.md) | คำถามและคำตอบสำหรับเตรียมนำเสนอ |

## สถานะและข้อจำกัด

- สร้าง debug APK และตรวจหน้าจอหลักบน Android Emulator แล้ว แต่ยังไม่มีผลประเมินความแม่นยำหรือความเร็วของการจำแนกภาพอย่างเป็นทางการ
- การสแกนหลักใช้ปุ่มถ่ายภาพ ยังไม่มีการยืนยันระบบจำแนกภาพต่อเนื่องแบบ real-time
- ช่องค้นหาปัจจุบันยังไม่รองรับการพิมพ์คำค้น
- ค่าทางโภชนาการ Health Score และคำแนะนำเป็นข้อมูลที่กำหนดไว้ ไม่มีการวัดน้ำหนักผลไม้หรือโมเดลแนะนำเฉพาะบุคคล
- การอัปเกรดฐานข้อมูลปัจจุบันลบตารางเดิมแล้วสร้างใหม่ จึงยังไม่รักษารายการโปรดและประวัติเมื่อมีการอัปเกรด schema
- มีโฟลเดอร์แพลตฟอร์มอื่น แต่ยังไม่ยืนยันการทำงานครบทุกแพลตฟอร์ม โดย iOS ยังต้องเตรียมสิทธิ์กล้องเพิ่มเติม
- Widget test ที่มีอยู่ยังไม่ได้ยืนยันว่าผ่าน และการตั้งค่า release ปัจจุบันใช้ debug signing

ดูรายละเอียดเพิ่มเติมใน [ข้อจำกัดของโปรเจกต์](PROJECT_DOCUMENTATION/08_LIMITATIONS.md)

## ผู้จัดทำ

- นายศุภโชค แสงจันทร์ — 67543210066-6
- นายวรรธนะ คำมาลัย — 67543210023-7
