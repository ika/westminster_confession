import 'package:flutter/material.dart';
import 'package:westminster_confession/bkmarks/bm_model.dart';
import 'package:westminster_confession/bkmarks/bm_queries.dart';
import 'package:westminster_confession/cat/cat_pages.dart';
import 'package:westminster_confession/ecum/ecu_page.dart';
import 'package:westminster_confession/points/po_page.dart';
import 'package:westminster_confession/pref/pref_page.dart';
import 'package:westminster_confession/utils/globals.dart';
import 'package:westminster_confession/west/we_plain.dart';
import 'package:westminster_confession/west/we_proofs.dart';

// Bookmarks

final BMQueries bmQueries = BMQueries();

Future confirmDialog(BuildContext context, List list, int index) async {
  return showDialog(
    builder: (context) => AlertDialog(
      title: const Text('Delete this bookmark?'), // title
      content:
          Text("${list[index].title}\n${list[index].subtitle}"), // subtitle
      actions: [
        TextButton(
          child:
              const Text('YES', style: TextStyle(fontWeight: FontWeight.bold)),
          onPressed: () => Navigator.of(context).pop(true),
        ),
        TextButton(
          child:
              const Text('NO', style: TextStyle(fontWeight: FontWeight.bold)),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ],
    ),
    context: context,
  );
}

class BMMain extends StatefulWidget {
  const BMMain({super.key});

  @override
  BMMainState createState() => BMMainState();
}

class BMMainState extends State<BMMain> {
  List<BMModel> list = List<BMModel>.empty();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BMModel>>(
      future: bmQueries.getBookMarkList(),
      builder: (context, AsyncSnapshot<List<BMModel>> snapshot) {
        if (snapshot.hasData) {
          list = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_sharp),
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
                'Bookmarks',
                // style: TextStyle(
                //   color: Colors.yellow,
                // ),
              ),
            ),
            body: ListView.separated(
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onHorizontalDragEnd: (DragEndDetails details) {
                    if (details.primaryVelocity! > 0 ||
                        details.primaryVelocity! < 0) {
                      confirmDialog(context, list, index).then((value) {
                        if (value) {
                          bmQueries.deleteBookMark(index).then((value) {
                            setState(() {});
                          });
                        }
                      });
                    }
                  },
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    title: Text(
                      list[index].title,
                      // style: const TextStyle(
                      //     color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                      children: [
                        const Icon(Icons.linear_scale),
                        Flexible(
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            //strutStyle: const StrutStyle(fontSize: 12.0),
                            text: TextSpan(
                              text: " ${list[index].subtitle}",
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.keyboard_arrow_right,
                        color: Colors.white, size: 20.0),
                    onTap: () {
                      int goto = int.parse(list[index].page);

                      switch (list[index].detail) {
                        case "1": // Westminster plain text
                          Future.delayed(
                            Duration(milliseconds: Globals.navigatorDelay),
                            () {
                              Navigator.of(context)
                                  .pushNamed('/WePlainPage',
                                      arguments: WePlainArguments(goto))
                                  .then(
                                (value) {
                                  int count = 1;
                                  Navigator.of(context)
                                      .popUntil((_) => count++ >= 2);
                                },
                              );
                            },
                          );
                          break;

                        case "2": // Ecumenical Creeds
                          Future.delayed(
                            Duration(milliseconds: Globals.navigatorDelay),
                            () {
                              Navigator.of(context)
                                  .pushNamed('/ECUPage',
                                      arguments: ECUPageArguments(goto))
                                  .then(
                                (value) {
                                  int count = 1;
                                  Navigator.of(context)
                                      .popUntil((_) => count++ >= 2);
                                },
                              );
                            },
                          );

                          break;

                        case "3": // Preface
                          Future.delayed(
                            Duration(milliseconds: Globals.navigatorDelay),
                            () {
                              Navigator.of(context)
                                  .pushNamed('/PrefPage',
                                      arguments: PrefPageArguments(goto))
                                  .then(
                                (value) {
                                  int count = 1;
                                  Navigator.of(context)
                                      .popUntil((_) => count++ >= 2);
                                },
                              );
                            },
                          );
                          break;

                        case "4": // Five Points
                          Future.delayed(
                            Duration(milliseconds: Globals.navigatorDelay),
                            () {
                              Navigator.of(context)
                                  .pushNamed('/PointsPage',
                                      arguments: PointsArguments(goto))
                                  .then(
                                (value) {
                                  int count = 1;
                                  Navigator.of(context)
                                      .popUntil((_) => count++ >= 2);
                                },
                              );
                            },
                          );
                          break;
                        case "5": // Westminster with proofs
                          Future.delayed(
                            Duration(milliseconds: Globals.navigatorDelay),
                            () {
                              Navigator.of(context)
                                  .pushNamed('/WeProofsPage',
                                      arguments: WeProofArguments(goto))
                                  .then(
                                (value) {
                                  int count = 1;
                                  Navigator.of(context)
                                      .popUntil((_) => count++ >= 2);
                                },
                              );
                            },
                          );
                          break;
                        case "6": // Larger Catechism
                          Future.delayed(
                            Duration(milliseconds: Globals.navigatorDelay),
                            () {
                              Navigator.of(context)
                                  .pushNamed('/CatPages',
                                      arguments: CatPageArguments(goto))
                                  .then(
                                (value) {
                                  int count = 1;
                                  Navigator.of(context)
                                      .popUntil((_) => count++ >= 2);
                                },
                              );
                            },
                          );
                          break;
                      }
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
