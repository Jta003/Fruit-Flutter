# คำถามเตรียมตอบอาจารย์

> บทเตรียมนำเสนอจาก source Flutter วันที่ 8 ตุลาคม 2569 ไม่รวม Unity และไม่อ้างผลทดสอบที่ไม่มีหลักฐาน ชื่อ AR Mode ใน Flutter เป็นข้อมูลซ้อนบนกล้อง 2D เอกสารนี้ยังไม่ใช่ไฟล์สไลด์

แนวตอบต่อไปนี้มี 34 ข้อ อ้างอิง source และระบุส่วนที่ต้องสอบถามผู้พัฒนาเพิ่มเติม ไม่อ้างผลทดสอบจากชื่อไฟล์หรือความคิดเห็นในโค้ด

## 1 โครงงานนี้ทำอะไร

เป็นแอป Flutter จำแนกชนิดผลไม้จากภาพถ่ายแล้วแสดงโภชนาการที่เก็บไว้ใน SQLite พร้อมเลือกจากรายการ เปรียบเทียบ รายการโปรดและประวัติ

หลักฐาน: [lib/main.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/main.dart)

## 2 ทำไมเลือกหัวข้อนี้

โครงร่างต้องการให้เข้าถึงข้อมูลพลังงาน น้ำตาลและวิตามินสะดวกขึ้น เหตุผลส่วนตัวหรือผลสำรวจปัญหาต้องสอบถามผู้จัดทำ ไม่มีสถิติผู้ใช้ที่เก็บไว้

หลักฐาน: [lib/screens/detail_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/detail_screen.dart)

## 3 ทำไมเลือก Flutter

หลักฐานว่าพัฒนา Flutter คือ MaterialApp, widgets, Dart และ pubspec ส่วนเหตุผลเลือก framework จากผู้พัฒนาโดยตรงยังไม่ระบุชัด ต้องสอบถามเพิ่ม ไม่ยืนยันว่าเร็วหรือดีกว่า framework อื่นจากโค้ดอย่างเดียว

หลักฐาน: [pubspec.yaml](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/pubspec.yaml)

## 4 ทำไมเลือก Unity

คำถามนี้ไม่ตรงกับส่วน Flutter ที่นำเสนอ งาน Unity แยกโฟลเดอร์และอยู่นอกขอบเขตครั้งนี้ แอปส่วนนี้ใช้ Flutter/Dart ไม่ใช่ Unity runtime

หลักฐาน: [lib/main.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/main.dart)

## 5 AR ทำงานอย่างไร

Flutter ยังไม่มี AR ที่ใช้งานจริง ArScanScreen ใช้กล้องกับ Stack/CustomPainter วางข้อมูลในพิกัดจอ ไม่มี plane, anchor หรือ world tracking

หลักฐาน: [lib/screens/ar_scan_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/ar_scan_screen.dart)

## 6 ชื่อ AR Mode หมายความว่ามี ARCore หรือไม่

ไม่ได้ยืนยันจากชื่อ โค้ดเป็น overlay 2D และ pubspec ไม่มี AR Flutter plugin อธิบายชื่อเมนูกับ implementation แยกกัน

หลักฐาน: [pubspec.yaml](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/pubspec.yaml)

## 7 ใช้ QR หรือ Marker หรือไม่

ไม่พบ decoder หรือ mobile_scanner ใน dependencies ปัจจุบัน ใช้ภาพถ่ายเข้า TFLite ชื่อ icon qr_code_scanner ใช้เป็นไอคอนเมนูเท่านั้น

หลักฐาน: [lib/screens/scan_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/scan_screen.dart)

## 8 ผลไม้ที่รองรับมีกี่ชนิด

9 ชนิด apple banana orange mango grapes strawberry kiwi chickoo cherry มีทั้ง FruitKind, seed และ labels ไม่แปลว่าทดสอบความแม่นยำครบทุกชนิดแล้ว

