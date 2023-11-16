import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:simpleiawriter/blocs/auth.bloc.dart';
import 'package:simpleiawriter/helpers/view.helper.dart';
import 'package:simpleiawriter/widgets/auth/social.login.widget.dart';
import 'package:simpleiawriter/widgets/purchase.widget.dart';

class TokensInfo extends StatefulWidget {
  const TokensInfo({super.key});

  @override
  State<TokensInfo> createState() => _TokensInfoState();
}

class _TokensInfoState extends State<TokensInfo> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      safePrint("TokensInfoState");

      Widget button = TextButton(
        onPressed: () {
          ViewHelper.myDialog(context, AppLocalizations.of(context)!.logIn,
              const SocialLogin());
        },
        child: Text(AppLocalizations.of(context)!.logIn),
      );

      if (state.status == AuthenticationState.authenticated) {
        button = TextButton(
          onPressed: () {
            ViewHelper.myDialog(context, AppLocalizations.of(context)!.addToken,
                const PurchaseScreen());
          },
          child: Text(AppLocalizations.of(context)!.addToken),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.tokensOwned(state.user.tokens)),
            button
          ],
        ),
      );
    });
  }
}
