import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String SEARCH_HISTORY_KEY = "key_search_history";

class SearchHistory with ChangeNotifier {
  List<String> _histories = [];

  bool get _init => _histories != null;
  List<String> get histories => _histories ?? const [];

  SearchHistory() {
    scheduleMicrotask(() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      _histories = preferences.getStringList(SEARCH_HISTORY_KEY) ?? [];
      notifyListeners();
    });
  }

  void clearSearchHistory() async {
    if (!_init) return;

    _histories.clear();
    notifyListeners();

    final preference = await SharedPreferences.getInstance();
    await preference.remove(SEARCH_HISTORY_KEY);
  }

  void insertSearchHistory(String query) async {
    debugPrint(
        'insert history $query init = $_init , _histories = $_histories');

    if (!_init) return;

    _histories.remove(query);
    _histories.insert(0, query);
    while (_histories.length > 10) {
      _histories.removeLast();
    }
    notifyListeners();

    final preference = await SharedPreferences.getInstance();
    preference.setStringList(SEARCH_HISTORY_KEY, _histories);
  }
  
}
