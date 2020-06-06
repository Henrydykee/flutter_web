import 'dart:convert';

import 'package:http/http.dart' as http;

import 'model.dart';


class API {
  static const String BASE_URL ="api.nytimes.com";
  static const String API_KEY ="ufndBSZ356YmGZVkGTqvmvlcvImpGFhP";

  Future <List<Article>> fetchArticlesBySection(String section) async {
    Map<String, String> parameters = {
      'api-key': API_KEY,
    };
    Uri uri = Uri.https(
      BASE_URL, '/svc/topstories/v2/$section.json',
      parameters,
    );
    try{
      var response  = await http.get(uri);
      Map<String, dynamic> data = jsonDecode(response.body);
      List<Article> articles = [];
      data['results'].forEach(
          (articleMap) => articles.add(Article.fromMap(articleMap))
      );
    } catch (err){
     throw err.toString();
    }
  }
}