import 'package:flutter/material.dart';

class TextareaForm extends StatelessWidget {
  final bool expands;
  final bool readonly;
  final bool showCursor;
  final FocusNode? focusNode;
  final int? maxLines;
  final int? minLines;
  final ScrollController? scrollController;
  final String? helperText;
  final String? hintText;
  final TextEditingController? controller;

  final Function(String)? onChanged;

  const TextareaForm(
      {super.key,
      this.controller,
      this.expands = true,
      this.focusNode,
      this.helperText,
      this.hintText,
      this.maxLines,
      this.minLines,
      this.readonly = false,
      this.scrollController,
      this.showCursor = true,
      this.onChanged});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        alignLabelWithHint: true,
        border: const OutlineInputBorder(gapPadding: 0),
        contentPadding: const EdgeInsets.all(8.0),
        helperText: helperText,
        hintText: hintText,
      ),
      controller: controller,
      expands: expands,
      focusNode: focusNode,
      keyboardType: TextInputType.multiline,
      maxLines: maxLines,
      minLines: minLines,
      onChanged: onChanged,
      readOnly: readonly,
      scrollController: scrollController,
      showCursor: showCursor,
      style: const TextStyle(fontSize: 18),
      textAlignVertical: TextAlignVertical.top,
    );
  }
}
