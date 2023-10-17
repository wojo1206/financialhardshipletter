import 'package:flutter/material.dart';

class TextareaForm extends StatelessWidget {
  final String? hintText;
  final String? helperText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ScrollController? scrollController;
  final bool readonly;

  const TextareaForm(
      {super.key,
      this.hintText,
      this.helperText,
      this.controller,
      this.focusNode,
      this.scrollController,
      this.readonly = false});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(8.0),
        border: InputBorder.none,
        hintText: hintText,
        helperText: helperText,
        alignLabelWithHint: true,
      ),
      expands: true,
      focusNode: focusNode,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      minLines: null,
      readOnly: readonly,
      scrollController: scrollController,
      textAlignVertical: TextAlignVertical.top,
      style: const TextStyle(fontSize: 24),
      controller: controller,
    );
  }
}
