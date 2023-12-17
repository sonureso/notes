import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:headlines2/helper/data.dart';
import 'package:headlines2/helper/news.dart';
import 'package:headlines2/models/article_model.dart';
import 'package:headlines2/models/category_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:headlines2/views/article_view.dart';
import 'package:headlines2/views/category_news.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<CategoryModel> categories = [];
  List<ArticleModel> articles = [];
  bool _loading = true;

  @override
  void initState() {
    // todo: implement initState
    super.initState();
    categories = getCategories();
    getNews();
  }

  getNews() async{
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
        elevation: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text("News ",style: TextStyle(fontWeight: FontWeight.bold),),
            Text("Express",style: TextStyle(color: Colors.white70),),
          ],
        )
      ),
      body: _loading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: <Widget>[
            //Categories=======================
            Container(
              margin: const EdgeInsets.only(top: 16),
              height:70,
              child: ListView.builder(
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context,index){
                  return CategoryTile(imageUrl:categories[index].imageUrl, categoryName: categories[index].categoryName);
                }),
            ),
      
            // BlogTile=====================
            Container(
              padding: const EdgeInsets.only(top: 16),
              child: ListView.builder(
                itemCount: articles.length,
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context,index){
                  return BlogTile(imageUrl: articles[index].urlToImage, title: articles[index].title, desc: articles[index].desc, url: articles[index].url,);
                })
            ,)
          ],
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {

  final String imageUrl,categoryName;
  const CategoryTile({ Key? key , required this.imageUrl,required this.categoryName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          // ignore: void_checks
          builder: (context) => CategoryNews(category: categoryName.toLowerCase())
        ));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(imageUrl,width: 120,height: 60,fit: BoxFit.cover,)
            ),
            Container(
              alignment: Alignment.center,
              height: 60,width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black26,
              ),
              
              child: Text(categoryName,style: const TextStyle(
                color:Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),),
            )
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {

  final String imageUrl, title, desc, url;
  const BlogTile({ Key? key, required this.imageUrl, required this.title, required this.desc, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ArticleView(blogUrl: url)
           ));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(imageUrl:imageUrl,)),
            Text(title,style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500
            ),),
            const SizedBox(height: 5,),
            Text(desc,style: const TextStyle(
              fontSize: 12,
              color: Colors.black54
            ),),
            const SizedBox(height: 8,)
          ],
        ),
      ),
    );
  }
}

