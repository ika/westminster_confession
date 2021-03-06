import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import './utilities.dart';

// Bookmarks Dialog

enum ConfirmAction { CANCEL, ACCEPT }

String note = "";

class BMDialog {
  Future showBmDialog(context, arr) async {
    String txt = arr[1].toString();

    // txt = txt.replaceAll(RegExp(r'[0-9]+'), '');
    // txt = txt.replaceAll(RegExp(r'[\(\)\-]+'), '');

    // if (txt.length > 35) {
    //   txt = txt.substring(0, 35) + '...';
    // }

    reduceLength(txt, 35);

    TextEditingController _controller = new TextEditingController();
    note = _controller.text = txt;

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bookmark?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  arr[0].toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Container(
                    width: 100,
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      autofocus: true,
                      maxLength: 50,
                      controller: _controller,
                      decoration: new InputDecoration(
                          labelText: 'Add your own text',
                          labelStyle: new TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          )),
                      onChanged: (value) {
                        note = value;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('YES', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            ),
            TextButton(
              child: Text('NO', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
          ],
        );
      },
    );
  }
}
