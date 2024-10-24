class TallyItem {
  final int? id;
  final String name;
  int count;

  TallyItem({
    this.id,
    required this.name,
    required this.count,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'count': count,
    };
  }

  factory TallyItem.fromMap(Map<String, dynamic> map) {
    return TallyItem(
      id: map['id'],
      name: map['name'],
      count: map['count'],
    );
  }
}
