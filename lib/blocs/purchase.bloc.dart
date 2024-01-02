import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart' show safePrint;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:simpleiawriter/constants.dart';
import 'package:simpleiawriter/models/ModelProvider.dart';
import 'package:simpleiawriter/repos/api.repository.dart';
import 'package:simpleiawriter/repos/auth.repository.dart';
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
  final DataStoreRepository _dataStoreRep;
  final PurchaseRepository _purchaseRep;
  final ApiRepository _apiRep;

  PurchaseBloc(
      {required DataStoreRepository dataStoreRepository,
      required PurchaseRepository purchaseRepository,
      required ApiRepository apiRepository})
      : _dataStoreRep = dataStoreRepository,
        _purchaseRep = purchaseRepository,
        _apiRep = apiRepository,
        super(const PurchaseState(products: [])) {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _purchaseRep.getPurchaseStream();
    final StreamSubscription<List<PurchaseDetails>> _appSub =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      add(Update(purchaseDetailsList));
    }, onDone: () {}, onError: (Object error) {});

    on<Buy>((event, emit) async {
      try {
        emit(PurchaseState(
            products: state.products, statePurchase: StatePurchase.loading));

        await _purchaseRep.buyConsumable(event.purchaseParam);

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

          bool valid = true;
          switch (purchaseDetails.status) {
            case PurchaseStatus.pending:
              emit(PurchaseState(
                products: state.products,
                statePurchase: StatePurchase.loading,
              ));
              valid = await _verifyPurchase(purchaseDetails);
              break;
            case PurchaseStatus.restored:
            case PurchaseStatus.purchased:
              emit(PurchaseState(
                products: state.products,
                statePurchase: StatePurchase.notLoading,
              ));
              valid = await _verifyPurchase(purchaseDetails);
              break;
            case PurchaseStatus.error:
            case PurchaseStatus.canceled:
              emit(PurchaseState(
                products: state.products,
                statePurchase: StatePurchase.notLoading,
              ));
          }

          if (valid && purchaseDetails.pendingCompletePurchase) {
            safePrint('$PurchaseBloc: completePurchase');
            await _purchaseRep.completePurchase(purchaseDetails);
          } else if (!valid) {
            throw Exception("Can't purchase.");
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

        bool available = await _purchaseRep.isAvailable();

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
        products.sort(((a, b) => a.rawPrice < b.rawPrice ? 1 : -1));

        emit(PurchaseState(
            products: products, stateLoading: StateLoading.notLoading));
      } catch (ex) {
        addError(ex, StackTrace.current);
      }
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    try {
      /**
       * Crucial. Read or create setting object.
       */
      final resp = await _apiRep.settingList();
      final settings = resp.data?.items;

      if (settings == null) {
        throw Exception('No settings.');
      }

      if (settings.length != 1) {
        throw Exception('Not exactly one setting.');
      }

      Setting? setting = settings.first;

      if (setting == null) {
        throw Exception('No first settings.');
      }

      final moreTokens = consumables[purchaseDetails.productID] ?? 0;
      if (moreTokens == 0) {
        throw Exception('Invalid product.');
      }

      final newSetting = setting.copyWith(tokens: setting.tokens + moreTokens);
      await _dataStoreRep.settingUpdate(newSetting);

      return true;
    } catch (ex) {
      addError(ex, StackTrace.current);
    }
    return false;
  }
}
