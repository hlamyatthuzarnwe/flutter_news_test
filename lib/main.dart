import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class News {
  final String title;
  final String description;
  final String author;
  final String urlToImage;
  final String publishedAt;

  News(this.title, this.description, this.author, this.urlToImage,
      this.publishedAt);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<List<News>> getNews() async {
    var data = await http.get(
        'https://newsapi.org/v2/everything?q=bitcoin&from=2020-01-05&sortBy=publishedAt&apiKey=313228e924904cb6a0a1fe355ba79cf2');

    var jsonData = json.decode(data.body);

    var newsData = jsonData['articles'];

    List<News> news = [];

    for (var data in newsData) {
      News newsItem = News(data['title'], data['description'], data['author'],
          data['urlToImage'], data['publishedAt']);

      news.add(newsItem);
    }
    return news;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News"),
      ),
      body: Container(
        child: FutureBuilder(
          future: getNews(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      News news = new News(snapshot.data[index].title,
                          snapshot.data[index].description, snapshot.data[index].author,
                          snapshot.data[index].urlToImage,
                          snapshot.data[index].publishedAt);
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) => new Details(news: news,)
                          )
                      );
                    },
                    child: Card(
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 120,
                            height: 110.0,
                            child: ClipRRect(
                              borderRadius:
                              BorderRadius.all(Radius.circular(8)),
                              child: snapshot.data[index].urlToImage == null
                                  ? Image.network(
                                  'https://www.cleverfiles.com/howto/wp-content/uploads/2018/03/minion.jpg')
                                  : Image.network(
                                snapshot.data[index].urlToImage,
                                width: 100,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: Text(snapshot.data[index].title),
                              subtitle: Text(snapshot.data[index].author == null
                                  ? 'Unknown Author'
                                  : snapshot.data[index].author),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class Details extends StatelessWidget {
  final News news;

  Details({this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: 400,
                    child: Image.network('${this.news.urlToImage}',
                      fit: BoxFit.fill,),
                  ),
                  AppBar(
                    backgroundColor: Colors.transparent,
                    leading: InkWell(
                      child: Icon(Icons.arrow_back_ios),
                      onTap: () => Navigator.pop(context),
                    ),
                    elevation: 0,
                  )
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${this.news.title}',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        letterSpacing: 0.2,
                        wordSpacing: 0.6,
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      this.news.description,
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          letterSpacing: 0.2,
                          wordSpacing: 0.3
                      ),
                    )

                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
