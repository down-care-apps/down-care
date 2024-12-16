import 'package:intl/intl.dart';

class Article {
  final String id;
  final String title;
  final String content;
  final String date;
  final String author;
  final String? thumbnailURL;
  final String? category;

  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.author,
    this.thumbnailURL,
    this.category,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      date: json['date'] ?? '',
      author: json['author'] ?? '',
      thumbnailURL: json['thumbnailURL'],
      category: json['category'],
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
      'category': category,
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
