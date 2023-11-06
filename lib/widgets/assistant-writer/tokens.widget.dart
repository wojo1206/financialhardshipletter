import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:simpleiawriter/bloc/app.bloc.dart';
import 'package:simpleiawriter/helpers/view.helper.dart';
import 'package:simpleiawriter/widgets/purchase.screen.dart';

class TokensInfo extends StatefulWidget {
  const TokensInfo({super.key});

  @override
  State<TokensInfo> createState() => _TokensInfoState();
}

class _TokensInfoState extends State<TokensInfo> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tokens: ${state.tokens}'),
            TextButton(
              onPressed: () {
                ViewHelper.helpSheet(context, const PurchaseScreen());
              },
              child: Text('Add Tokens'),
            )
          ],
        ),
      );
    });
  }
}
