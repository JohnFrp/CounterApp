import "package:flutter/material.dart";

class CountProvider extends ChangeNotifier {
  String _name = "Tallies";

  String get name => _name;

  int _count = 0;

  int get count => _count;

  void countUp() {
    _count++;
    notifyListeners(); // Notify listeners to rebuild
  }

  void countDown() {
    _count--;
    notifyListeners();
  }

  void resetCount() {
    _count = 0;
    notifyListeners();
  }
}
