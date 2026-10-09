import 'fruit.dart';

class ScanHistoryItem {
  final int historyId;
  final Fruit fruit;
  final String scanTime;

  ScanHistoryItem({
    required this.historyId,
    required this.fruit,
    required this.scanTime,
  });

  factory ScanHistoryItem.fromJson(Map<String, dynamic> json) {
    return ScanHistoryItem(
      historyId: json['historyId'] as int,
      fruit: Fruit.fromJson(json),
      scanTime: json['scanTime'] as String,
    );
  }
}
