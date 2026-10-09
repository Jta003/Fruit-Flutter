# เทคโนโลยีและเครื่องมือในโปรเจกต์ Flutter

> ตรวจจาก source Flutter ปัจจุบัน วันที่ 8 ตุลาคม 2569 ไม่รวม Unity ตามขอบเขตผู้ใช้ ไม่มีการแก้โค้ดหรือ configuration และไม่รัน build/test ที่อาจสร้างไฟล์นอก PROJECT_DOCUMENTATION การพบโค้ดไม่เท่ากับผลทดสอบ runtime

## ภาษากับแพลตฟอร์ม
Flutter สร้าง UI หลักด้วย Dart ตาม [lib/main.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/main.dart) และ [pubspec.yaml](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/pubspec.yaml) ส่วน Kotlin/Gradle, Swift/Xcode และ C++/CMake เป็น native host และระบบ build ที่เปิด Flutter Engine ไม่ใช่ implementation โภชนาการคนละชุด

pubspec กำหนด Dart SDK ^3.12.2 และ app version 1.0.0+1 ส่วน .metadata ระบุ stable revision ของ template การตรวจนี้ไม่ได้เรียก flutter --version จึงไม่อ้างเลขเวอร์ชัน Flutter ที่ติดตั้งจาก revision เพียงอย่างเดียว

## Dependencies ที่ประกาศและ resolve จริง

| Package | pubspec.yaml | pubspec.lock | การเกี่ยวข้องกับแอป |
|---|---|---|---|
| flutter | SDK | SDK 0.0.0 | framework ไม่ใช่ Flutter release version 0.0.0 |
| provider | ^6.1.2 | 6.1.5+1 | context.watch/read และ ChangeNotifierProvider |
| sqflite | ^2.4.1 | 2.4.3 | ฐานข้อมูลผลไม้และประวัติในเครื่อง |
| path | ^1.9.1 | 1.9.1 | join path ของฐานข้อมูล |
| camera | ^0.12.0 | 0.12.1 | เปิดกล้อง แสดง CameraPreview และ takePicture |
| tflite_flutter | ^0.12.1 | 0.12.1 | Interpreter สำหรับโมเดลที่ฝังใน assets |
| image | ^4.2.0 | 4.10.1 | decode crop และ resize ก่อน inference |
| google_mlkit_image_labeling | ^0.16.1 | 0.16.1 | ImageLabeler สำรองหลัง TFLite |
| google_mlkit_commons | ^0.13.0 | 0.13.0 | InputImage และชนิดข้อมูลของ ML Kit |
| google_mlkit_object_detection | ^0.17.1 | 0.17.1 | ประกาศ dependency แต่ไม่พบใช้ใน helper ปัจจุบัน |
| intl | ^0.19.0 | 0.19.0 | DateFormat ของ scanTime |
| path_provider | ^2.1.6 | 2.1.6 | ประกาศไว้ ไม่พบ direct import ใน lib |
| cupertino_icons | ^1.0.8 | 1.0.9 | ชุดไอคอนที่ประกาศ ไม่พบเป็นแกน logic |
| win32 override | ^5.5.4 | 5.15.0 | dependency override ไม่ใช่ business feature |
| flutter_test | SDK | SDK 0.0.0 | smoke test ใน test/widget_test.dart |
| flutter_lints | ^6.0.0 | 6.0.0 | กฎ analyzer ใน analysis_options.yaml |

^ หมายถึงข้อกำหนดช่วงเวอร์ชัน ส่วน lock คือรุ่นที่ resolve ไว้ ณ ไฟล์ปัจจุบัน การมี package ไม่ยืนยันว่าทุก platform ใช้งานได้ หรือทุก package มี caller จากแอป

หลักฐาน [pubspec.yaml](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/pubspec.yaml), [pubspec.lock](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/pubspec.lock), [lib/core/detection_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/detection_helper.dart), [lib/core/database_helper.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/core/database_helper.dart) และ [lib/providers/fruit_provider.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/providers/fruit_provider.dart)

