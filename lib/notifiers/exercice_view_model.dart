import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
//import 'package:geolocator/geolocator.dart';
import 'dart:async';



class ExerciceViewModel extends ChangeNotifier {

    late Stream<StepCount> stepCountStream;
    late StreamSubscription<StepCount> stepCountStreamSubscription;
    Stopwatch stopwatch = Stopwatch();
    Timer? timer;
  
    late DateTime startDate;  
    late DateTime endDate;
    int steps=0;
    int stepsOnStart=0;
    double calories=0;
    double distance=0;
    bool isRunning = false;
    bool notStart = true;
    //final List<Position> _positionItems = <Position>[];
    //final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

    ExerciceViewModel() {
      startDate = DateTime.now();
      endDate = DateTime.now();
      steps = 0;
      stepsOnStart=0;
      calories=0;
      distance=0;
      isRunning = false;
    }

    startExercice(){
      startDate = DateTime.now();

      steps = 0;
      notStart=false;
      //stopwatch.reset();
      //stopwatch.start();
      if (isRunning) {
        stopwatch.stop();

        stepCountStreamSubscription.cancel();

        timer?.cancel();
        isRunning = false;
        notifyListeners();
      } else {
        debugPrint("on est la");
       // _trackPosition();
        debugPrint("PUIS on est la");
        stopwatch.start();
        isRunning = true;
        timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          notifyListeners();
        });

        stepCountStream = Pedometer.stepCountStream;
        stepCountStreamSubscription = stepCountStream.listen(onStepCount);
        stepCountStreamSubscription.onError(onStepCountError);
        notifyListeners();
      }

    }


    resetExercice(){
      endDate = DateTime.now();
      isRunning = false;
      stopwatch.reset();
      timer?.cancel();
      notStart=true;
      stepCountStreamSubscription.cancel();
      stepsOnStart=0;
      notifyListeners();
    }


    void onStepCount(StepCount event) {
      if (stepsOnStart == 0) {
        stepsOnStart = event.steps;
      }
      steps = event.steps-stepsOnStart;

      //pas besoin de notifer,, on notifie toutes les secondes pour le chrono
      //notifyListeners();
    }

    void onStepCountError(error) {
      steps = 0;
      //notifyListeners();
    }

/*
    void _trackPosition() async {
debugPrint("tracking $isRunning");
      if (isRunning) return;
  debugPrint("position");
      final hasPermission = await _handlePermission();

      if (!hasPermission) {
        return;
      }


      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );

      StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
    (Position? position) {
        print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
    });
      // Attendre 10 secondes avant la prochaine mise à jour
      
    }



    Future<bool> _handlePermission() async {
        bool serviceEnabled;
        LocationPermission permission;

        
        serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
        if (!serviceEnabled) {
          // Location services are not enabled don't continue
          // accessing the position and request users of the
          // App to enable the location services.
          return false;
        }

        permission = await _geolocatorPlatform.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await _geolocatorPlatform.requestPermission();
          if (permission == LocationPermission.denied) {
            // Permissions are denied, next time you could try
            // requesting permissions again (this is also where
            // Android's shouldShowRequestPermissionRationale
            // returned true. According to Android guidelines
            // your App should show an explanatory UI now.
            return false;
          }
        }

        if (permission == LocationPermission.deniedForever) {
          // Permissions are denied forever, handle appropriately.
          return false;
        }

        return true;
      }

*/
  
}
