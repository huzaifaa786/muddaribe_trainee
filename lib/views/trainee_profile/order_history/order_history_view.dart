// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mudarribe_trainee/api/order_api.dart';
import 'package:mudarribe_trainee/components/ordercard.dart';
import 'package:mudarribe_trainee/components/topbar.dart';
import 'package:mudarribe_trainee/models/combine_order.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class OrderhistoryView extends StatefulWidget {
  const OrderhistoryView({super.key});

  @override
  State<OrderhistoryView> createState() => _OrderhistoryViewState();
}

class _OrderhistoryViewState extends State<OrderhistoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          forceMaterialTransparency: true,
          title: TopBar(text: "Orders History"),
        ),
        body: SafeArea(
          child: FutureBuilder<List<CombinedOrderData>>(
              future: OrderApi.fetchOrders(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('');
                }
                if (!snapshot.hasData) {
                  return Center(
                    heightFactor: 15,
                    child: Text(
                      'No Order Found !',
                      style: TextStyle(color: white.withOpacity(0.7)),
                    ),
                  );
                }
                List<CombinedOrderData> orders = snapshot.data!;
                return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (BuildContext context, int index) {
                      return OrderCard(
                        trainer: orders[index].combinedPackageData!.trainer,
                        package: orders[index].combinedPackageData!.package,
                        order: orders[index].order,
                      );
                    });
              }),
        ));
  }
}
