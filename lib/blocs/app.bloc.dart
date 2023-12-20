import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpleiawriter/repos/datastore.repository.dart';

enum SyncState { notSynced, inProgress, synced }

class AppState {
  const AppState(
      {this.sync = SyncState.notSynced,
      this.error = "",
      this.appVersion = "",
      this.isOnline = false});

  final bool isOnline;
  final SyncState sync;
  final String error;
  final String appVersion;

  AppState copyWith(
          {SyncState? syncState = SyncState.notSynced,
          bool? isOnline = false,
          String? error,
          String? appVersion}) =>
      AppState(
          isOnline: isOnline ?? this.isOnline,
          error: error ?? this.error,
          appVersion: appVersion ?? this.appVersion);
}

sealed class AppEvent {}

final class SetError extends AppEvent {
  final String error;

  SetError(this.error);
}

final class SetPackageInfo extends AppEvent {
  final String appVersion;

  SetPackageInfo(this.appVersion);
}

final class SetIsOnline extends AppEvent {
  final bool isOnline;

  SetIsOnline(this.isOnline);
}

final class SyncChange extends AppEvent {
  final SyncState state;

  SyncChange(this.state);
}

final class SyncRefresh extends AppEvent {
  SyncRefresh();
}

final class UserLogOut extends AppEvent {}

class AppBloc extends Bloc<AppEvent, AppState> {
  final DataStoreRepository _dataStoreRep;

  AppBloc({
    required DataStoreRepository dataStoreRep,
  })  : _dataStoreRep = dataStoreRep,
        super(const AppState()) {
    on<SyncChange>((event, emit) {
      emit(state.copyWith(syncState: event.state));
    });

    on<SyncRefresh>((event, emit) {
      _dataStoreRep.stop();
      _dataStoreRep.start();
      emit(state);
    });

    on<SetError>((event, emit) {
      emit(state.copyWith(error: event.error));
    });

    on<SetIsOnline>((event, emit) {
      emit(state.copyWith(isOnline: event.isOnline));
    });

    on<SetPackageInfo>((event, emit) {
      emit(state.copyWith(appVersion: event.appVersion));
    });
  }
}