หลักฐาน: [lib/models/fruit.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/models/fruit.dart)

## 9 ข้อมูลโภชนาการมาจากไหน

มาจากข้อมูลเริ่มต้นที่กำหนดใน DatabaseHelper แล้ว seed SQLite บันทึกเก่าอ้าง Thai FCD แต่ไม่มี record/source/หน่วยรายค่าให้ตรวจครบ ต้องยืนยันแหล่งกับผู้พัฒนา

หลักฐาน: [lib/core/database_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/database_helper.dart)

## 10 AI วัดน้ำตาลหรือแคลอรีจากภาพหรือไม่

โมเดลคืนชนิดและคะแนน แล้วจับคู่ Fruit เพื่ออ่านสารอาหารที่เก็บไว้ ไม่วัดน้ำหนักหรือสารอาหารของวัตถุจริงในภาพ

หลักฐาน: [lib/core/detection_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/detection_helper.dart)

## 11 ภาพเข้าโมเดลอย่างไร

อ่านไฟล์ ตัดกลางภาพเป็นสี่เหลี่ยม ย่อ 224×224 normalize RGB ด้วย (value−127.5)/127.5 แล้วเรียก Interpreter จัด input [1,224,224,3] ตามโค้ด ยังไม่ตรวจ metadata จริงผ่าน runtime

หลักฐาน: [lib/core/detection_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/detection_helper.dart)

## 12 เป็นการสแกน real time หรือไม่

กล้องแสดงภาพสด แต่หน้าสแกนเรียก takePicture เมื่อกดปุ่มแล้วจำแนกหนึ่งภาพ processCameraFrame มี helper แต่ไม่พบ caller แบบต่อเนื่องในหน้าจอปัจจุบัน

หลักฐาน: [lib/screens/scan_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/scan_screen.dart)

## 13 TFLite กับ ML Kit ต่างกันในโปรเจกต์นี้อย่างไร

TFLite เป็นโมเดลผลไม้ที่โหลดจาก assets ส่วน ML Kit ImageLabeler เป็นทางสำรองเมื่อคะแนนโมเดลหลักต่ำหรือไม่สำเร็จ และพยายามจับ label กับชื่อใน labels

หลักฐาน: [lib/core/detection_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/detection_helper.dart)

## 14 เกณฑ์ความมั่นใจเท่าไร

ตั้ง 0.55 สำหรับคืนผล TFLite ทันที แต่ยังคืน bestResult ต่ำกว่าเกณฑ์ที่ท้ายฟังก์ชันได้ จึงไม่ใช่การปฏิเสธต่ำกว่า 55% อย่างเคร่งครัด ML Kit ตั้ง 0.35

หลักฐาน: [lib/core/detection_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/detection_helper.dart)

## 15 ความแม่นยำ 100% จริงหรือไม่

มีคำกล่าวในบันทึก แต่ไม่พบ test set วิธีคำนวณหรือผล accuracy จึงยังยืนยัน 100% ไม่ได้ คะแนนของภาพหนึ่งภาพก็ไม่ใช่ accuracy ของทั้งระบบ

หลักฐาน: [สิ่งที่ทำวันนี้.md](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/สิ่งที่ทำวันนี้.md)

## 16 ปุ่มเลือกผลไม้ด่วนใช้ AI หรือไม่

เป็นทางเลือกจำลอง ผู้ใช้เลือก Fruit เองและโค้ดตั้ง 0.99 ค่านี้ไม่ได้มาจากโมเดล ต้องแยกเวลาสาธิตหรือรายงานผล

หลักฐาน: [lib/screens/ar_scan_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/ar_scan_screen.dart)

## 17 แอปใช้ internet หรือ server หรือไม่

ไม่พบ API backend/Firebase สำหรับข้อมูลผลไม้ ข้อมูลหลักอยู่ใน SQLite และโมเดลฝังใน assets การทำงานจริงและเงื่อนไข runtime ของ plugin ต้องตรวจบนอุปกรณ์เพิ่มเติม

