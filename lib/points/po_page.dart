import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:westminster_confession/bkmarks/bm_dialog.dart';
import 'package:westminster_confession/bkmarks/bm_model.dart';
import 'package:westminster_confession/bkmarks/bm_queries.dart';
import 'package:westminster_confession/main/ma_model.dart';
import 'package:westminster_confession/bible/bi_verses.dart';
import 'package:westminster_confession/main/ma_queries.dart';

// The five points

DBQueries dbQueries = DBQueries();

int index = 0;

class PointsPage extends StatefulWidget {
  PointsPage(int index, {Key? key}) : super(key: key) {
    index = index;
  }

  @override
  PointsPageState createState() => PointsPageState();
}

class PointsPageState extends State<PointsPage> {
  List<Chapter> chapters = List<Chapter>.empty();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Chapter>>(
      future: dbQueries.getChapters('dtexts'),
      builder: (context, AsyncSnapshot<List<Chapter>> snapshot) {
        if (snapshot.hasData) {
          chapters = snapshot.data!;
          return showChapters(chapters, index, context);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

showVerseDialog(BuildContext context, data) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(data['header']),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(data['contents']),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

showChapters(chapters, index, context) {
  String heading = "TULIP";

  PageController pageController =
      PageController(initialPage: chapters[index].id);

  final html = Style(
      backgroundColor: Colors.white30,
      padding: HtmlPaddings.all(15.0),
      fontFamily: 'Raleway-Regular',
      fontSize: FontSize(16.0));

  final h2 = Style(fontSize: FontSize(18.0));
  final h3 = Style(fontSize: FontSize(16.0));
  final a =
      Style(fontSize: FontSize(14.0), textDecoration: TextDecoration.none);

  final page0 = Html(
    data: chapters[0].text,
    style: {"html": html, "h2": h2, "h3": h3, "a": a},
    onLinkTap: (url, _, __) {
      if (url != null) {
        getVerseByReference(url).then((value) {
          showVerseDialog(context, value);
        });
      }
    },
  );

  topAppBar(context) => AppBar(
        elevation: 0.1,
        backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
        title: Text(
          heading,
          style: const TextStyle(
            color: Colors.yellow,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.bookmark_outline_sharp,
              color: Colors.yellow,
            ),
            onPressed: () {
              var arr = List.filled(2, '');
              arr[0] = heading;
              arr[1] = 'The Five Points';

              BMDialog().showBmDialog(context, arr).then(
                (value) {
                  if (value) {
                    final model = BMModel(
                      title: arr[0].toString(),
                      subtitle: note,
                      detail: "4",
                      page: "0",
                    );
                    BMQueries().saveBookMark(model);
                  }
                },
              );
            },
          ),
        ],
      );

  return Scaffold(
    appBar: topAppBar(context),
    body: PageView(
      controller: pageController,
      scrollDirection: Axis.horizontal,
      pageSnapping: true,
      children: [
        SingleChildScrollView(
          child: page0,
        ),
      ],
    ),
  );
}