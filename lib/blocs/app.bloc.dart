import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppState {
  const AppState({this.error, this.packageInfo});

  final String? error;
  final PackageInfo? packageInfo;
}

sealed class AppEvent {}

final class SetError extends AppEvent {
  final String error;

  SetError(this.error);
}

final class SetPackageInfo extends AppEvent {
  final PackageInfo packageInfo;

  SetPackageInfo(this.packageInfo);
}

final class UserLogOut extends AppEvent {}

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppState()) {
    on<SetError>((event, emit) {
      emit(AppState(error: event.error, packageInfo: state.packageInfo));
    });

    on<SetPackageInfo>((event, emit) {
      emit(AppState(error: state.error, packageInfo: event.packageInfo));
    });
  }
}
