import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:simpleiawriter/blocs/edit.bloc.dart';

import 'package:simpleiawriter/helpers/form.helper.dart';
import 'package:simpleiawriter/helpers/view.helper.dart';

import 'package:simpleiawriter/widgets/form/textarea.form.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key, required this.gptSessionId});

  final String gptSessionId;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final aiTextController = TextEditingController();
  final aiTextFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _edit();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditBloc, EditState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.titleEdit,
              style: Theme.of(context).textTheme.bodyMedium),
        ),
        body: FormHelper.wrapperBody(
          context,
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: TextareaForm(
                  controller: aiTextController,
                  focusNode: aiTextFocusNode,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(),
                  ElevatedButton(
                    onPressed: () => ViewHelper.goHome(context),
                    child: Text(AppLocalizations.of(context)!.done),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }

  _edit() {
    aiTextController.text = "TEST";
  }
}
