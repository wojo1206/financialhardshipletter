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
import 'package:simpleiawriter/blocs/edit.bloc.dart';
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

  final auth = AmplifyAuthCognito();

  final api = AmplifyAPI(modelProvider: ModelProvider.instance);
  final dataStore = AmplifyDataStore(
    modelProvider: ModelProvider.instance,
    syncExpressions: [
      DataStoreSyncExpression(Setting.classType, () => Setting.ID.eq("DUMMY"))
    ],
  );

  await Amplify.addPlugins([dataStore, api, auth]);

  try {
    await Amplify.configure(amplifyconfig);
  } on AmplifyAlreadyConfiguredException {
    safePrint(
        'Tried to reconfigure Amplify; this can occur when your app restarts on Android.');
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
          BlocProvider<EditBloc>(
            create: (BuildContext context) =>
                EditBloc(dataStoreRep: _dataStoreRepository),
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
        safePrint('$LifecycleEventHandler: resumeCallBack');
      },
      suspendingCallBack: () async {
        safePrint('$LifecycleEventHandler: suspendingCallBack');
      },
    ));

    sub1 = Amplify.Hub.listen(HubChannel.Auth, (AuthHubEvent event) async {
      switch (event.type) {
        case AuthHubEventType.signedIn:
          safePrint('$AuthHubEventType ${AuthHubEventType.signedIn}');
          break;
        case AuthHubEventType.signedOut:
          safePrint('$AuthHubEventType ${AuthHubEventType.signedOut}');
          break;
        case AuthHubEventType.sessionExpired:
          safePrint('$AuthHubEventType ${AuthHubEventType.sessionExpired}');
          break;
        case AuthHubEventType.userDeleted:
          safePrint('$AuthHubEventType ${AuthHubEventType.userDeleted}');
          break;
      }
    });

    sub2 = Amplify.Hub.listen(HubChannel.DataStore, (DataStoreHubEvent event) {
      switch (event.type) {
        case DataStoreHubEventType.networkStatus:
          safePrint('${DataStoreHubEventType.networkStatus}');
          break;
        case DataStoreHubEventType.ready:
          safePrint('${DataStoreHubEventType.ready}');
          break;
        case DataStoreHubEventType.subscriptionsEstablished:
          safePrint('${DataStoreHubEventType.subscriptionsEstablished}');
          break;
        case DataStoreHubEventType.syncQueriesStarted:
          safePrint('${DataStoreHubEventType.syncQueriesStarted}');
          break;
        case DataStoreHubEventType.modelSynced:
          safePrint('${DataStoreHubEventType.modelSynced}');
          break;
        case DataStoreHubEventType.syncQueriesReady:
          safePrint('${DataStoreHubEventType.syncQueriesReady}');
          break;
        case DataStoreHubEventType.outboxMutationEnqueued:
          safePrint('${DataStoreHubEventType.outboxMutationEnqueued}');
          break;
        case DataStoreHubEventType.outboxMutationProcessed:
          safePrint('${DataStoreHubEventType.outboxMutationProcessed}');
          break;
        case DataStoreHubEventType.outboxMutationFailed:
          safePrint('${DataStoreHubEventType.outboxMutationFailed}');
          break;
        case DataStoreHubEventType.outboxStatus:
          safePrint('${DataStoreHubEventType.outboxStatus}');
          break;
        case DataStoreHubEventType.subscriptionDataProcessed:
          safePrint('${DataStoreHubEventType.subscriptionDataProcessed}');
          break;
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
      body: Stack(
        children: [
          const AlertManager(),
          Column(
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
          )
        ],
      ),
    );
  }

  Future<void> _initPackageInfo() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    BlocProvider.of<AppBloc>(context).add(SetPackageInfo(info));
  }
}

/// This is basically an empty UI widget that only manages the alert.
class AlertManager extends StatelessWidget {
  const AlertManager({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state.error != null) {
          ViewHelper.myError(context, AppLocalizations.of(context)!.problem,
              Text(state.error.toString()));
        }
      },
      child: Container(),
    );
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
