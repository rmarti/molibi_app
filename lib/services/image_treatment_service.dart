import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'dart:typed_data';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';



class ImageData {
  final Uint8List input;
  final double width;
  final double height;

  ImageData(this.input, this.width, this.height);
}


class ImageTreatmentService {


  /*
    void saveImage(img.Image image, String fileName) async {
      List<int> encodedImage = img.encodePng(image);
      Directory? downloadsDirectory = await getDownloadsDirectory();
      String filePath = '${downloadsDirectory?.path}/$fileName';
      File file = File(filePath);
      await file.writeAsBytes(encodedImage);

      // Open the saved file using the open_file package
      OpenFile.open(filePath);
    }

  Future<void> saveImage(Uint8List imageData) async {
    final img.Image image = img.Image.fromBytes(width: 256, height: 256, bytes: imageData.buffer);

    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = '${directory.path}/processed_image.png';


    // Encode l'image en PNG
    final Uint8List pngData = Uint8List.fromList(img.encodePng(image));
    final File file = File(path);

    // Sauvegarde l'image
    await file.writeAsBytes(pngData);
    //print('Image enregistrée : $path');
    await OpenFile.open(path);
  }
  */




  Future<void> saveImage2(CameraImage cameraImage) async {
    final int width = cameraImage.width;
    final int height = cameraImage.height;

    // Étape 1 : Convertir YUV420 en RGB
    final Uint8List rgbBytes = _convertYUV420ToRGB(cameraImage);

    // Étape 2 : Créer une image img.Image
    final img.Image image = img.Image.fromBytes(width: width, height: height, bytes: rgbBytes.buffer);

    // Étape 3 : Sauvegarder l'image
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = '${directory.path}/processed_image.png';

    debugPrint("Enregistrement à : $path");

    // Encode en PNG
    final Uint8List pngData = Uint8List.fromList(img.encodePng(image));
    final File file = File(path);

    // Écrit l'image dans un fichier
    await file.writeAsBytes(pngData);
    await OpenFile.open(path);
  }

    // Fonction pour convertir YUV420 en RGB
    Uint8List _convertYUV420ToRGB(CameraImage cameraImage) {
      final int width = cameraImage.width;
      final int height = cameraImage.height;

      final Plane yPlane = cameraImage.planes[0];
      final Plane uPlane = cameraImage.planes[1];
      final Plane vPlane = cameraImage.planes[2];

      final int yRowStride = yPlane.bytesPerRow;
      final int uvRowStride = uPlane.bytesPerRow;
      final int uvPixelStride = uPlane.bytesPerPixel!;

      final Uint8List rgbBytes = Uint8List(width * height * 3);

      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          final int yIndex = y * yRowStride + x;

          final int uvIndex = ((y ~/ 2) * uvRowStride) + ((x ~/ 2) * uvPixelStride);
          final int yValue = yPlane.bytes[yIndex];
          final int uValue = uPlane.bytes[uvIndex];
          final int vValue = vPlane.bytes[uvIndex];

          final int r = (yValue + 1.403 * (vValue - 128)).clamp(0, 255).toInt();
          final int g = (yValue - 0.344 * (uValue - 128) - 0.714 * (vValue - 128)).clamp(0, 255).toInt();
          final int b = (yValue + 1.770 * (uValue - 128)).clamp(0, 255).toInt();

          final int rgbIndex = (y * width + x) * 3;
          rgbBytes[rgbIndex] = r;
          rgbBytes[rgbIndex + 1] = g;
          rgbBytes[rgbIndex + 2] = b;
        }
      }

      return rgbBytes;
    }

    ImageData preprocess(CameraImage cameraImage, int rotationDegrees) {

      // Récupérer les dimensions et les données brutes
      final int width = cameraImage.width;
      final int height = cameraImage.height;
      final Uint8List yuvBytes = _convertYUV420ToRGB(cameraImage);

      // Créer une image à partir des données brutes
      final img.Image originalImage = img.Image.fromBytes(
        width: width,
        height: height,
        bytes: yuvBytes.buffer,
      );


      // Appliquer la rotation
      final img.Image rotatedImage;
      switch (rotationDegrees) {
        case 90:
          rotatedImage = img.copyRotate(originalImage, angle: 90);
          break;
        case 180:
          rotatedImage = img.copyRotate(originalImage, angle: 180);
          break;
        case 270:
          rotatedImage = img.copyRotate(originalImage, angle: -90);
          break;
        default:
          throw ArgumentError("Rotation invalide : $rotationDegrees");
      }




      final aspectRatio = rotatedImage.width / rotatedImage.height;

      //L'image doit faire 256*256
      //le ratio etant different (4:3 contre 1:1 par ex) on met le plus grand cote a 256
      //on genere ensuite une image de 256*256 et on colle en haut à gauche l'image redimensionné.
      //on a ainsi une image au bonne dimension complete par du noir en bas ou a droite pour atteindre 256*256
      final img.Image resizedImage ;
      if (aspectRatio < 1) {
          //width<height
          resizedImage = img.copyResize(rotatedImage, height: 256);
      } else {
          //width>height
          resizedImage = img.copyResize(rotatedImage, width: 256);
      }


      final modelImage = img.Image(
        width: 256,
        height: 256
      );
      img.fill(modelImage, color: img.ColorRgb8(255, 0, 0));

      img.compositeImage(
        modelImage,
        resizedImage,
        dstX: 0,
        dstY: 0,
      );

      
      final Uint8List input = Uint8List(256 * 256 * 3);
      int bufferIndex = 0;
      for (int y = 0; y < 256; y++) {
        for (int x = 0; x < 256; x++) {
          final pixel = modelImage.getPixel(x, y);
          input[bufferIndex++] = pixel.r.toInt();
          input[bufferIndex++] = pixel.g.toInt();
          input[bufferIndex++] = pixel.b.toInt() ;
        }
      }
      
      return ImageData(input,resizedImage.width.toDouble(),resizedImage.height.toDouble());


    }
}
