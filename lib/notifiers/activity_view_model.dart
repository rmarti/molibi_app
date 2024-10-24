import 'package:flutter/material.dart';
import 'package:molibi_app/widget/molibi_activity_bloc.dart';
import 'package:molibi_app/services/health_service.dart';

mixin ActivityViewModel on State<MolibiActivityBloc> {
  int? totalSteps;
  double? totalCalories;
  double? totalDistance;
  late HealthService healthService = HealthService();


//Read Health related Data
  Future getSteps() async {
    
    final currentDate = DateTime.now();
    final startDate = DateTime(currentDate.year, currentDate.month, currentDate.day);
    int? steps;
    try {
      steps = await healthService.getSteps(startDate,currentDate);
      if (steps == -1) {
        debugPrint("Authorization not granted");
      }
    } catch (e) {
      debugPrint("Error message::::$e");
    }
    setState(() {
      totalSteps = steps ?? 0;
    });
    
  }


  Future getCaloriesBurned() async {
    
    final currentDate = DateTime.now();
    final startDate = DateTime(currentDate.year, currentDate.month, currentDate.day);
    double? calories;
    try {
      calories = await healthService.getCaloriesBurned(startDate,currentDate);
      if (calories == -1) {
        debugPrint("Authorization not granted");
      }
    } catch (e) {
      debugPrint("Error message::::$e");
    }
    setState(() {
      totalCalories = calories ?? 0;
    });
    
  }

  Future getDistance() async {
    
    final currentDate = DateTime.now();
    final startDate = DateTime(currentDate.year, currentDate.month, currentDate.day);
    double? distance;
    try {
      distance = await healthService.getDistance(startDate,currentDate);
      if (distance == -1) {
        debugPrint("Authorization not granted");
      }
    } catch (e) {
      debugPrint("Error message::::$e");
    }
    setState(() {
      totalDistance = distance ?? 0;
    });
    
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    healthService = HealthService();
    healthService.initialize().then((_) {
      getCaloriesBurned();
      getDistance();
      getSteps();
    });
  }
}