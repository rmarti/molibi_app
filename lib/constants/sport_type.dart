import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class AppSportType {
  static const String cycling = "cycling";
  static const String running = "running";
  static const String walking = "walking";
  static const String bodybuilding = "bodybuilding";

  static List<String> getSportTypes(){
    return [cycling, running, walking, bodybuilding];
  }

  static List<String> getSportTypesName(BuildContext context){
    return [AppLocalizations.of(context)!.sport_type_cycling, AppLocalizations.of(context)!.sport_type_running, AppLocalizations.of(context)!.sport_type_walking, AppLocalizations.of(context)!.sport_type_bodybuilding];
  }

  static IconData getIconForSportType(sport){
    switch(sport){
      case AppSportType.cycling:
        return Icons.directions_bike;
      case AppSportType.running:
        return Icons.directions_run;
      case AppSportType.walking:
        return Icons.directions_walk;
      case AppSportType.bodybuilding:
        return Icons.fitness_center;
      default:
        return Icons.favorite_border;
    }
  }

}