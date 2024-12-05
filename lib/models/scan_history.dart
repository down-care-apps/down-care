class ScanHistory {
  final String name;
  final String childrenId;
  final String date;
  final String result;
  final String thumbnailUrl;

  ScanHistory({
    required this.name,
    required this.childrenId,
    required this.date,
    required this.result,
    required this.thumbnailUrl,
  });

  factory ScanHistory.fromJson(Map<String, dynamic> json){
    double resultPercent = double.tryParse(json['result'].toString()) ?? 0;
    String percentageString = (resultPercent * 100).toString();


    return ScanHistory(
      name: json['title'] ?? 'Unknown',
      childrenId:  json['childrenId'] ??'Unknown', // Placeholder
      date: json['createdAt'] ?? '',
      result: percentageString,
      thumbnailUrl: json['imageScan'] ?? '',
    );
  }
}