หลักฐาน: [lib/core/database_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/database_helper.dart)

## 18 ทำไมใช้ Provider

โครงร่างระบุว่าไม่ซับซ้อนและช่วยแยก logic จาก UI ใน code FruitProvider เก็บ fruits/history/favorites และ notifyListeners ให้หน้า watch สร้างใหม่

หลักฐาน: [lib/providers/fruit_provider.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/providers/fruit_provider.dart)

## 19 ทำไมใช้ SQLite

โครงร่างเลือกข้อมูลภายในเครื่องที่มีจำนวนไม่มากและไม่ต้องมี server โค้ดใช้ sqflite เปิดไฟล์ DB และเก็บรายการโปรด/ประวัติในเครื่อง

หลักฐาน: [lib/core/database_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/database_helper.dart)

## 20 ฐานข้อมูลเก็บอะไรบ้าง

fruits เก็บชื่อ ชนิดสารอาหาร หน่วย score และ isFavorite ส่วน scan_history เก็บ id fruitId scanTime ไม่เก็บ confidence หรือภาพที่ถ่าย

หลักฐาน: [lib/core/database_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/database_helper.dart)

## 21 ประวัติเรียงถูกทุกกรณีหรือไม่

เรียง scanTime DESC แต่เวลาคือ dd/MM/yyyy HH:mm แบบข้อความ จึงอาจไม่ตรงเวลาเมื่อข้ามเดือน/ปี ต้องปรับ timestamp/ISO และทดสอบ

หลักฐาน: [lib/providers/fruit_provider.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/providers/fruit_provider.dart)

## 22 เพิ่มลบรายการโปรดทำงานอย่างไร

กดหัวใจเรียก toggleFavorite อัปเดต isFavorite ใน SQLite แทน Fruit ใน provider ด้วย copyWith และอัปเดต history หน้า Favorites watch ชุดที่กรองและปัดนำออกได้

หลักฐาน: [lib/screens/favorites_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/favorites_screen.dart)

## 23 เปรียบเทียบอะไรได้

สองชนิด เปรียบเทียบ Energy, Fiber, Sugar, Vitamin C และเปลี่ยนซ้ายขวาได้โดยเลือกจาก sheet ที่ตัดชนิดของอีกฝั่งออก

หลักฐาน: [lib/screens/detail_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/detail_screen.dart)

## 24 AI Insight ใน Compare คำนวณจากข้อมูลหรือไม่

ข้อความใช้ชื่อฝั่งซ้ายขวาโดยไม่เปรียบเทียบค่าใน if จึงยังไม่ใช่ข้อสรุปอัตโนมัติที่ยืนยันตามคู่ผลไม้ ต้องปรับ logic ก่อนกล่าวอ้าง

หลักฐาน: [lib/screens/detail_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/detail_screen.dart)

## 25 Search ค้นหาได้หรือยัง

เลือกจากรายการได้ แต่ช่อง Search nutrition เป็น Text ตกแต่ง ไม่มี TextField/query จึงยังพิมพ์ค้นหาไม่ได้

หลักฐาน: [lib/screens/search_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/search_screen.dart)

## 26 Health Score คำนวณอย่างไร

เป็นค่าที่กำหนดใน seed อ่านจาก healthScore ไป Fruit.score ไม่พบสูตรคำนวณหรือการรับข้อมูลสุขภาพส่วนบุคคล ต้องสอบถามเหตุผลของคะแนนจากผู้พัฒนา

หลักฐาน: [lib/models/fruit.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/models/fruit.dart)

## 27 ตัวเลขต่อ 100g กับ servingSize สัมพันธ์กันอย่างไร

หน้า Detail แสดงทั้งข้อความหน่วยบริโภคและหัวข้อ Nutrition Facts ต่อ 100g แต่ไม่มีการปรับตามน้ำหนัก ต้องตรวจหน่วยในข้อมูลและแหล่งต้นทางก่อนอธิบายว่าเท่ากัน

