import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:westminster_confession/bkmarks/bm_dialog.dart';
import 'package:westminster_confession/bkmarks/bm_model.dart';
import 'package:westminster_confession/bkmarks/bm_queries.dart';
import 'package:westminster_confession/main/ma_model.dart';
import 'package:westminster_confession/main/ma_queries.dart';

// Ecumenical Creeds

DBQueries dbQueries = DBQueries();

int index = 0;

class ECUPage extends StatefulWidget {
  ECUPage(int indx, {Key? key}) : super(key: key) {
    index = indx;
  }

  @override
  ECUPageState createState() => ECUPageState();
}

class ECUPageState extends State<ECUPage> {
  List<Chapter> chapters = List<Chapter>.empty();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Chapter>>(
      future: dbQueries.getChapters('btexts'),
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

showChapters(chapters, index, context) {
  String heading = "Ecumenical Creeds";

  PageController pageController =
      PageController(initialPage: chapters[index].id);

  final html = Style(
      backgroundColor: Colors.white30,
      padding: HtmlPaddings.all(15.0),
      fontFamily: 'Raleway-Regular',
      fontSize: FontSize(16.0));

  final h2 = Style(fontSize: FontSize(18.0));
  final h3 = Style(fontSize: FontSize(16.0));
  final i = Style(
      fontSize: FontSize(16.0),
      fontStyle: FontStyle.italic,
      color: Colors.blue);

  topAppBar(context) => AppBar(
        elevation: 0.1,
        backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
        title: const Text(
          'Ecumenical Creeds',
          style: TextStyle(
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
              int pg = pageController.page!.toInt();
              int sp = pg + 1;

              var arr = List.filled(2, '');
              arr[0] = "$heading $sp";
              arr[1] = chapters[pg].title;

              BMDialog().showBmDialog(context, arr).then(
                (value) {
                  if (value) {
                    final model = BMModel(
                      title: arr[0].toString(),
                      subtitle: note,
                      detail: "2",
                      page: pg.toString(),
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
    body: PageView.builder(
      itemCount: 3,
      controller: pageController,
      scrollDirection: Axis.horizontal,
      pageSnapping: true,
      itemBuilder: (BuildContext context, int index) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Html(
              data: chapters[index].text,
              style: {"html": html, "h2": h2, "h3": h3, "i": i},
            ),
          ),
        );
      },
    ),
  );
}