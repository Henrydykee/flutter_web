import 'package:flutter/material.dart';
import 'package:flutterweb/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Article> _articles =[];
  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }
  _fetchArticles() async{
    List<Article> articles = await API().fetchArticlesBySection('technology');
    setState(() {
      _articles = articles;
    });
  }
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 80,),
          Center(
            child: Text("The New York Times\nTop Tech Articles",
            textAlign: TextAlign.center,
            style:  TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.5
            ),),
          ),
          SizedBox(height: 15,),
          _articles.length > 0 ?  _buildArticlesGrid(mediaQuery) : Center(child: CircularProgressIndicator())
        ],
      ),
    );
  }

  _buildArticlesGrid(MediaQueryData mediaQuery) {
      List<GridTile> tiles = [];
      _articles.forEach((article) {
        tiles.add(_buildArticleTile(article ,mediaQuery));
      });
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 100.0, vertical: 50.0),
           child: GridView.count(crossAxisCount:4,
             mainAxisSpacing: 30.0,
             crossAxisSpacing: 30.0,
             shrinkWrap: true,
             physics: NeverScrollableScrollPhysics(),
             children:tiles,
           ) ,
      );
  }

  GridTile _buildArticleTile(Article article, MediaQueryData mediaQuery) {
    return GridTile(
      child: GestureDetector(
        onTap: (){
          _launchUrl(article.url);
        },
        child: Column(
          children: [
            Container(
              height: 250,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0)
                ),
                image: DecorationImage(
                  image: NetworkImage(article.imageUrl),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0,1),
                    blurRadius: 6.0
                  )
                ]
              ),
              child: Text(
                article.title,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

 _launchUrl(String url) async {
  if (await canLaunch(url)){
    await _launchUrl(url);
  }else{
    throw 'Could not launch $url';
  }
}

