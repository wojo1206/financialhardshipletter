import 'package:flutter/material.dart';

class TextareaForm extends StatelessWidget {
  final String? hintText;
  final String? helperText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ScrollController? scrollController;
  final bool readonly;
  final bool expands;
  final int? maxLines;
  final int? minLines;

  const TextareaForm(
      {super.key,
      this.hintText,
      this.helperText,
      this.controller,
      this.focusNode,
      this.scrollController,
      this.maxLines,
      this.minLines,
      this.readonly = false,
      this.expands = true});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(8.0),
        border: const OutlineInputBorder(),
        hintText: hintText,
        helperText: helperText,
        alignLabelWithHint: true,
      ),
      expands: expands,
      focusNode: focusNode,
      keyboardType: TextInputType.multiline,
      maxLines: maxLines,
      minLines: minLines,
      readOnly: readonly,
      scrollController: scrollController,
      textAlignVertical: TextAlignVertical.top,
      style: const TextStyle(fontSize: 24),
      controller: controller,
    );
  }
}
