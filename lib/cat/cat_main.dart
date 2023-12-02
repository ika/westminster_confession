import 'package:flutter/material.dart';
import 'package:westminster_confession/cat/cat_model.dart';
import 'package:westminster_confession/cat/cat_pages.dart';
import 'package:westminster_confession/cat/cat_queries.dart';
import 'package:westminster_confession/utils/globals.dart';

// The Larger Catachism

CAQueries caQueries = CAQueries();

class CatMain extends StatefulWidget {
  const CatMain({super.key});

  @override
  CatMainState createState() => CatMainState();
}

class CatMainState extends State<CatMain> {

  List<Catachism> chapters = List<Catachism>.empty();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Catachism>>(
      future: caQueries.getTitleList(),
      builder: (context, AsyncSnapshot<List<Catachism>> snapshot) {
        if (snapshot.hasData) {
          chapters = snapshot.data!;
          return showChapterList(chapters, context);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  showChapterList(List<Catachism> chapters, context) {
    ListTile makeListTile(chapters, int index) => ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          title: Text(
            chapters[index].chap,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Row(
            children: <Widget>[
              const Icon(Icons.linear_scale, color: Colors.yellowAccent),
              Flexible(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  strutStyle: const StrutStyle(fontSize: 12.0),
                  text: TextSpan(
                      style: const TextStyle(color: Colors.white),
                      text: " ${chapters[index].title}"),
                ),
              ),
            ],
          ),
          trailing: const Icon(Icons.keyboard_arrow_right,
              color: Colors.white, size: 30.0),
          onTap: () {
            Future.delayed(
              Duration(milliseconds: Globals.navigatorDelay),
              () {
                Navigator.of(context)
                    .pushNamed('/CatPages', arguments: CatPageArguments(index));
              },
            );
          },
        );

    Card makeCard(chapters, int index) => Card(
          elevation: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
          child: Container(
            decoration:
                const BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
            child: makeListTile(chapters, index),
          ),
        );

    final makeBody = ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: chapters.length,
      itemBuilder: (BuildContext context, int index) {
        return makeCard(chapters, index);
      },
    );

    final topAppBar = AppBar(
      elevation: 0.1,
      backgroundColor: const Color.fromRGBO(64, 75, 96, .9),
      leading: GestureDetector(
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_sharp,
            color: Colors.white,
          ),
          onPressed: () {
            Future.delayed(
              Duration(milliseconds: Globals.navigatorDelay),
              () {
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      title: const Text(
        'Larger Catechism',
        style: TextStyle(
          color: Colors.yellow,
        ),
      ),
    );

    return Scaffold(
      backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
      appBar: topAppBar,
      body: makeBody,
    );
  }
}
