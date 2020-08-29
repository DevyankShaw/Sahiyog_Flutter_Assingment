class SwipeListItem {
  const SwipeListItem({this.id, this.name});

  final String name;
  final int id;

  factory SwipeListItem.fromJson(Map<String, dynamic> json) {
    return SwipeListItem(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}
