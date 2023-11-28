import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart' show safePrint;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:simpleiawriter/constants.dart';
import 'package:simpleiawriter/models/ModelProvider.dart';
import 'package:simpleiawriter/repos/datastore.repository.dart';

import 'package:simpleiawriter/repos/purchase.repository.dart';

enum StateLoading { notLoading, loading }

enum StatePurchase { notLoading, loading }

class PurchaseState {
  final List<ProductDetails> products;
  final StateLoading stateLoading;
  final StatePurchase statePurchase;

  const PurchaseState(
      {required this.products,
      this.stateLoading = StateLoading.notLoading,
      this.statePurchase = StatePurchase.notLoading});
}

sealed class PurchaseEvent {}

final class Buy extends PurchaseEvent {
  final PurchaseParam purchaseParam;

  Buy(this.purchaseParam);
}

final class Update extends PurchaseEvent {
  final List<PurchaseDetails> purchaseDetailsList;

  Update(this.purchaseDetailsList);
}

final class Start extends PurchaseEvent {
  Start();
}

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  final PurchaseRepository _purchaseRepository;
  final DataStoreRepository _dataStoreRepository;

  PurchaseBloc(
      {required PurchaseRepository purchaseRepository,
      required DataStoreRepository dataStoreRepository})
      : _purchaseRepository = purchaseRepository,
        _dataStoreRepository = dataStoreRepository,
        super(const PurchaseState(products: [])) {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _purchaseRepository.getPurchaseStream();
    final StreamSubscription<List<PurchaseDetails>> _appSub =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      add(Update(purchaseDetailsList));
    }, onDone: () {}, onError: (Object error) {});

    on<Buy>((event, emit) async {
      try {
        emit(PurchaseState(
            products: state.products, statePurchase: StatePurchase.loading));

        await _purchaseRepository.buyConsumable(event.purchaseParam);

        emit(PurchaseState(
            products: state.products, statePurchase: StatePurchase.notLoading));
      } catch (ex) {
        addError(ex, StackTrace.current);
      }
    });

    on<Update>((event, emit) async {
      try {
        for (var purchaseDetails in event.purchaseDetailsList) {
          safePrint('$PurchaseBloc: ${purchaseDetails.status.toString()}');

          switch (purchaseDetails.status) {
            case PurchaseStatus.pending:
              emit(PurchaseState(
                products: state.products,
                statePurchase: StatePurchase.loading,
              ));

              await _verifyPurchase(purchaseDetails);
              break;
            case PurchaseStatus.restored:
            case PurchaseStatus.purchased:
              bool valid = true;
              await _verifyPurchase(purchaseDetails);

              emit(PurchaseState(
                products: state.products,
                statePurchase: StatePurchase.notLoading,
              ));
              break;
            case PurchaseStatus.error:
            case PurchaseStatus.canceled:
              emit(PurchaseState(
                products: state.products,
                statePurchase: StatePurchase.notLoading,
              ));
          }

          if (purchaseDetails.pendingCompletePurchase) {
            safePrint('$PurchaseBloc: completePurchase');
            await _purchaseRepository.completePurchase(purchaseDetails);
          }
        }
      } catch (ex) {
        addError(ex, StackTrace.current);
      }
    });

    on<Start>((event, emit) async {
      try {
        if (_appSub.isPaused) {
          _appSub.resume();
        }

        emit(PurchaseState(
            products: state.products, stateLoading: StateLoading.loading));

        bool available = await _purchaseRepository.isAvailable();

        if (!available) {
          // The store cannot be reached or accessed. Update the UI accordingly.
          return;
        }

        final ProductDetailsResponse response = await purchaseRepository
            .queryProductDetails(consumables.keys.toSet());

        if (response.notFoundIDs.isNotEmpty) {
          // Handle the error.
        }

        List<ProductDetails> products = response.productDetails;
        products.sort(((a, b) => a.rawPrice < b.rawPrice ? -1 : 1));

        emit(PurchaseState(
            products: products, stateLoading: StateLoading.notLoading));
      } catch (ex) {
        addError(ex, StackTrace.current);
      }
    });
  }

  Future<bool> _verifyPurchase(purchaseDetails) async {
    try {
      Setting? setting = await _dataStoreRepository.settingFetch();
      if (setting == null) {
        throw Exception('No settings.');
      }

      final newSetting = await _dataStoreRepository.settingUpdate(setting);
      safePrint(newSetting);
    } catch (ex) {}
    return false;
  }
}
