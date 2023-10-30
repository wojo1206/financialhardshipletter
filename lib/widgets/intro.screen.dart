import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Image.asset('assets/images/img1-kelly-sikkema.jpg',
                fit: BoxFit.cover),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Welcome',
                        style: Theme.of(context).textTheme.titleLarge),
                    const Text(
                      'This app will guide you through the process of writing a hardship letter with a help from artificial intelligence. User friendly process with autocomplete features and high quality results is what distinguish this app from others.',
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Let\'s Start')),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
