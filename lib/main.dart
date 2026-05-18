import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_tracker/bloc/medicine_bloc.dart';
import 'package:medicine_tracker/data/repositories/medicine_repository.dart';
import 'package:medicine_tracker/ui/ui_config.dart';
import 'package:medicine_tracker/ui/pages/intro_screen.dart';

void main() {
  runApp(const MedicineTrackerApp());
}

class MedicineTrackerApp extends StatelessWidget {
  const MedicineTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MedicineBloc(
          repository: MedicineRepository()),
      child: MaterialApp(
        title: 'MediTrack',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashPage(),
      ),
    );
  }
}
