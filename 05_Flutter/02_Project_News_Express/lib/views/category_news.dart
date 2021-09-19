import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:headlines2/helper/news.dart';
import 'package:headlines2/models/article_model.dart';
import 'article_view.dart';


class CategoryNews extends StatefulWidget {
  final String category;

  const CategoryNews({ Key? key,required this.category }) : super(key: key);

  @override
  _CategoryNewsState createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {

  List<ArticleModel> articles = [];
  bool _loading = true;

  @override
  void initState() {
    // todo: implement initState
    super.initState();
    getCategoryNews();
  }

  getCategoryNews() async{
    GetCategoryNews newsClass = GetCategoryNews();
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

        elevation: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text("News ",style: TextStyle(fontWeight: FontWeight.bold),),
            Text("Express",style: TextStyle(color: Colors.white70),),
          ],
        ),
        
        actions:<Widget>[
          Opacity(
            opacity: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Icon(Icons.save)
              ),
          )
        ],
      ),
      body: _loading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          
          children: <Widget>[
            //Blogs=====================
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
