import 'package:flutter/material.dart';
import 'package:news_app/helper/news.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/views/article_view.dart';

class CategoryNews extends StatefulWidget {
  const CategoryNews({Key key, this.category}) : super(key: key);
  final String category;

  @override
  _CategoryNewsState createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  List<ArticleModel> articles = <ArticleModel>[];
  bool _loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategoryNews();
  }

  getCategoryNews() async {
    CategoryNewsClass newsClass = CategoryNewsClass();
    await newsClass.getNews(widget.category);
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              "Flutter",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "News",
              style: TextStyle(color: Colors.green),
            ),
          ],
        ),
        actions: [
          Opacity(
            opacity: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Icon(Icons.save),
            ),
          )
        ],
        elevation: 0.0,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[300],
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                      child: Text(
                        (widget.category).toUpperCase(),
                        style: const TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),

                    // Blogs
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            return BlogTile(
                                imageUrl: articles[index].urlToImage,
                                title: articles[index].title,
                                desc: articles[index].description,
                                url: articles[index].url);
                          }),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

class BlogTile extends StatelessWidget {
  const BlogTile(
      {Key key,
      @required this.imageUrl,
      @required this.title,
      @required this.desc,
      @required this.url})
      : super(key: key);
  final String imageUrl, title, desc, url;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ArticleView(blogUrl: url)));
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                  //bottom
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(4.0, 4.0),
                  blurRadius: 15.0,
                  spreadRadius: 1.0),
              const BoxShadow(
                  //top
                  color: Colors.white,
                  offset: Offset(-5, -5),
                  blurRadius: 6.0,
                  spreadRadius: 0.0)
            ]),
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace stackTrace) {
                    return const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text('Error loading Network Image...',
                          style: TextStyle(color: Colors.black)),
                    );
                  },
                )),
            const SizedBox(
              height: 8,
            ),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              desc,
              style: const TextStyle(
                color: Colors.black54,
              ),
            )
          ],
        ),
      ),
    );
  }
}
