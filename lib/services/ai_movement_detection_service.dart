import 'package:tflite_flutter/tflite_flutter.dart';


class AiMovementDetectionService {


  late Interpreter interpreter;

  Future<void> loadModel() async {
    //be carefull of size of image if change
    await loadMovenet();
  }

  Future<void> loadMovenet() async {
    interpreter = await Interpreter.fromAsset('assets/models/movenet-tflite-singlepose-thunder-tflite-float16-v1.tflite');
  }

}
