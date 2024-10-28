import 'package:flutter/material.dart';

class ArticleCarousel extends StatelessWidget {
  final List<Article> articles;

  const ArticleCarousel({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      height: screenSize.height * 0.2,
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        scrollDirection: Axis.horizontal,
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return _buildArticleCard(context, articles[index], screenSize);
        },
      ),
    );
  }

  Widget _buildArticleCard(BuildContext context, Article article, Size screenSize) {
    return Container(
      width: screenSize.width * 0.7,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12.0),
        image: DecorationImage(
          image: NetworkImage(article.thumbnailUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Text(
          article.title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class Article {
  final String title;
  final String thumbnailUrl;

  Article({required this.title, required this.thumbnailUrl});
}
