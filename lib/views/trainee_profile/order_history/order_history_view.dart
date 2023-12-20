// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mudarribe_trainee/components/ordercard.dart';
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
          backgroundColor: Colors.black,
          leading: Icon(
            Icons.arrow_back_ios_new,
            color: white,
          ),
          title: Text(
            'Event Check out',
            style: TextStyle(
                fontSize: 20,
                color: white,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins'),
          ),
        ),
        body: ListView.builder(
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return OrderCard();
            }));
  }
}