## รูปภาพและโมเดล
FruitArt วาดผลไม้ทั้ง 9 ด้วย CustomPainter ไม่ใช่ไฟล์รูปถ่ายใน assets โมเดล TFLite มีไฟล์หลักและสำรองขนาด 2,093,132 bytes เท่ากันและ SHA256 ตรงกัน e28a0735dff5c7e896ecfb433d6a756d1affcabb7f9b06d570139238bd1f7460 labels สองไฟล์ขนาด 136 bytes และ hash ตรงกัน มี 9 class

[assets/models/fruit_model.tflite](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/assets/models/fruit_model.tflite), [assets/model_unquant.tflite](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/assets/model_unquant.tflite), [assets/models/labels.txt](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/assets/models/labels.txt), [assets/labels.txt](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/assets/labels.txt) และ [lib/widgets/fruit_art.dart](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/lib/widgets/fruit_art.dart)

ไม่พบ training pipeline, dataset หรือ calibration report ในขอบเขต Flutter จึงยังไม่ยืนยันที่มาของการฝึก รุ่นสถาปัตยกรรม neural network หรือค่าความแม่นยำจาก binary ที่มี

## Android build
- AGP 9.0.1, Kotlin Android plugin 2.3.20 และ Flutter plugin loader 1.0.0 ใน [android/settings.gradle.kts](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/android/settings.gradle.kts)
- Gradle wrapper 9.1.0 ใน [android/gradle/wrapper/gradle-wrapper.properties](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/android/gradle/wrapper/gradle-wrapper.properties)
- JVM 17, namespace/applicationId com.example.app_ar_v1 และ noCompress tflite ใน [android/app/build.gradle.kts](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/android/app/build.gradle.kts)
- compileSdk/minSdk/targetSdk อ้าง Flutter ไม่กำหนดเลขคงที่ในไฟล์ app build
- CAMERA และกล้องเป็น feature ใน [android/app/src/main/AndroidManifest.xml](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/android/app/src/main/AndroidManifest.xml) ไม่มี ARCore session metadata
- release signing ใช้ debug configuration ยังไม่มีหลักฐาน release signing สำหรับเผยแพร่

เครื่องมือ Android Studio กล่าวได้จากไฟล์ module/runner ที่มี แต่ไม่ใช่หลักฐานว่าทดสอบบนอุปกรณ์รุ่นใดสำเร็จแล้ว

## Apple Web และ Desktop
พบ host ของ iOS/macOS/Windows/Linux/Web จึงอธิบายโครงสร้างได้ แต่ยังไม่ยืนยันการใช้งานครบฟีเจอร์ iOS Info.plist ไม่พบ NSCameraUsageDescription ส่วน macOS ไม่พบ camera entitlement ในไฟล์ที่ตรวจ Windows/Linux plugin lists ไม่พบ sqflite native plugin แม้มี tflite_flutter แบบ FFI จึงต้องตรวจความพร้อมของ platform ก่อนอ้างว่ารองรับทั้งหมด

หลักฐาน [ios/Runner/Info.plist](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/ios/Runner/Info.plist), [macos/Runner/DebugProfile.entitlements](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/macos/Runner/DebugProfile.entitlements), [windows/flutter/generated_plugins.cmake](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/windows/flutter/generated_plugins.cmake), [linux/flutter/generated_plugins.cmake](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/linux/flutter/generated_plugins.cmake) และ [web/index.html](C:/Users/jtaku/AndroidStudioProjects/app_ar_v1/web/index.html)

## สิ่งที่ไม่ใช้ใน Flutter ปัจจุบัน
ไม่พบ Unity/C# ใน runtime Flutter, AR Foundation, ARCore Flutter plugin, mobile_scanner, model_viewer_plus, Firebase หรือ REST client สำหรับดึงโภชนาการ การใช้ ML Kit ไม่ใช่หลักฐานว่ามี backend ของแอป และการมีชื่อ AR ใน UI ไม่ใช่การใช้งาน ARCore

## เหตุผลการเลือกเทคโนโลยี
โครงร่างระบุ Provider ใช้งานไม่ซับซ้อนและแยก logic จาก UI และ SQLite เหมาะกับข้อมูลจำนวนน้อยในเครื่องไม่ต้องมี server ส่วนเหตุผลที่ผู้พัฒนาเลือก TFLite หรือเปลี่ยนจาก QR ต้องสอบถามผู้พัฒนาเพิ่ม ไม่อนุมานเหตุผลส่วนบุคคลจาก package names