หลักฐาน: [lib/screens/detail_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/detail_screen.dart)

## 28 ทดสอบอย่างไรแล้ว

มี smoke test ตรวจข้อความ Fruit Nutrition และ native testExample ว่าง การตรวจเอกสารครั้งนี้ไม่ได้รัน test/camera/inference ไม่มีอุปกรณ์หรือ benchmark ที่ใช้อ้างผลสำเร็จ

หลักฐาน: [test/widget_test.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/test/widget_test.dart)

## 29 รองรับ iOS หรือ Web แล้วหรือไม่

มี host ของหลาย platform แต่ไม่มีหลักฐานครบฟีเจอร์ และ iOS Info.plist ยังไม่พบ NSCameraUsageDescription จึงยังไม่ยืนยันกล้องหรือ ML ใช้ได้บน iOS และไม่ถือว่า Web พร้อมเพราะมีโฟลเดอร์

หลักฐาน: [ios/Runner/Info.plist](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner/Info.plist)

## 30 อัปเดตแอปแล้วข้อมูลเดิมอยู่หรือไม่

onUpgrade ลบ fruits/scan_history แล้วสร้างใหม่ จึงไม่รักษาข้อมูลเดิมในเส้นทาง upgrade ที่เขียนไว้ ต้องทำ migration และทดสอบก่อนยืนยัน

หลักฐาน: [lib/core/database_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/database_helper.dart)

## 31 รูปผลไม้เป็นโมเดลสามมิติหรือไม่

FruitArt วาดรูปด้วย CustomPainter และ Canvas ตาม FruitKind เป็นภาพ 2D จากโค้ด ไม่ใช่ 3D asset

หลักฐาน: [lib/widgets/fruit_art.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/fruit_art.dart)

## 32 โครงสร้างช่วยพัฒนาต่ออย่างไร

แยก UI, provider, models และ helpers สามารถระบุจุดแก้ข้อมูลหรือกล้องได้ แต่ mapping label ซ้ำสองหน้าสแกน ควรรวมเมื่อได้รับอนุญาตแก้โค้ด

หลักฐาน: [lib/providers/fruit_provider.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/providers/fruit_provider.dart)

## 33 ถ้าเพิ่มผลไม้ใหม่ต้องแก้อะไร

เพิ่ม FruitKind/seed และ FruitPainter สำหรับรายการ หากต้องสแกนด้วย ML ต้องมีโมเดลที่รองรับ class ใหม่กับ labels ที่ตรง output ไม่ใช่เพิ่มข้อมูลใน DB แล้วโมเดลจะรู้จักเอง

หลักฐาน: [assets/models/labels.txt](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/assets/models/labels.txt)

## 34 ถ้าพัฒนาต่อควรทำอะไรก่อน

แก้ mapping และเกณฑ์คะแนน ตรวจข้อมูล/หน่วย ปรับเวลาประวัติและ migration เพิ่ม Search แล้วเก็บผลทดสอบจริง ส่วน AR หรือ cloud เป็นงานต่อยอดที่แยกจากความสามารถปัจจุบัน

หลักฐาน: [lib/core/detection_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/detection_helper.dart)

## ข้อมูลที่ควรถามผู้พัฒนาก่อนตอบเชิงลึก
ผู้รับผิดชอบแต่ละส่วน เหตุผลเลือก Flutter และโมเดล ชุดฝึก/ชุดทดสอบ record โภชนาการ ที่มาของ Health Score อุปกรณ์จริง ผลการทดสอบ และชื่ออาจารย์ของรายวิชา ไม่มีหลักฐานเพียงพอให้แต่งคำตอบแทน

ดู [09 คู่มือนำเสนอ](09_PRESENTATION_GUIDE.md) สำหรับบทพูด และ [08 ข้อจำกัด](08_LIMITATIONS.md) สำหรับแยกสิ่งที่พบจากข้อเสนอพัฒนาต่อ
