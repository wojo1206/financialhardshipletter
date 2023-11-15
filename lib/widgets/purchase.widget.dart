import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:simpleiawriter/repos/purchase.repository.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  bool available = false;
  List<ProductDetails> products = [];
  final Set<String> consumables = <String>{
    'tokens_1000',
    'tokens_5000',
    'tokens_10000'
  };
  late InAppPurchaseRepository purchaseRep;
  late StreamSubscription<List<PurchaseDetails>> appSub;

  @override
  void initState() {
    purchaseRep = RepositoryProvider.of<InAppPurchaseRepository>(context);

    final Stream<List<PurchaseDetails>> purchaseUpdated =
        purchaseRep.getPurchaseStream();

    appSub =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      appSub.cancel();
    }, onError: (Object error) {
      // handle error here.
    });

    _loadProducts();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final item = products[index];
          return ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(item.title),
            trailing: ElevatedButton(
              onPressed: () {
                _purchase(item);
              },
              child: Text(item.price),
            ),
            subtitle: Text(item.description),
          );
        },
      ),
    );
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    safePrint(purchaseDetailsList);
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // _showPendingUI();
      } else {
        safePrint(purchaseDetails);
        if (purchaseDetails.status == PurchaseStatus.error) {
          safePrint(purchaseDetails.error);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          bool valid = true;
          // await _verifyPurchase(purchaseDetails);
          if (valid) {
            // _deliverProduct(purchaseDetails);
          } else {
            // _handleInvalidPurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      }
    });
  }

  void _purchase(ProductDetails productDetails) {
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);

    purchaseRep.buyConsumable(purchaseParam);
  }

  void _loadProducts() async {
    available = await purchaseRep.isAvailable();

    if (!available) {
      // The store cannot be reached or accessed. Update the UI accordingly.

      return;
    }

    // Set literals require Dart 2.2. Alternatively, use
    // `Set<String> _kIds = <String>['product1', 'product2'].toSet()`.

    final ProductDetailsResponse response =
        await purchaseRep.queryProductDetails(consumables);
    if (response.notFoundIDs.isNotEmpty) {
      // Handle the error.
    }

    setState(() {
      products = response.productDetails;
      products.sort(((a, b) => a.rawPrice < b.rawPrice ? -1 : 1));
    });
  }
}
