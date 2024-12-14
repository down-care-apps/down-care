class ScanHistory {
  final String id;
  final String name;
  final String childrenId;
  final String date;
  final String result;
  final String thumbnailUrl;

  ScanHistory({
    required this.id,
    required this.name,
    required this.childrenId,
    required this.date,
    required this.result,
    required this.thumbnailUrl,
  });

  factory ScanHistory.fromJson(Map<String, dynamic> json) {
    double resultPercent = double.tryParse(json['result'].toString()) ?? 0;
    String percentageString = (resultPercent * 100).toString();

    return ScanHistory(
      id: json['id'] ?? 'Unknown',
      name: json['title'] ?? 'Unknown',
      childrenId: json['childrenId'] ?? 'Unknown',
      date: json['createdAt'] ?? '',
      result: percentageString,
      thumbnailUrl: json['imageScan'] ?? '',
    );
  }
}
