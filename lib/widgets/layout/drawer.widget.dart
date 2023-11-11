import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:simpleiawriter/blocs/auth.bloc.dart';
import 'package:simpleiawriter/repos/auth.repository.dart';
import 'package:simpleiawriter/helpers/view.helper.dart';
import 'package:simpleiawriter/widgets/account.screen.dart';
import 'package:simpleiawriter/widgets/auth/social.login.widget.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocBuilder<AuthBloc, AuthState>(
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

          if (state.status == AuthenticationState.authenticated) {
            children.addAll([
              ListTile(
                title: Text(AppLocalizations.of(context)!.titleAccount),
                onTap: () {
                  _popAndPush(context, const AccountScreen());
                },
              ),
              // ListTile(
              //   title: Text(AppLocalizations.of(context)!.titleHistory),
              //   onTap: () {
              //     _popAndPush(context, const HistoryScreen());
              //   },
              // ),
              // ListTile(
              //   title: Text(AppLocalizations.of(context)!.titleSettings),
              //   onTap: () {
              //     _popAndPush(context, const SettingsScreen());
              //   },
              // ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.logOut),
                onTap: () async {
                  await authRep
                      .signOut()
                      .then((value) => BlocProvider.of<AuthBloc>(context).add(
                          AuthChanged(AuthenticationState.unauthenticated)))
                      .then((value) => Navigator.pop(context));
                },
              ),
            ]);
          } else {
            children.addAll([
              ListTile(
                title: Text(AppLocalizations.of(context)!.logIn),
                onTap: () {
                  ViewHelper.myDialog(context,
                      AppLocalizations.of(context)!.logIn, const SocialLogin());
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

  void _popAndPush(BuildContext context, Widget screen) {
    Navigator.pop(context);
    Navigator.of(context).push(ViewHelper.routeSlide(screen));
  }
}
