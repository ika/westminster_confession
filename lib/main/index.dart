import 'package:flutter/material.dart';
import 'package:westminster_confession/main/proofs.dart';
import 'package:westminster_confession/utils/globals.dart';
import 'package:westminster_confession/utils/utils.dart';


class IndexPage extends StatefulWidget {
  const IndexPage({super.key, required this.title});

  final String title;

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  List<String> westindex = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: Utils().getTitleList(),
      builder: (context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.hasData) {
          westindex = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 5,
              leading: GestureDetector(
                child: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Future.delayed(
                      Duration(milliseconds: Globals.navigatorDelay),
                      () {
                        //scaffoldKey.currentState!.openDrawer();
                      },
                    );
                  },
                ),
              ),
              title: Text(
                widget.title,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: ListView.separated(
                  itemCount: westindex.length,
                  itemBuilder: (BuildContext context, int index) {
                    int num = index + 1;
                    return ListTile(
                      title: Text(
                        "Chapter $num:",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      subtitle: Row(
                        children: [
                          Icon(Icons.linear_scale,
                              color: Theme.of(context).colorScheme.primary),
                          Flexible(
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: " ${westindex[index]}",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          )
                        ],
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20.0),
                      onTap: () {
                        Future.delayed(
                          Duration(milliseconds: Globals.navigatorDelay),
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProofsPage(page: index),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider();
                  },
                ),
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
