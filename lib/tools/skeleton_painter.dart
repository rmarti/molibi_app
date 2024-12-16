import 'package:flutter/material.dart';
import 'package:camera/camera.dart';


class SkeletonPainter extends CustomPainter {
  late List<List<double>> keypoints;
  late final CameraController _controller;
  late final double _screenWidth;
  late final double _screenHeight;
  late double _videoWidth;
  late double _videoHeight;
  double photoResizedWidth=0;
  double photoResizedHeight=0;

  late bool isPortrait;

  //ne pas oublier que la photo et la video n'ont pas la meme taille. ON a donc la taille de la photo, la taille de l'image redimensionné, la taille de la camera et la taille de l'affichage
  SkeletonPainter(this.keypoints, this.photoResizedWidth, this.photoResizedHeight, this._controller, this.isPortrait, this._screenWidth, this._screenHeight){

    //on défini la vrai taille de la camera. L'espace alloué peu ne pas etre entierement occupé a cause de la qualité choisi
    double  cameraWidth=_controller.value.previewSize!.shortestSide;
    double  cameraHeight=_controller.value.previewSize!.longestSide;    
    if (isPortrait){

      if(photoResizedHeight<photoResizedWidth){
        double tmp = photoResizedHeight;
        photoResizedHeight = photoResizedWidth;
        photoResizedWidth = tmp;
      }

      // adapté a la largeur de l'ecran
      _videoWidth = _screenWidth;
      _videoHeight = cameraHeight*(_screenWidth/cameraWidth);
     
    }
    else{
      _videoWidth = _screenWidth;
      _videoHeight = _screenHeight;
    }
    


    keypoints=keypoints;




  }

  @override
  void paint(Canvas canvas, Size size) {

    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4.0;
    final paint2 = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4.0;


    final paint3 = Paint()
      ..color = Colors.green
      ..strokeWidth = 4.0;
/*
["nose","left eye","right eye","left ear","right ear","left shoulder","right shoulder","left elbow","right elbow",
"left wrist","right wrist","left hip","right hip","left knee","right knee","left ankle","right ankle"]   
*/
   


    drawSegment(canvas, paint, 5, 7);
    drawSegment(canvas, paint, 7, 9); 

    drawSegment(canvas, paint, 6, 8);
    drawSegment(canvas, paint, 8, 10); 

    drawSegment(canvas, paint2, 12, 14);
    drawSegment(canvas, paint2, 14, 16); 

    drawSegment(canvas, paint2, 11, 13);
    drawSegment(canvas, paint2, 13, 15); 



   
    drawRect(canvas, paint3, 1);
    drawRect(canvas, paint3, 2);
    drawRect(canvas, paint3, 5);
    drawRect(canvas, paint3, 6);
    drawRect(canvas, paint3, 7);
    drawRect(canvas, paint3, 8);
    drawRect(canvas, paint3, 9);
    drawRect(canvas, paint3, 10);
    drawRect(canvas, paint3, 11);
    drawRect(canvas, paint3, 12);
    drawRect(canvas, paint3, 13);
    drawRect(canvas, paint3, 14);
    drawRect(canvas, paint3, 15);
    drawRect(canvas, paint3, 16);

  }


  void drawRect(Canvas canvas, Paint paint, int point){
    final offset = convertCoordinates(keypoints[point][0],keypoints[point][1]);
    final rect = Rect.fromCenter(center: offset, height: 20, width: 20);
    canvas.drawRect(rect, paint);
  }

  void drawSegment(Canvas canvas, Paint paint, int startIdx, int endIdx) {

    final start =convertCoordinates(keypoints[startIdx][0],keypoints[startIdx][1]);
    final end = convertCoordinates(keypoints[endIdx][0], keypoints[endIdx][1]);

    canvas.drawLine(start, end, paint);
  }



  Offset convertCoordinates(
    double xNormalise,
    double yNormalise,
  ) {

    double xFinal=0;
    double yFinal=0;
    double scaleX=_videoWidth/photoResizedWidth;
    double scaleY=_videoHeight/photoResizedHeight;

    double realX = 0;
    double realY = 0;

    // En mode portrait avec la caméra frontale
    // on gere l'effet miroir et le probleme de rotation puisque le capteur est en mode paysage
    if (isPortrait) {
      // 1. Rotation de 90 degrés
      double temp = xNormalise;
      xNormalise = yNormalise;
      yNormalise = temp;

      //on ajuste le x et le y normalisé en fonction de la taille de la photo. Ils ont été calculé par le modele sur la base d'une image de 256*256
      //pourtant le "vrai" contenu fait 256 de hauteur (en mode portrait) mais moins en largeur.    
      double xTemp = xNormalise*256;
      xFinal = xTemp / photoResizedWidth;
      yFinal = yNormalise;
      // on ajuste le x et let y en fonction de la resoluion de l'affichage (peut etre different de l'ecran)
      realX = xFinal * photoResizedWidth * scaleX;
      realY = yFinal * photoResizedHeight * scaleY;  
      
    } 

    
    return Offset(realX, realY);
  }



  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}