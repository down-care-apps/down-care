class ScanHistory {
  final String name;
  final String date;
  final String result;
  final String thumbnailUrl;

  ScanHistory({
    required this.name,
    required this.date,
    required this.result,
    required this.thumbnailUrl,
  });

  factory ScanHistory.fromJson(Map<String, dynamic> json) {
    return ScanHistory(
      name: json['title'] ?? 'Unknown',
      date: json['createdAt'] ?? '',
      result: json['result'].toString() ?? '0',
      thumbnailUrl: json['imageURL'] ?? '',
    );
  }
}
