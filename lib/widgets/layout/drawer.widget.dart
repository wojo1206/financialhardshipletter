import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:simpleiawriter/bloc/app.bloc.dart';
import 'package:simpleiawriter/bloc/auth.repository.dart';
import 'package:simpleiawriter/helpers/view.helper.dart';
import 'package:simpleiawriter/widgets/account.screen.dart';
import 'package:simpleiawriter/widgets/auth/login.screen.dart';
import 'package:simpleiawriter/widgets/history.screen.dart';
import 'package:simpleiawriter/widgets/settings.screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          final authRep = RepositoryProvider.of<AuthRepository>(context);

          List<Widget> children = [
            DrawerHeader(
              child: Image.asset(
                'assets/images/img1-kelly-sikkema.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ];

          if (state.isLoggedIn) {
            children.addAll([
              ListTile(
                title: Text(AppLocalizations.of(context)!.titleAccount),
                onTap: () {
                  Navigator.of(context)
                      .push(ViewHelper.routeSlide(const AccountScreen()));
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.titleHistory),
                onTap: () {
                  Navigator.of(context)
                      .push(ViewHelper.routeSlide(const HistoryScreen()));
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.titleSettings),
                onTap: () {
                  Navigator.of(context)
                      .push(ViewHelper.routeSlide(const SettingsScreen()));
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.logOut),
                onTap: () async {
                  await authRep
                      .signOut()
                      .then((value) => BlocProvider.of<AppBloc>(context)
                          .add(UserLogIn(false)))
                      .then((value) => Navigator.pop(context));
                },
              ),
            ]);
          } else {
            children.addAll([
              ListTile(
                title: Text(AppLocalizations.of(context)!.logIn),
                onTap: () {
                  Navigator.of(context)
                      .push(ViewHelper.routeSlide(const LoginScreen()));
                },
              ),
            ]);
          }

          children.add(ListTile(
            title: const Text('Version'),
            onTap: () {},
            enabled: false,
            subtitle: Text('@TODO'),
          ));

          return ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: children,
          );
        },
      ),
    );
  }
}
