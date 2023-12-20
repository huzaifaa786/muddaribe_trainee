import 'package:flutter/material.dart';
import 'package:mudarribe_trainee/components/exercises_card.dart';
import 'package:mudarribe_trainee/components/topbar.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Column(
        children: [
          TopBar(text: 'Exercises'),
          Column(
            children: [
            ExercisesCard(title: 'Mornning Woekouts', description: '3 files , 4 videos'),
            ExercisesCard(title: 'Full body Woekoutss', description: '3 files , 4 videos'),
            ExercisesCard(title: 'Random Woekouts', description: '3 files , 4 videos'),
            ],
          )
        ],
      )),
    );
  }
}
