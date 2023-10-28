import 'package:flutter/material.dart';

class ViewHelper {
  static dynamic promptDialog(BuildContext context, String question) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(question),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget infoText(BuildContext context, String str) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 32.0,
      ),
      child: Text(
        str,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  static Widget colorBox(BuildContext context, String txt) {
    return Expanded(
      child: Text(txt,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: Colors.blue)),
    );
  }

  static Widget listHorizontal(BuildContext context, List<Widget> children) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
        spacing: 5.0,
        children: children,
      ),
    );
  }

  static dynamic helpSheet(BuildContext context, String question) {
    return showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        useSafeArea: true,
        builder: (BuildContext context) => Container());
  }
}
