import 'package:flutter/material.dart';

class ArticleTranslokasi extends StatelessWidget {
  const ArticleTranslokasi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF5174FF)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Kembali', style: TextStyle(color: Color(0xFF5174FF))),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('12.05.2021', style: TextStyle(color: Colors.grey[600])),
                  SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset('assets/Translokasi.jpg'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Cara Merawat Anak Down Syndrome',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  SizedBox(height: 5),
                  Divider(
                    color: Colors.grey[400],
                    thickness: 1,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Merawat anak dengan down syndrome membutuhkan pendekatan penuh kasih, kesabaran, dan dukungan untuk membantu mereka tumbuh optimal. Pertama, penting untuk memberikan stimulasi dini, seperti terapi fisik, wicara, dan okupasi, yang dapat mendukung perkembangan motorik, komunikasi, dan keterampilan sosial mereka. Mengikuti rutinitas harian yang konsisten membantu anak merasa aman dan terstruktur. Selain itu, perhatian pada kesehatan mereka juga penting, karena anak dengan down syndrome rentan terhadap masalah medis tertentu.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
