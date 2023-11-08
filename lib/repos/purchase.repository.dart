import 'package:in_app_purchase/in_app_purchase.dart';

abstract class PurchaseRepository {
  Future<bool> buyConsumable(PurchaseParam purchaseParam);

  Future<bool> buyNonConsumable(PurchaseParam purchaseParam);

  Stream<List<PurchaseDetails>> getPurchaseStream();

  Future<bool> isAvailable();

  Future<ProductDetailsResponse> queryProductDetails(Set<String> consumables);
}

class InAppPurchaseRepository implements PurchaseRepository {
  InAppPurchaseRepository({required this.instance});

  final InAppPurchase instance;

  @override
  Future<bool> buyConsumable(PurchaseParam purchaseParam) {
    return instance.buyConsumable(purchaseParam: purchaseParam);
  }

  @override
  Future<bool> buyNonConsumable(PurchaseParam purchaseParam) {
    return instance.buyNonConsumable(purchaseParam: purchaseParam);
  }

  @override
  Stream<List<PurchaseDetails>> getPurchaseStream() {
    return instance.purchaseStream;
  }

  @override
  Future<bool> isAvailable() {
    return instance.isAvailable();
  }

  @override
  Future<ProductDetailsResponse> queryProductDetails(Set<String> consumables) {
    return instance.queryProductDetails(consumables);
  }
}
