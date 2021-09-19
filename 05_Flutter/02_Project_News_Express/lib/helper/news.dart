import 'dart:convert';

import 'package:headlines2/models/article_model.dart';
import 'package:http/http.dart' as http;

class News{
  List<ArticleModel> news = [];
  
  Future<void> getNews() async{
    String url = "https://newsapi.org/v2/top-headlines?country=in&apiKey=b9a77bc7705140d2bf0d178bdce7a159";
  
    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);
    if(jsonData['status']=='ok'){
      jsonData['articles'].forEach((element){
        if(element['urlToImage'] != null && element['description'] != null && element['content'] != null){
          if(element['author']==null){
            element['author'] = "Not Available";
          }
          if(element['title'] == null){
            element['title'] = "Title Not Available";
          }
          if(element['url'] == null){
            element['url'] = "https://images.unsplash.com/photo-1507679799987-c73779587ccf?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1502&q=80";
          }
          //element['urlToImage']= "https://images.unsplash.com/photo-1507679799987-c73779587ccf?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1502&q=80";
          if(element['author'] == null|| element['title'] == null|| element['url'] == null){
            // ignore: avoid_print
            print("Something is null Here");
            // ignore: avoid_print
            print("Title: $element['title']");
            // ignore: avoid_print
            print("Title: $element['url']");
          } 
          ArticleModel articleModel = ArticleModel(
            element['author'],
            element['title'],
            element['description'],
            element['content'],
            element['url'],
            element['urlToImage'],
          );
        news.add(articleModel);  
        }
      });
    }
    
  }
}

class GetCategoryNews{
  
  List<ArticleModel> news = [];
  
  Future<void> getNews(String category) async{
    String url = "https://newsapi.org/v2/top-headlines?country=in&category=$category&apiKey=b9a77bc7705140d2bf0d178bdce7a159";
    // ignore: avoid_print
    print(url);
    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);
    if(jsonData['status']=='ok'){
      // ignore: avoid_print
      print("jsonData status is ok");
      jsonData['articles'].forEach((element){
        if(element['urlToImage'] != null && element['description'] != null && element['content'] != null){
          if(element['author']==null){
            element['author'] = "Not Available";
          }
          if(element['title'] == null){
            element['title'] = "Title Not Available";
          }
          if(element['url'] == null){
            element['url'] = "https://images.unsplash.com/photo-1507679799987-c73779587ccf?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1502&q=80";
          }
          if(element['author'] == null|| element['title'] == null|| element['url'] == null){
            // ignore: avoid_print
            print("Something is null Here");
            // ignore: avoid_print
            print("Title: $element['title']");
            // ignore: avoid_print
            print("Title: $element['url']");
          }
          ArticleModel articleModel = ArticleModel(
            element['author'],
            element['title'],
            element['description'],
            element['content'],
            element['url'],
            element['urlToImage'],
          );
        news.add(articleModel);
        }
      });
      // ignore: avoid_print
      print(news.length);
    }
    
  }
}


