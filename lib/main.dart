import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:simpleiawriter/widgets/intro-screen.dart';
import 'package:simpleiawriter/widgets/writer-screen.dart';

import 'amplifyconfiguration.dart';
import 'models/ModelProvider.dart';

void main() {
  // Avoid errors caused by flutter upgrade.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: MAIN_THEME,
      home: const HomeScreen(title: 'Flutter Demo Home Page'),
      routes: {
        '/intro': (context) => const IntroScreen(),
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
      ],
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
              Navigator.of(context).push(_createRoute());
            });
          },
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.note_outlined),
              icon: Icon(Icons.note),
              label: 'Writer',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.history_outlined),
              icon: Icon(Icons.history),
              label: 'History',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.settings_outlined),
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
        body: const Column(
          children: [],
        ));
  }

  Future<void> _configureAmplify() async {
    final api = AmplifyAPI(modelProvider: ModelProvider.instance);
    await Amplify.addPlugin(api);

    try {
      await Amplify.configure(amplifyconfig);
    } on Exception catch (e) {
      safePrint('An error occurred configuring Amplify: $e');
    }
  }

  Route _createRoute() {
    Widget nextScreen = const IntroScreen();
    switch (currentPageIndex) {
      case 0:
        nextScreen = const WriterScreen();
        break;
    }
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeIn;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

final MAIN_THEME = ThemeData(
  useMaterial3: true,

  scaffoldBackgroundColor: const Color.fromARGB(255, 245, 245, 245),

  // Define the default brightness and colors.
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    // ···
    brightness: Brightness.light,
  ),

  // Define the default `TextTheme`. Use this to specify the default
  // text styling for headlines, titles, bodies of text, and more.
  textTheme: TextTheme(
    titleLarge: GoogleFonts.openSans(
      fontSize: 48,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: GoogleFonts.openSans(
      fontSize: 14,
    ),
    displaySmall: GoogleFonts.openSans(
      fontSize: 10,
    ),
  ),
);
