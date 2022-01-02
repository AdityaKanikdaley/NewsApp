import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/helper/data.dart';
import 'package:news_app/helper/news.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/models/category_model.dart';
import 'package:news_app/views/article_view.dart';
import 'package:news_app/views/category_news.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = <CategoryModel>[];
  List<ArticleModel> articles = <ArticleModel>[];
  bool _loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categories = getCategories();
    getNews();
  }

  getNews() async {
    News newsClass = News();
    await newsClass.getNews();
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              "Flutter",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "News",
              style: TextStyle(color: Colors.red),
            )
          ],
        ),
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
                    // Categories
                    Container(
                      padding: const EdgeInsets.all(1),
                      height: 110,
                      child: ListView.builder(
                        itemCount: categories.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return CategoryTile(
                            imageUrl: categories[index].imageUrl,
                            categoryName: categories[index].categoryName,
                          );
                        },
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

class CategoryTile extends StatelessWidget {
  const CategoryTile({Key key, this.imageUrl, this.categoryName})
      : super(key: key);
  final String imageUrl, categoryName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryNews(
                      category: categoryName.toLowerCase(),
                    )));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10, top: 16),
        padding: const EdgeInsets.fromLTRB(10, 15, 15, 15),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                //bottom
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(4.0, 4.0),
                blurRadius: 10.0,
                spreadRadius: 1.0),
            const BoxShadow(
                //top
                color: Colors.white,
                offset: Offset(-5, -5),
                blurRadius: 6.0,
                spreadRadius: 0.0)
          ]),
          child: Stack(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 120,
                    height: 60,
                    fit: BoxFit.cover,
                  )),
              Container(
                alignment: Alignment.center,
                width: 120,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.black26,
                ),
                child: Text(
                  categoryName,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
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
                    return const Text('Error loading Network Image...');
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
