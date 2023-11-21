import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:simpleiawriter/blocs/app.bloc.dart';
import 'package:simpleiawriter/blocs/auth.bloc.dart';
import 'package:simpleiawriter/blocs/history.bloc.dart';
import 'package:simpleiawriter/blocs/purchase.bloc.dart';
import 'package:simpleiawriter/blocs/writing.bloc.dart';
import 'package:simpleiawriter/helpers/view.helper.dart';
import 'package:simpleiawriter/repos/api.repository.dart';
import 'package:simpleiawriter/repos/auth.repository.dart';
import 'package:simpleiawriter/repos/datastore.repository.dart';
import 'package:simpleiawriter/repos/purchase.repository.dart';
import 'package:simpleiawriter/widgets/questions.screen.dart';
import 'package:simpleiawriter/widgets/layout/drawer.widget.dart';

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
    inAppPurchaseRepository: InAppPurchaseRepository(
        instance: InAppPurchase.instance, dataStore: dataStore),
  ));
}

class App extends StatelessWidget {
  const App(
      {Key? key,
      required AmplifyAppRepository apiRepository,
      required AmplifyAuthRepository authRepository,
      required AmplifyDataStoreRepository dataStoreRepository,
      required InAppPurchaseRepository inAppPurchaseRepository})
      : _appRepository = apiRepository,
        _authRepository = authRepository,
        _dataStoreRepository = dataStoreRepository,
        _inAppPurchaseRepository = inAppPurchaseRepository,
        super(key: key);

  final ApiRepository _appRepository;
  final AuthRepository _authRepository;
  final DataStoreRepository _dataStoreRepository;
  final InAppPurchaseRepository _inAppPurchaseRepository;

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
        RepositoryProvider<InAppPurchaseRepository>(
            create: (context) => _inAppPurchaseRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppBloc>(
            create: (BuildContext context) => AppBloc(),
          ),
          BlocProvider<AuthBloc>(
            create: (BuildContext context) => AuthBloc(
                authRep: _authRepository, dataStoreRep: _dataStoreRepository),
          ),
          BlocProvider<HistoryBloc>(
            create: (BuildContext context) =>
                HistoryBloc(dataStoreRep: _dataStoreRepository),
          ),
          BlocProvider<PurchaseBloc>(
            create: (BuildContext context) => PurchaseBloc(
                purchaseRepository: _inAppPurchaseRepository,
                dataStoreRepository: _dataStoreRepository),
          ),
          BlocProvider<WritingBloc>(
            create: (BuildContext context) =>
                WritingBloc(dataStoreRep: _dataStoreRepository),
          ),
        ],
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
  late StreamSubscription<AuthHubEvent> sub1;
  late StreamSubscription<DataStoreHubEvent> sub2;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(LifecycleEventHandler(
      resumeCallBack: () async {
        safePrint("resumeCallBack");
      },
      suspendingCallBack: () async {
        safePrint("suspendingCallBack");
      },
    ));

    sub1 = Amplify.Hub.listen(HubChannel.Auth, (AuthHubEvent event) {
      switch (event.type) {
        case AuthHubEventType.signedIn:
          safePrint('User is signed in.');
          break;
        case AuthHubEventType.signedOut:
          safePrint('User is signed out.');
          break;
        case AuthHubEventType.sessionExpired:
          safePrint('The session has expired.');
          break;
        case AuthHubEventType.userDeleted:
          safePrint('The user has been deleted.');
          break;
      }
    });

    sub2 = Amplify.Hub.listen(HubChannel.DataStore, (DataStoreHubEvent event) {
      switch (event.type) {
        case DataStoreHubEventType.networkStatus:
          safePrint(
              'Network status has change to .' + event.payload.toString());
          break;
        case DataStoreHubEventType.ready:
          safePrint('DataStore is ready.');
          break;
        case DataStoreHubEventType.subscriptionsEstablished:
          safePrint('Subscription estabilished.');
          break;
        case DataStoreHubEventType.syncQueriesStarted:
        // TODO: Handle this case.
        case DataStoreHubEventType.modelSynced:
        // TODO: Handle this case.
        case DataStoreHubEventType.syncQueriesReady:
        // TODO: Handle this case.
        case DataStoreHubEventType.outboxMutationEnqueued:
        // TODO: Handle this case.
        case DataStoreHubEventType.outboxMutationProcessed:
        // TODO: Handle this case.
        case DataStoreHubEventType.outboxMutationFailed:
        // TODO: Handle this case.
        case DataStoreHubEventType.outboxStatus:
        // TODO: Handle this case.
        case DataStoreHubEventType.subscriptionDataProcessed:
        // TODO: Handle this case.
      }
    });

    _initPackageInfo();
  }

  @override
  void dispose() {
    sub1.cancel();
    sub2.cancel();

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
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          AppLocalizations.of(context)!
                              .appName
                              .replaceAll(" ", "\n"),
                          style: const TextStyle(
                              fontSize: 100,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              height: 1),
                        ),
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
                          const QuestionsScreen(),
                        ),
                      ),
                      child: Text(AppLocalizations.of(context)!.appStart),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppLocalizations.of(context)!.appStartExplain,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Future<void> _initPackageInfo() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    BlocProvider.of<AppBloc>(context).add(SetPackageInfo(info));
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
