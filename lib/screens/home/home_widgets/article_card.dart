import 'package:down_care/utils/transition.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:down_care/screens/home/article/article_detail.dart';

class ArticleCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String content;

  const ArticleCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          createRoute(
            ArticleDetailPage(
              title: title,
              imageUrl: imageUrl,
              content: content,
            ),
          ),
        );
      },
      child: Container(
        width: 270,
        margin: const EdgeInsets.only(right: 16),
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
                child: imageUrl.startsWith('assets/')
                    ? Image.asset(
                        imageUrl,
                        width: double.infinity,
                        height: 120,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        imageUrl,
                        width: double.infinity,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  title,
                  style: GoogleFonts.leagueSpartan(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
