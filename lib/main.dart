import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';

import 'package:package_info_plus/package_info_plus.dart';

import 'package:simpleiawriter/bloc/app.bloc.dart';
import 'package:simpleiawriter/bloc/api.repository.dart';
import 'package:simpleiawriter/bloc/auth.repository.dart';
import 'package:simpleiawriter/bloc/datastore.repository.dart';
import 'package:simpleiawriter/helpers/view.helper.dart';
import 'package:simpleiawriter/widgets/account.screen.dart';
import 'package:simpleiawriter/widgets/assistant-writer/step1.screen.dart';
import 'package:simpleiawriter/widgets/auth/login.screen.dart';
import 'package:simpleiawriter/widgets/history.screen.dart';
import 'package:simpleiawriter/widgets/layout/drawer.widget.dart';
import 'package:simpleiawriter/widgets/purchase.screen.dart';
import 'package:simpleiawriter/widgets/settings.screen.dart';

import 'amplifyconfiguration.dart';
import 'models/ModelProvider.dart';

void main() async {
  // Avoid errors caused by flutter upgrade.
  WidgetsFlutterBinding.ensureInitialized();

  final api = AmplifyAPI(modelProvider: ModelProvider.instance);
  final auth = AmplifyAuthCognito();
  final dataStore = AmplifyDataStore(modelProvider: ModelProvider.instance);

  await Amplify.addPlugins([auth, dataStore, api]);

  try {
    await Amplify.configure(amplifyconfig);
  } on Exception catch (e) {
    safePrint('An error occurred configuring Amplify: $e');
  }

  runApp(App(
    apiRepository: AmplifyAppRepository(api: api),
    authRepository: AmplifyAuthRepository(auth: auth),
    dataStoreRepository: AmplifyDataStoreRepository(dataStore: dataStore),
  ));
}

class App extends StatelessWidget {
  const App(
      {Key? key,
      required AmplifyAppRepository apiRepository,
      required AmplifyAuthRepository authRepository,
      required AmplifyDataStoreRepository dataStoreRepository})
      : _appRepository = apiRepository,
        _authRepository = authRepository,
        _dataStoreRepository = dataStoreRepository,
        super(key: key);

  final ApiRepository _appRepository;
  final AuthRepository _authRepository;
  final DataStoreRepository _dataStoreRepository;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ApiRepository>(create: (context) => _appRepository),
        RepositoryProvider<AuthRepository>(
            create: (context) => _authRepository),
        RepositoryProvider<DataStoreRepository>(
            create: (context) => _dataStoreRepository),
      ],
      child: BlocProvider(
        create: (BuildContext context) => AppBloc(),
        child: MaterialApp(
          theme: MAIN_THEME,
          home: const HomeScreen(),
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
  bool _test = false;
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

    final authRep = RepositoryProvider.of<AuthRepository>(context);

    WidgetsBinding.instance.addObserver(LifecycleEventHandler(
      resumeCallBack: () async {
        safePrint("resumeCallBack");

        BlocProvider.of<AppBloc>(context)
            .add(UserLogIn(await authRep.isUserSignedIn()));
      },
      suspendingCallBack: () async {
        safePrint("suspendingCallBack");
      },
    ));

    _initPackageInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.appName,
              style: Theme.of(context).textTheme.bodyMedium),
        ),
        drawer: const MyDrawer(),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(color: MAIN_THEME.primaryColor),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.appName,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            height: 1),
                      ),
                      Text(
                        AppLocalizations.of(context)!.appCatchyPhrase,
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () => Navigator.of(context).push(
                                ViewHelper.routeSlide(
                                  const WriterAssistantStep1(),
                                ),
                              ),
                          child: Text(
                              AppLocalizations.of(context)!.appStartButton)),
                    ]),
              ),
            )
          ],
        ));
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }
}

/// The life-cycle event handler is global. Gets triggered when sub pages!
class LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback resumeCallBack;
  final AsyncCallback suspendingCallBack;

  LifecycleEventHandler({
    required this.resumeCallBack,
    required this.suspendingCallBack,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        await resumeCallBack();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        await suspendingCallBack();
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
  }
}

final MAIN_THEME = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: const Color.fromARGB(255, 245, 245, 245),
  colorSchemeSeed: Colors.blue,
  fontFamily: 'LibreBaskerville',
);
