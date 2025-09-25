import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/scan_result.dart';

class StorageService {
  Future<void> appendHistory(ScanResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(kPrefHistory) ?? <String>[];
    list.add(jsonEncode(result.toJson()));
    await prefs.setStringList(kPrefHistory, list);
  }

  Future<List<ScanResult>> readHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(kPrefHistory) ?? <String>[];
    final results = <ScanResult>[];
    for (final raw in list) {
      try {
        final json = jsonDecode(raw);
        if (json is Map<String, dynamic>) {
          results.add(ScanResult.fromJson(json));
        }
      } catch (_) {
        continue;
      }
    }
    return results;
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(kPrefHistory);
  }
}










