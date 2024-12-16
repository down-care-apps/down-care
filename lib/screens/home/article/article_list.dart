import 'package:down_care/screens/home/article/article_card.dart';
import 'package:flutter/material.dart';
import 'package:down_care/api/articles_service.dart';
import 'package:down_care/screens/home/article/article_detail.dart';
import 'package:intl/intl.dart';
import 'package:down_care/utils/transition.dart';

class ArticleListPage extends StatelessWidget {
  const ArticleListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Artikel'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: ArticlesService().getArticles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading articles: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Tidak ada artikel yang tersedia.'),
            );
          } else {
            final articles = snapshot.data!;
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                final formattedDate = article['date'] != null ? _parseCustomDate(article['date']) : 'Unknown Date';

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ArticleCard(
                    title: article['title'] ?? 'Untitled',
                    imageUrl: article['thumbnailURL'],
                    date: formattedDate,
                    onTap: () {
                      Navigator.push(
                        context,
                        createRoute(
                          ArticleDetailPage(
                            title: article['title'] ?? 'Untitled',
                            imageUrl: article['thumbnailURL'],
                            content: article['content'] ?? 'No content available.',
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Custom function to parse the date
  String _parseCustomDate(String dateString) {
    try {
      final parsedDate = DateFormat('dd-MM-yyyy HH:mm:ss').parse(dateString);
      return DateFormat('dd MMM yyyy').format(parsedDate); // Format as '11 May 2024'
    } catch (e) {
      return 'Invalid Date';
    }
  }
}
