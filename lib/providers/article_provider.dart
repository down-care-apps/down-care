import 'package:down_care/api/articles_service.dart';
import 'package:down_care/models/article_model.dart';
import 'package:flutter/foundation.dart';

class ArticlesProvider with ChangeNotifier {
  List<Article> _articles = [];
  Article? _selectedArticle;
  bool _isLoading = false;
  String? _error;

  List<Article> get articles => _articles;
  Article? get selectedArticle => _selectedArticle;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final ArticlesService _articlesService = ArticlesService();

  Future<void> fetchArticles({int? limit}) async {
    if (_isLoading) return;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final articlesData = await _articlesService.getArticles(limit: limit);
      _articles = articlesData.map((json) => Article.fromJson(json)).toList();

      // Optional: Sort articles by date
      _articles.sort((a, b) => b.parsedDate.compareTo(a.parsedDate));

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchArticleById(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final articleData = await _articlesService.getArticleById(id);
      _selectedArticle = Article.fromJson(articleData);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Optional: Clear selected article
  void clearSelectedArticle() {
    _selectedArticle = null;
    notifyListeners();
  }

  // Optional: Get articles filtered by criteria
  List<Article> getFilteredArticles({
    String? searchQuery,
    int? limit,
  }) {
    var filteredArticles = _articles;

    if (searchQuery != null && searchQuery.isNotEmpty) {
      filteredArticles = filteredArticles
          .where((article) =>
              article.title.toLowerCase().contains(searchQuery.toLowerCase()) || article.content.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    if (limit != null) {
      filteredArticles = filteredArticles.take(limit).toList();
    }

    return filteredArticles;
  }

  List<Article> getArticlesByCategory(String category) {
    return _articles.where((article) => article.category?.toLowerCase() == category.toLowerCase()).toList();
  }
}
