import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:simpleiawriter/bloc/app.cubit.dart';
import 'package:simpleiawriter/bloc/app.repository.dart';
import 'package:simpleiawriter/bloc/auth.repository.dart';
import 'package:simpleiawriter/widgets/account.screen.dart';
import 'package:simpleiawriter/widgets/assistant-writer/step1.screen.dart';
import 'package:simpleiawriter/widgets/auth/login.screen.dart';
import 'package:simpleiawriter/widgets/history.screen.dart';
import 'package:simpleiawriter/widgets/intro.screen.dart';
import 'package:simpleiawriter/widgets/settings.screen.dart';

import 'amplifyconfiguration.dart';
import 'models/ModelProvider.dart';

void main() async {
  // Avoid errors caused by flutter upgrade.
  WidgetsFlutterBinding.ensureInitialized();

  final api = AmplifyAPI(modelProvider: ModelProvider.instance);
  final auth = AmplifyAuthCognito();

  await Amplify.addPlugin(api);
  await Amplify.addPlugin(auth);

  try {
    await Amplify.configure(amplifyconfig);
  } on Exception catch (e) {
    safePrint('An error occurred configuring Amplify: $e');
  }

  runApp(App(
    apiRepository: AmplifyAppRepository(api: api),
    authRepository: AmplifyAuthRepository(auth: auth),
  ));
}

class App extends StatelessWidget {
  const App(
      {Key? key,
      required AmplifyAppRepository apiRepository,
      required AmplifyAuthRepository authRepository})
      : _appRepository = apiRepository,
        _authRepository = authRepository,
        super(key: key);

  final AppRepository _appRepository;
  final AuthRepository _authRepository;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AppRepository>(create: (context) => _appRepository),
        RepositoryProvider<AuthRepository>(
            create: (context) => _authRepository),
      ],
      child: BlocProvider(
        create: (_) => AppBloc(),
        child: MaterialApp(
          theme: MAIN_THEME,
          home: const HomeScreen(),
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
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PackageInfo _packageInfo = PackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
    buildSignature: '',
    installerStore: '',
  );

  @override
  void initState() {
    super.initState();

    _initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Hardship Letter Assistant',
              style: Theme.of(context).textTheme.bodyMedium),
        ),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Image.asset(
                  'assets/images/img1-kelly-sikkema.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              ListTile(
                title: const Text('Account'),
                onTap: () {
                  Navigator.of(context)
                      .push(_createRoute(const AccountScreen()));
                },
              ),
              ListTile(
                title: const Text('History'),
                onTap: () {
                  Navigator.of(context)
                      .push(_createRoute(const HistoryScreen()));
                },
              ),
              ListTile(
                title: const Text('Settings'),
                onTap: () {
                  Navigator.of(context)
                      .push(_createRoute(const SettingsScreen()));
                },
              ),
              ListTile(
                title: const Text('Sign Out'),
                onTap: () async {
                  final appRep = RepositoryProvider.of<AuthRepository>(context);
                  await appRep.signOut();

                  Navigator.of(context)
                      .push(_createRoute(const SettingsScreen()));
                },
              ),
              ListTile(
                title: const Text('Version'),
                onTap: () {},
                enabled: false,
                subtitle: Text(_packageInfo.version),
              ),
            ],
          ),
        ),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            heroTag: "btn1",
            onPressed: () {
              Navigator.of(context)
                  .push(_createRoute(const WriterAssistantStep1()));
            },
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: () {
              Navigator.of(context).push(_createRoute(const LoginScreen()));
            },
            child: const Icon(Icons.account_box),
          )
        ]),
        body: const Column(
          children: [],
        ));
  }

  Route _createRoute(Widget nextScreen) {
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

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }
}

final MAIN_THEME = ThemeData(
  useMaterial3: true,

  scaffoldBackgroundColor: const Color.fromARGB(255, 245, 245, 245),

  primarySwatch: Colors.blue,

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
