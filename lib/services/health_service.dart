import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class HealthService {

  bool isAuthorized = false;

  HealthService() {    
    Health().configure( );
  }

  Future<void> initialize() async {
    await requestAuthorization();
  }


  Future<bool> requestPermissions() async {
      //uniquement android
      //Demande des permissions d'accès aux données de santé et d'activité physique
      if (Platform.isAndroid) {
        PermissionStatus activityStatus = await Permission.activityRecognition.request();      
        if (activityStatus.isGranted ){
            return true;
        } else {
          return false;
        }
      }
      else{
        return true;
      }
  }
  
  requestAuthorization() async {

    List<HealthDataType> types = [];
    if(Platform.isIOS){
        types = [
          HealthDataType.STEPS,
          HealthDataType.ACTIVE_ENERGY_BURNED,
          HealthDataType.DISTANCE_WALKING_RUNNING
        ];
    }
    else if (Platform.isAndroid) {
        types = [
          HealthDataType.STEPS,
          HealthDataType.ACTIVE_ENERGY_BURNED,
          HealthDataType.DISTANCE_DELTA
        ];
    }
  
    try {
      // Demander les permissions pour Android
      bool permissionsGranted = await requestPermissions();
      if (!permissionsGranted) {
        isAuthorized = false;
      }
      bool requested = await Health().requestAuthorization(types);

      if (requested){
        isAuthorized = true;
      }
      else{
        isAuthorized = false;
      }
    } catch (e) {
      isAuthorized = false;
    }
  }


  Future<int?> getSteps(DateTime startDate, DateTime endDate) async {
    if (!isAuthorized) {
      return null;
    }

    List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
      types: [HealthDataType.STEPS],
      endTime: endDate,
      startTime: startDate
    );
    int totalSteps = 0;

    // Accéder aux valeurs de pas et les additionner
    for (int i = 0; i < healthData.length; i++) {
      var point = healthData[i];
      if (point.type == HealthDataType.STEPS) {
        NumericHealthValue numericValue = point.value as NumericHealthValue;
        totalSteps += numericValue.numericValue.round();// Les valeurs sont généralement des doubles, donc on les arrondit
      }
    }

    return totalSteps;
  }


  Future<double?> getCaloriesBurned(DateTime startDate, DateTime endDate) async {
    if (!isAuthorized) {
      return null;
    }

    List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
      types: [HealthDataType.ACTIVE_ENERGY_BURNED],
      endTime: endDate,
      startTime: startDate
    );
    double totalCalories = 0;
    //healthData = HealthFactory().removeDuplicates(healthData);
    for (int i = 0; i < healthData.length; i++) {
      var point = healthData[i];
      if (point.type == HealthDataType.ACTIVE_ENERGY_BURNED) {
        
        NumericHealthValue numericValue = point.value as NumericHealthValue;
 
        totalCalories += numericValue.numericValue;
      }
    }
    return totalCalories;
  }

 

  Future<double?> getDistance(DateTime startDate, DateTime endDate) async {

    HealthDataType type = HealthDataType.DISTANCE_WALKING_RUNNING; //initialize with ios value
    if (!isAuthorized) {
      return null;
    }

    if (Platform.isAndroid) {
        type = HealthDataType.DISTANCE_DELTA;
    }
    List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
      types: [type],      
      endTime: endDate,
      startTime: startDate
    );
    //healthData = HealthFactory.removeDuplicates(healthData);

    double totalDistance = 0;

    for (int i = 0; i < healthData.length; i++) {
      var point = healthData[i];
      if (point.type == type) {
        

        NumericHealthValue numericValue = point.value as NumericHealthValue;
 
        totalDistance += numericValue.numericValue;
      }
    }
    
    return totalDistance;
  
  }


}
