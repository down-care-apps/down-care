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
    // Convert result to percentage
    double resultPercent = double.tryParse(json['result'].toString()) ?? 0;
    String percentageString = (resultPercent * 100).toString();

    return ScanHistory(
      name: json['title'] ?? 'Unknown',
      date: json['createdAt'] ?? '',
      result: percentageString,
      thumbnailUrl: json['imageScan'] ?? '',
    );
  }
}
