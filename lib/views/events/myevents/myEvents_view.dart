// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:mudarribe_trainee/components/appbar.dart';
import 'package:mudarribe_trainee/components/myEventContainer.dart';

class MyEventsView extends StatefulWidget {
  const MyEventsView({super.key});

  @override
  State<MyEventsView> createState() => _MyEventsViewState();
}

class _MyEventsViewState extends State<MyEventsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopScreenBar(
              mytext: "My Events",
            ),
            Padding(
                padding: const EdgeInsets.only(top: 28),
                child: Column(
                  children: [
                    MyEventsContainer(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: MyEventsContainer(),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
