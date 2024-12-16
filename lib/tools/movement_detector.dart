import 'dart:math';

import 'package:flutter/material.dart';

abstract class MovementDetector {
  int detect(BuildContext context,List<List<List<double>>> keypoints);
}

class SquatDetector extends MovementDetector {


  @override
  int detect(BuildContext context,List<List<List<double>>> keypoints) {


    if (keypoints.length < 4) return 0; 


      bool isUp = false;
      bool isUp2 = false;
      bool isDown = false;
      double yNoseUp=0;
      double noise=0;


      //pour défini de façon simple un squatt, les 2 points des hanches sont alignés horizontalement et descendent puis remontent
      // les genoux sont alignés horizontalement
      double angleCurrent = calculateAngle(keypoints[0][12], keypoints[0][14], keypoints[0][16]);
      double anglePrev1 = 0;

      for (int i = 1; i < keypoints.length; i++) {
          
         anglePrev1 = angleCurrent;
         angleCurrent = calculateAngle(keypoints[i][12], keypoints[i][14], keypoints[i][16]);

            if ( anglePrev1>172 && angleCurrent>172){
              if ( anglePrev1>175 || angleCurrent>175){
                isUp = true;
                yNoseUp=keypoints[i][0][1];
                noise=yNoseUp/200;
              }
            }
            else if (isUp && anglePrev1>70 && anglePrev1 <170 && angleCurrent>70 && angleCurrent <170){
                //les 2 sont inferieur à 170 et au moins 1 est inf a 160
                double diffY = yNoseUp-keypoints[i][0][1]-noise;
                if (diffY>0 && ( anglePrev1<160 || angleCurrent<160)){
                  isDown = true;
                }
            }
            else if (isUp && ((anglePrev1>70 && anglePrev1 <150) || (angleCurrent>70 && angleCurrent <150))){
                //on a pas la descente et la remotné mais le point bas uniquement
                double diffY = yNoseUp-keypoints[i][0][1]-noise;
                if (diffY>0){
                  isDown = true;
                }
            }
            if (isDown && anglePrev1>172 && angleCurrent>172){
              if ( anglePrev1>175 || angleCurrent>175){
                isUp2 = true;
              }
            }

            if (isUp && isDown && isUp2) {
              // Réinitialiser pour détecter d'autres squats
              isUp = false;
              isUp2 = false;
              isDown = false;
              return i; // Squat détecté
            }

      }

      return 0; // Pas de squat détecté
  }

  double calculateAngle(List<double> p1, List<double> p2, List<double> p3) {
    // Vecteur entre p2 et p1
    final v1x = p1[0] - p2[0];
    final v1y = p1[1] - p2[1];

    // Vecteur entre p2 et p3
    final v2x = p3[0] - p2[0];
    final v2y = p3[1] - p2[1];

    // Produit scalaire des vecteurs
    final dotProduct = v1x * v2x + v1y * v2y;

    // Magnitudes des vecteurs
    final magnitudeV1 = sqrt(v1x * v1x + v1y * v1y);
    final magnitudeV2 = sqrt(v2x * v2x + v2y * v2y);

    // Calcul du cosinus de l'angle
    final cosTheta = dotProduct / (magnitudeV1 * magnitudeV2);

    // Limitation pour éviter des erreurs dues à des imprécisions
    final clampedCosTheta = cosTheta.clamp(-1.0, 1.0);

    // Calcul de l'angle en radians
    final angleRadians = acos(clampedCosTheta);

    // Conversion en degrés
    return angleRadians * (180 / pi);
  }
}

class PushUpDetector extends MovementDetector {
  @override
  int detect(BuildContext context,List<List<List<double>>> keypoints) {
    // Logique du push-up
    // Retourne true si un push-up est détecté
    return 0;
  }
}
