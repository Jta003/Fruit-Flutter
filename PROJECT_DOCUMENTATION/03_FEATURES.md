# ฟีเจอร์ของโปรเจกต์ Flutter

> ตรวจจากไฟล์ Flutter ปัจจุบัน วันที่ 8 ตุลาคม 2569 ขอบเขตคือ root ของ app_ar_v1 และโค้ดใน lib ไม่รวมโปรเจกต์ Unity ตามคำยืนยันของผู้ใช้ ไม่แก้ไข source หรือ configuration สถานะจากการอ่านโค้ดไม่เท่ากับผลทดสอบบนอุปกรณ์

## ความหมายของสถานะ
“มีโค้ดและเชื่อมแล้ว” ยืนยันจาก caller และการอ่าน source “พัฒนาบางส่วน” มี UI หรือ logic แต่ความสามารถยังไม่ครบ “ยังไม่ยืนยัน runtime” ไม่มีผลทดสอบบนอุปกรณ์จากการตรวจครั้งนี้ จึงไม่ติดป้ายว่าใช้งานจริงสำเร็จเพียงเพราะมี class

## 1 หน้าแรกและรายการผลไม้

- ผู้ใช้ใช้งาน: เลือกจาก Explore All Fruits หรือการ์ดแนะนำ แล้วเปิดรายละเอียด
- ทำงานเบื้องหลัง: Home อ่าน fruits, history และ isLoading จาก FruitProvider แสดง Recent Scans สูงสุด 6 รายการตามลำดับที่ provider ส่งมา ไม่ได้กำจัดผลไม้ซ้ำ
- ไฟล์หลัก: [lib/screens/home_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/home_screen.dart)
- ที่มาข้อมูล: SQLite ผ่าน FruitProvider
- สถานะ: มีโค้ดและเชื่อมแล้ว ยังไม่มีผลทดสอบ runtime ในการตรวจนี้

## 2 คำแนะนำตามหมวด

- ผู้ใช้ใช้งาน: แตะหมวดทั้งหมด ภูมิคุ้มกัน เพิ่มพลังงาน คุมน้ำหนัก หรือต้านอนุมูลอิสระ
- ทำงานเบื้องหลัง: เปลี่ยน _selectedGoalIndex แล้วกรองรายการ recommendations ที่เขียนไว้ ไม่เรียนรู้จากผู้ใช้ ไม่วิเคราะห์ประวัติสุขภาพ
- ไฟล์หลัก: [lib/screens/home_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/home_screen.dart)
- ที่มาข้อมูล: ข้อความคงที่ในไฟล์และ Fruit ที่จับคู่ kind
- สถานะ: มีโค้ดและเชื่อมแล้ว เป็นการกรองข้อความ ไม่ใช่ AI recommendation

## 3 Normal Scan

- ผู้ใช้ใช้งาน: เปิด Scan เลือก Normal Scan จัดผลไม้ในกรอบแล้วกดปุ่มถ่าย
- ทำงานเบื้องหลัง: CameraController.takePicture ส่ง path ไป classifyImagePath จับคู่ label กับ Fruit แล้ว _selectFruit รอ 500 ms และเรียก callback ใน AppShell เพื่อบันทึกประวัติและเปิด Detail
- ไฟล์หลัก: [lib/screens/scan_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/scan_screen.dart)
- ที่มาข้อมูล: ภาพที่ถ่าย TFLite/ML Kit และ Fruit จาก SQLite
- สถานะ: มีโค้ดและเชื่อมแล้ว ความแม่นยำและความพร้อมของกล้องยังไม่ยืนยัน

## 4 การจำแนกภาพ

