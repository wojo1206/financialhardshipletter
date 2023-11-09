import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';
import 'package:simpleiawriter/widgets/layout/drawer.widget.dart';

class LoginFlutterScreen extends StatefulWidget {
  const LoginFlutterScreen({super.key});

  @override
  State<LoginFlutterScreen> createState() => _LoginFlutterScreenState();
}

class _LoginFlutterScreenState extends State<LoginFlutterScreen> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Authenticator(
      child: MaterialApp(
        builder: Authenticator.builder(),
        home: Scaffold(
          appBar: AppBar(
            title:
                Text('Sign In', style: Theme.of(context).textTheme.bodyMedium),
          ),
          drawer: const MyDrawer(),
          body: const Center(
            child: Text('You are logged in!'),
          ),
        ),
      ),
    );
  }
}
