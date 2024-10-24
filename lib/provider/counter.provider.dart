import 'package:counter/data/tally_data_base.dart';
import 'package:counter/model/tally_item.dart';
import 'package:flutter/material.dart';

class CountProvider extends ChangeNotifier {
  String _name = "Tallies";
  String get name => _name;

  List<TallyItem> _items = [];
  List<TallyItem> get items => _items;

  /// Load items from the database and notify listeners.
  Future<void> loadItems() async {
    try {
      _items = await TallyDatabase.instance.readAllItems();
      notifyListeners();
    } catch (e) {
      print("Error loading items: $e");
    }
  }

  /// Add a new item to the database and refresh the list.
  Future<void> addItem() async {
    const uniqueName = 'Counter Items';
    final newItem = TallyItem(name: uniqueName, count: 0);
    await TallyDatabase.instance.create(newItem);
    await loadItems(); // Refresh the item list after adding
  }

  /// Update an existing item in the database and the local list.
  Future<void> updateItem(TallyItem item) async {
    final db = await TallyDatabase.instance.database;
    await db.update(
      'tallyItems',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );

    // Update the local item list
    final index = _items.indexWhere((element) => element.id == item.id);
    if (index != -1) {
      _items[index] = item; // Update the item in the list
    }

    notifyListeners();
  }

  /// Increment the count of an item and update it in the database.
  Future<void> incrementCounter(TallyItem item) async {
    item.count++; // Directly modify the item's count
    await updateItem(item); // Persist changes to the database
    notifyListeners(); // Notify listeners after the change
  }

  /// Decrement the count of an item and update it in the database.
  Future<void> decrementCounter(TallyItem item) async {
    item.count--;
    await updateItem(item);
    notifyListeners();
  }

  /// Reset an item's state and update it in the database.
  Future<void> resetState(TallyItem item) async {
    item.count = 0;
    await updateItem(item);
    notifyListeners();
  }

  /// Delete an item from the database and refresh the list.
  Future<void> deleteItem(int id) async {
    await TallyDatabase.instance.delete(id);
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  Future<TallyItem?> getItem(int id) async {
    final db = await TallyDatabase.instance.database;
    final maps = await db.query(
      'tallyItems',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TallyItem.fromMap(maps.first);
    } else {
      return null;
    }
  }
}
