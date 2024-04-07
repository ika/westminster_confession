import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:westminster_confession/bloc/bloc_font.dart';
import 'package:westminster_confession/bloc/bloc_italic.dart';
import 'package:westminster_confession/bloc/bloc_size.dart';
import 'package:westminster_confession/creeds/model.dart';
import 'package:westminster_confession/creeds/queries.dart';
import 'package:westminster_confession/fonts/list.dart';
import 'package:westminster_confession/utils/globals.dart';

// Preface

// class PrefPageArguments {
//   final int index;
//   PrefPageArguments(this.index);
// }

CreedsQueries creedsQueries = CreedsQueries();

class CreedsPage extends StatefulWidget {
  const CreedsPage({super.key});

  @override
  CreedsPageState createState() => CreedsPageState();
}

class CreedsPageState extends State<CreedsPage> {
  List<Creeds> paragraphs = List<Creeds>.empty();
  String heading = "Ecumenical Creeds";

  // @override
  // void initState() {
  //   super.initState();
  //   primaryTextSize = BlocProvider.of<TextSizeCubit>(context).state;
  // }

  @override
  Widget build(BuildContext context) {
    // final args =
    //     ModalRoute.of(context)!.settings.arguments as PrefPageArguments;

    return FutureBuilder<List<Creeds>>(
      future: creedsQueries.getCreeds(),
      builder: (context, AsyncSnapshot<List<Creeds>> snapshot) {
        if (snapshot.hasData) {
          paragraphs = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 5,
              leading: GestureDetector(
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
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
              title: Text(heading,
                  style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: paragraphs.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      paragraphs[index].h,
                      style: TextStyle(
                          fontFamily: fontsList[context.read<FontBloc>().state],
                          fontWeight: FontWeight.w700,
                          fontStyle: (context.read<ItalicBloc>().state)
                              ? FontStyle.italic
                              : FontStyle.normal,
                          fontSize: context.read<SizeBloc>().state),
                    ),
                    subtitle: Text(
                      paragraphs[index].t,
                      style: TextStyle(
                          fontFamily: fontsList[context.read<FontBloc>().state],
                          fontStyle: (context.read<ItalicBloc>().state)
                              ? FontStyle.italic
                              : FontStyle.normal,
                          fontSize: context.read<SizeBloc>().state),
                    ),
                  );
                },
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
