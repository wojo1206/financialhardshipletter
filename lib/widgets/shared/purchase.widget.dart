import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:simpleiawriter/blocs/purchase.bloc.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<PurchaseBloc>(context).add(Start());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurchaseBloc, PurchaseState>(builder: (context, state) {
      return state.stateLoading == StateLoading.loading
          ? const SizedBox(
              width: 50.0,
              height: 50.0,
              child: Center(
                child: CircularProgressIndicator(
                  semanticsLabel: 'Loading',
                ),
              ),
            )
          : SizedBox(
              width: 300,
              height: 220,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final item = state.products[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(item.title),
                    trailing: ElevatedButton(
                      onPressed: state.statePurchase == StatePurchase.loading
                          ? null
                          : () {
                              BlocProvider.of<PurchaseBloc>(context).add(
                                Buy(
                                  PurchaseParam(productDetails: item),
                                ),
                              );
                            },
                      child: Text(item.price),
                    ),
                    subtitle: Text(item.description),
                  );
                },
              ),
            );
    });
  }
}
