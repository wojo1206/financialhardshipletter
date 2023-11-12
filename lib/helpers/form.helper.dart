import 'package:flutter/material.dart';

class FormHelper {
  static Widget listTileWithCheckBox(
    BuildContext context, {
    required bool isChecked,
    required Function(bool?) onChanged,
    required Widget title,
  }) {
    return ListTile(
      leading: Checkbox(
        value: isChecked,
        onChanged: onChanged,
      ),
      title: title,
    );
  }

  static Widget wrapperBody(BuildContext context, Widget child) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          height: MediaQuery.of(context).size.height -
              AppBar().preferredSize.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom,
          child: child,
        ),
      ),
    );
  }

  static Widget wrapperBodyNoScroll(BuildContext context, Widget child) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: child,
      ),
    );
  }
}
