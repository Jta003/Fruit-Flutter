import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/fruit.dart';
import '../models/scan_history.dart';
import '../core/database_helper.dart';

class FruitProvider with ChangeNotifier {
  List<Fruit> _fruits = [];
  List<ScanHistoryItem> _history = [];
  bool _isLoading = false;

  List<Fruit> get fruits => _fruits;
  List<ScanHistoryItem> get history => _history;
  bool get isLoading => _isLoading;

  List<Fruit> get favorites => _fruits.where((f) => f.isFavorite).toList();

  Future<void> loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _fruits = await DatabaseHelper.instance.readAllFruits();
      await loadHistory();
    } catch (e) {
      debugPrint('Error loading initial data: \$e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadHistory() async {
    final rawHistory = await DatabaseHelper.instance.readHistory();
    _history = rawHistory.map((json) => ScanHistoryItem.fromJson(json)).toList();
    notifyListeners();
  }

  Future<void> addScanHistory(Fruit fruit) async {
    final now = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
    await DatabaseHelper.instance.insertHistory(fruit.id!, now);
    await loadHistory();
  }

  Future<void> removeHistoryItem(int historyId) async {
    await DatabaseHelper.instance.deleteHistory(historyId);
    _history.removeWhere((item) => item.historyId == historyId);
    notifyListeners();
  }

  Future<void> clearAllHistory() async {
    await DatabaseHelper.instance.clearHistory();
    _history.clear();
    notifyListeners();
  }

  Future<void> toggleFavorite(Fruit fruit) async {
    if (fruit.id == null) return;
    
    final newStatus = !fruit.isFavorite;
    await DatabaseHelper.instance.updateFavorite(fruit.id!, newStatus);
    
    // อัปเดตในลิสต์ผลไม้หลัก
    final index = _fruits.indexWhere((f) => f.id == fruit.id);
    if (index != -1) {
      _fruits[index] = fruit.copyWith(isFavorite: newStatus);
      
      // อัปเดตในประวัติด้วย (ถ้ามี)
      for (int i = 0; i < _history.length; i++) {
        if (_history[i].fruit.id == fruit.id) {
          _history[i] = ScanHistoryItem(
            historyId: _history[i].historyId,
            fruit: _fruits[index],
            scanTime: _history[i].scanTime,
          );
        }
      }
      notifyListeners();
    }
  }
}
