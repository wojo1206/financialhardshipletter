import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart' show safePrint;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:simpleiawriter/constants.dart';
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

final class BuyUpdate extends PurchaseEvent {
  final List<PurchaseDetails> purchaseDetailsList;

  BuyUpdate(this.purchaseDetailsList);
}

final class Load extends PurchaseEvent {
  Load();
}

final class Start extends PurchaseEvent {
  Start();
}

final class Stop extends PurchaseEvent {
  Stop();
}

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  final PurchaseRepository _purchaseRepository;
  final DataStoreRepository _dataStoreRepository;
  late StreamSubscription<List<PurchaseDetails>> _appSub;

  PurchaseBloc(
      {required PurchaseRepository purchaseRepository,
      required DataStoreRepository dataStoreRepository})
      : _purchaseRepository = purchaseRepository,
        _dataStoreRepository = dataStoreRepository,
        super(const PurchaseState(products: [])) {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _purchaseRepository.getPurchaseStream();

    on<Buy>((event, emit) async {
      emit(PurchaseState(
          products: state.products, statePurchase: StatePurchase.loading));

      await _purchaseRepository.buyConsumable(event.purchaseParam);

      emit(PurchaseState(
          products: state.products, statePurchase: StatePurchase.notLoading));
    });

    on<BuyUpdate>((event, emit) async {
      event.purchaseDetailsList
          .forEach((PurchaseDetails purchaseDetails) async {
        if (purchaseDetails.status == PurchaseStatus.pending) {
          emit(PurchaseState(
            products: state.products,
            statePurchase: StatePurchase.loading,
          ));
        } else {
          if (purchaseDetails.status == PurchaseStatus.error) {
          } else if (purchaseDetails.status == PurchaseStatus.purchased ||
              purchaseDetails.status == PurchaseStatus.restored) {
            bool valid = true;
            await _verifyPurchase(purchaseDetails);
            if (valid) {
              // _deliverProduct(purchaseDetails);
            } else {
              // _handleInvalidPurchase(purchaseDetails);
            }
          }
          if (purchaseDetails.pendingCompletePurchase) {
            await _purchaseRepository.completePurchase(purchaseDetails);
          }
          emit(PurchaseState(
            products: state.products,
            statePurchase: StatePurchase.notLoading,
          ));
        }
      });
    });

    on<Load>((event, emit) async {
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
    });

    on<Start>((event, emit) async {
      _appSub =
          purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
        BuyUpdate(purchaseDetailsList);
        safePrint('purchaseUpdated');
      }, onDone: () {
        safePrint('onDone');
      }, onError: (Object error) {});
    });

    on<Stop>((event, emit) async {
      _appSub.cancel();
    });
  }

  Future<bool> _verifyPurchase(purchaseDetails) async {
    try {} catch (ex) {}
    return false;
  }
}
