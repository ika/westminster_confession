import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'alertDialog.dart';
import 'bmDialog.dart';
import 'bmHelper.dart';
import 'bmModel.dart';
import 'dbModel.dart';
import 'dbHelper.dart';
import 'verseReference.dart';

// With Proofs pages

DBProvider dbProvider = DBProvider();
BMProvider bmProvider = BMProvider();

int index = 0;

class FDetailPage extends StatefulWidget {
  FDetailPage(int idx, {Key key}) : super(key: key) {
    index = idx;
  }

  @override
  _FDetailPageState createState() => _FDetailPageState();
}

class _FDetailPageState extends State<FDetailPage> {
  List<Chapter> chapters;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Chapter>>(
      future: dbProvider.getChapters('ftexts'),
      builder: (context, AsyncSnapshot<List<Chapter>> snapshot) {
        if (snapshot.hasData) {
          chapters = snapshot.data;
          return showChapters(chapters, index, context);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

showChapters(chapters, index, context) {
  String heading = "Westminster Confession";
  String chap = "Chapter";

  PageController pageController =
      PageController(initialPage: chapters[index].id);

  final html = Style(
      backgroundColor: Colors.white30,
      padding: const EdgeInsets.all(15.0),
      margin: const EdgeInsets.only(bottom: 20.0),
      fontFamily: 'Raleway-Regular',
      fontSize: const FontSize(16.0));

  final h2 = Style(fontSize: const FontSize(18.0));

  final h3 = Style(fontSize: const FontSize(16.0));

  final a =
      Style(fontSize: const FontSize(12.0), textDecoration: TextDecoration.none);

  final sup = Style(color: Colors.red);

  final table = Style(
    backgroundColor: const Color.fromARGB(0x50, 0xee, 0xee, 0xee),
    width: double.infinity,
    margin: const EdgeInsets.only(top: 30.0),
  );
  final th = Style(
    padding: const EdgeInsets.all(6),
    backgroundColor: Colors.orangeAccent,
  );
  final tr = Style(
      //border: Border(bottom: BorderSide(color: Colors.grey)),
      );

  final td = Style(
    padding: const EdgeInsets.all(6),
  );

  topAppBar(context) => AppBar(
        elevation: 0.1,
        backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
        title: Text(heading),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.bookmark_outline_sharp,
              color: Colors.yellowAccent,
            ),
            onPressed: () {
              int pg = pageController.page.toInt();
              int sp = pg + 1;

              var arr = List.filled(2, '');
              arr[0] = heading + " " + chap + " " + sp.toString();
              arr[1] = chapters[pg].title;

              BMDialog().showBmDialog(context, arr).then(
                (value) {
                  if (value == ConfirmAction.ACCEPT) {
                    final model = BMModel(
                        title: arr[0].toString(),
                        subtitle: note,
                        detail: "5",
                        page: pg.toString());
                    bmProvider.saveBookMark(model);
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
      itemCount: 33,
      controller: pageController,
      scrollDirection: Axis.horizontal,
      pageSnapping: true,
      itemBuilder: (BuildContext context, int index) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Html(
              data: chapters[index].text,
              style: {
                "html": html,
                "h2": h2,
                "h3": h3,
                "a": a,
                "sup": sup,
                "table": table,
                "tr": tr,
                "th": th,
                "td": td
              },
              onLinkTap: (url, _, __, ___) async {
                Map<String, String> data = await getVerseByReference(url);
                showAlertDialog(context, data);
              },
            ),
          ),
        );
      },
    ),
  );
}
