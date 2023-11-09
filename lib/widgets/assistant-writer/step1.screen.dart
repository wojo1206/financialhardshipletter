import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:simpleiawriter/constants.dart';
import 'package:simpleiawriter/helpers/form.helper.dart';
import 'package:simpleiawriter/helpers/view.helper.dart';
import 'package:simpleiawriter/widgets/assistant-writer/step2.screen.dart';
import 'package:simpleiawriter/widgets/layout/assistant.layout.dart';

class WriterAssistantStep1 extends StatefulWidget {
  const WriterAssistantStep1({super.key});

  @override
  State<WriterAssistantStep1> createState() => _WriterAssistantStep1();
}

class _WriterAssistantStep1 extends State<WriterAssistantStep1> {
  HardshipLetterType? _letterType = HardshipLetterType.medical;

  @override
  Widget build(BuildContext context) {
    List<Widget> letterTypes = [];

    FormHelper.getAssistants()?.forEach((e) {
      var icon = e.icon;

      letterTypes.add(
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _letterType = e.letterType;
              });
            },
            child: ViewHelper.boxFlatIconized(
                context,
                Row(
                  children: [
                    Radio<HardshipLetterType>(
                        value: e.letterType,
                        groupValue: _letterType,
                        onChanged: (HardshipLetterType? value) {
                          setState(() {
                            _letterType = value;
                          });
                        }),
                    Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "Text here",
                                style: TextStyle(fontSize: 100),
                              ),
                            ),
                            Text(e.getLabel(context))
                          ]),
                    ),
                  ],
                ),
                e.icon),
          ),
        ),
      );
    });

    return AssistantLayout(
      title: AppLocalizations.of(context)!.assistant,
      helpText: AppLocalizations.of(context)!.hintPage1,
      helpUrl: '',
      children: letterTypes,
      onNext: () => Navigator.of(context).push(
        ViewHelper.routeSlide(
          const WriterAssistantStep2(),
        ),
      ),
    );
  }
}
