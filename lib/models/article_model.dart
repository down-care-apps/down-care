import 'package:intl/intl.dart';

class Article {
  final String id;
  final String title;
  final String content;
  final String date;
  final String author;
  final String? thumbnailURL;

  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.author,
    this.thumbnailURL,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      date: json['date'] ?? '',
      author: json['author'] ?? '',
      thumbnailURL: json['thumbnailURL'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date,
      'author': author,
      'thumbnailURL': thumbnailURL,
    };
  }

  // Helper method to parse date
  DateTime get parsedDate {
    try {
      return DateFormat('dd-MM-yyyy HH:mm:ss').parse(date);
    } catch (e) {
      return DateTime.now();
    }
  }
}