- ผู้ใช้ใช้งาน: ทำงานหลังถ่ายภาพในสองหน้าสแกน
- ทำงานเบื้องหลัง: อ่านไฟล์ ตัดกลางภาพ ย่อ 224×224 normalize RGB เรียก Interpreter แล้วใช้คะแนนสูงสุด ถ้าต่ำกว่า 0.55 ลอง ML Kit และท้ายสุดคืน bestResult ได้แม้ต่ำกว่าเกณฑ์
- ไฟล์หลัก: [lib/core/detection_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/detection_helper.dart)
- ที่มาข้อมูล: assets/models/fruit_model.tflite และ labels.txt
- สถานะ: มีโค้ดและ assets ไม่มี accuracy test หรือ training report ที่ยืนยัน

## 5 ทางเลือกจำลองผล

- ผู้ใช้ใช้งาน: แตะชื่อผลไม้ในแถบเลือกด่วนของหน้าสแกน
- ทำงานเบื้องหลัง: ข้ามการจำแนกแล้วส่ง Fruit ที่เลือกพร้อมคะแนนคงที่ 0.99 Normal Scan เปิด Detail ส่วน overlay แสดงการ์ดก่อนยืนยัน
- ไฟล์หลัก: [lib/screens/ar_scan_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/ar_scan_screen.dart)
- ที่มาข้อมูล: ผลไม้ใน Provider ค่า 0.99 กำหนดในโค้ด
- สถานะ: มีโค้ดและเชื่อมแล้ว ต้องแยกจากผล AI จริง

## 6 ข้อมูลซ้อนบนกล้อง

- ผู้ใช้ใช้งาน: สลับไป AR Mode ถ่ายภาพหรือเลือกเอง ดูการ์ด แล้วกดยืนยันหรือสแกนใหม่
- ทำงานเบื้องหลัง: ใช้ Stack/Positioned และ AnimationController สำหรับเส้นสแกน pulse slide และ fade ไม่ตรวจพื้นผิวหรือ anchor ยืนยันแล้วจึง callback และบันทึก history
- ไฟล์หลัก: [lib/screens/ar_scan_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/ar_scan_screen.dart)
- ที่มาข้อมูล: CameraPreview และ Fruit ที่จับคู่ผลจำแนก
- สถานะ: มีโค้ดและเชื่อมแบบ 2D ไม่มี AR ที่ใช้งานจริงใน Flutter

## 7 รายละเอียดโภชนาการ

- ผู้ใช้ใช้งาน: แตะผลไม้จาก Home รายการ History หรือ Favorites
- ทำงานเบื้องหลัง: DetailScreen อ่าน Fruit ปัจจุบันจาก Provider ตาม id แสดงชื่อ รูป 2D หน่วยบริโภค Health Score และค่าต่าง ๆ แยกเป็นการ์ดและแถว
- ไฟล์หลัก: [lib/screens/detail_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/detail_screen.dart)
- ที่มาข้อมูล: ข้อมูลเริ่มต้นใน SQLite ไม่ใช่ค่าที่วัดจากภาพ
- สถานะ: มีโค้ดและเชื่อมแล้ว ยังต้องยืนยันหน่วยและแหล่งข้อมูล

## 8 การเปรียบเทียบสองชนิด

- ผู้ใช้ใช้งาน: กดเปรียบเทียบใน Detail เลือกชนิดที่สอง แล้วแตะการ์ดเพื่อเปลี่ยนซ้ายหรือขวา
- ทำงานเบื้องหลัง: FruitSelectionSheet ตัด id ของผลไม้อีกฝั่งออก CompareScreen เก็บ _left/_right และส่งค่าพลังงาน ใยอาหาร น้ำตาล Vitamin C ให้ CompareBar
- ไฟล์หลัก: [lib/screens/detail_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/detail_screen.dart)
- ที่มาข้อมูล: Fruit สองรายการจาก Provider
- สถานะ: มีโค้ดและเชื่อมแล้ว ข้อความ AI Insight ยังไม่วิเคราะห์ค่าจริง

## 9 เพิ่มและนำรายการโปรดออก

