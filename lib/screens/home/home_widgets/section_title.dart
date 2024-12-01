import 'package:down_care/screens/home/article/article_list.dart';
import 'package:down_care/utils/transition.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final bool seeAll;

  const SectionTitle({super.key, required this.title, this.seeAll = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.leagueSpartan(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        if (seeAll)
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                createRoute(const ArticleListPage()),
              );
            },
            child: Row(
              children: [
                Text(
                  'Lihat Semua',
                  style: GoogleFonts.leagueSpartan(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black38),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black38),
              ],
            ),
          ),
      ],
    );
  }
}