- ผู้ใช้ใช้งาน: กดหัวใจใน Detail หรือปัดการ์ด Favorites จากขวาไปซ้าย
- ทำงานเบื้องหลัง: toggleFavorite อัปเดต SQLite เปลี่ยน Fruit ด้วย copyWith แล้วอัปเดตผลไม้ใน history และ notifyListeners
- ไฟล์หลัก: [lib/providers/fruit_provider.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/providers/fruit_provider.dart)
- ที่มาข้อมูล: คอลัมน์ isFavorite ของ fruits
- สถานะ: มีโค้ดและเชื่อมแล้ว ยังไม่มีการทดสอบ persistence ในการตรวจนี้

## 10 สรุปรายการโปรด

- ผู้ใช้ใช้งาน: เปิดแท็บ Fav ดูจำนวนและค่าเฉลี่ยของรายการ
- ทำงานเบื้องหลัง: favorites กรอง isFavorite หน้า Favorites คำนวณค่าเฉลี่ย kcal และ score ของชุดที่บันทึก ถ้าไม่มีรายการแสดง empty state
- ไฟล์หลัก: [lib/screens/favorites_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/favorites_screen.dart)
- ที่มาข้อมูล: FruitProvider.favorites
- สถานะ: มีโค้ดและเชื่อมแล้ว ไม่ใช่การรวมสารอาหารที่รับประทานจริง

## 11 ประวัติ

- ผู้ใช้ใช้งาน: เปิด History แตะเปิด Detail กดค้างลบรายรายการ หรือแตะปุ่มล้างทั้งหมด
- ทำงานเบื้องหลัง: เพิ่ม id และเวลาผ่าน Provider อ่าน JOIN ข้อมูลผลไม้กับ scan_history ลบรายรายการมี dialog ยืนยัน ล้างทั้งหมดเรียก clearAllHistory โดยตรง
- ไฟล์หลัก: [lib/screens/history_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/history_screen.dart)
- ที่มาข้อมูล: scan_history และ fruits ใน SQLite
- สถานะ: มีโค้ดและเชื่อมแล้ว เวลาที่โชว์ใน HistoryRow ยังเป็นข้อความ fallback

## 12 Search Fruits

- ผู้ใช้ใช้งาน: แตะแท็บ Search แล้วเลือกจากรายการ
- ทำงานเบื้องหลัง: อ่าน fruits ทั้งหมด สร้าง HistoryRow แต่แถบ Search nutrition ใช้ Text ไม่มี TextField หรือ query
- ไฟล์หลัก: [lib/screens/search_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/search_screen.dart)
- ที่มาข้อมูล: ผลไม้ทั้งหมดจาก Provider
- สถานะ: พัฒนาบางส่วน เลือกรายการได้ แต่พิมพ์ค้นหาไม่ได้

## 13 ไฟฉายและปิดกล้อง

- ผู้ใช้ใช้งาน: ใน Normal Scan แตะปุ่มไฟฉายหรือปุ่มปิด
- ทำงานเบื้องหลัง: สลับ FlashMode.torch/off ปิดหน้ากล้องโดยเลือก tab Home และ dispose controller
- ไฟล์หลัก: [lib/screens/scan_screen.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/screens/scan_screen.dart)
- ที่มาข้อมูล: CameraController ของอุปกรณ์
- สถานะ: มีโค้ดเชื่อมแล้ว ต้องยืนยันอุปกรณ์รองรับและการจัดการ error

## สิ่งที่ไม่พบในเส้นทาง Flutter
ไม่พบ QR decoder, marker tracking, ARCore session, 3D placement, API backend, Firebase, login, บันทึกอาหารที่กิน หรือ dashboard ผู้ดูแล ชื่อไอคอน qr_code_scanner และชื่อ ArScanScreen ไม่ใช่หลักฐานว่ามีระบบเหล่านั้น

ไฟล์สนับสนุนร่วม: [lib/main.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/main.dart), [lib/core/database_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/database_helper.dart), [lib/widgets/fruit_selection_sheet.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/fruit_selection_sheet.dart), [lib/widgets/fruit_cards.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/fruit_cards.dart), [lib/widgets/fruit_art.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/fruit_art.dart) และ [lib/widgets/ar_overlay_painter.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/ar_overlay_painter.dart)
