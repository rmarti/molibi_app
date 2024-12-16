import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:molibi_app/services/ai_movement_detection_service.dart';
import 'package:molibi_app/services/image_treatment_service.dart';
import 'package:molibi_app/notifiers/exercice_view_model.dart';
import 'package:molibi_app/themes/theme_molibi.dart';
import 'package:provider/provider.dart';

class ActivityCameraPage extends StatefulWidget {
  const ActivityCameraPage({super.key});

  @override
  State<ActivityCameraPage> createState() => _ActivityCameraPageState();
}


class _ActivityCameraPageState extends State<ActivityCameraPage> {
  late CameraController _controller;
  List<List<double>> _keypoints = [];
  List<List<double>> _lastKeypoints = [];
  String _movement = "";
  bool isCapturing = false;
  late Future<void> _initializeControllerFuture= Future.value();
  late AiMovementDetectionService aiService;
  Timer? _timer;
  double distance = 0;


  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();
    _initializeModel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExerciceViewModel>(context, listen: false).startExercice();
    });
  }

  Future<void> _initializeModel() async {
    aiService = AiMovementDetectionService();
    await aiService.loadModel();
    _startImageStream();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      throw CameraException('no_cameras', 'Aucune caméra disponible.');
    }
    final camera = cameras.length > 1 ? cameras[1] : cameras[0];
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
    );
    return _controller.initialize();
   
  }


  void _startImageStream() {
/*
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) async {
      if (!isCapturing && _controller.value.isInitialized) {
        try {
          isCapturing = true;
          //debugPrint("=<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Debut");
          final XFile picture = await _controller.takePicture();       
          _processImage(picture);
          //debugPrint("=<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Fin");
        } catch (e) {
          debugPrint("Erreur de capture d'image : $e");
        }
        finally {
          //debugPrint("=<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Finally");
          isCapturing = false;
        }
      }
    });
  */
  }





  Future<void> _processImage(CameraImage picture) async {

    
    ImageTreatmentService treatment = ImageTreatmentService();
    final output = List.generate(1, (_) => List.generate(1, (_) => List.generate(17, (_) => List.filled(3, 0.0))));      
    ImageData data =treatment.preprocess(picture,90);

    Uint8List input = data.input;


    aiService.interpreter.run(input, output);  
    _keypoints = output[0][0];
    movement();
    //reload display
    setState(() {});
  }

  void movement(){
    double distanceTmp = 0;
    if(_lastKeypoints.isNotEmpty){
      for(int i = 0; i < _keypoints.length; i++){
        distanceTmp += (_keypoints[i][0] - _lastKeypoints[i][0]).abs() + (_keypoints[i][1] - _lastKeypoints[i][1]).abs();
      }
      if(distanceTmp > 1.8){
        distance+=distanceTmp;
        _movement="détecté : $distance";
      }
      else{
        _movement="Pas: $distance";
      }
    }
    _lastKeypoints = _keypoints;
  }

  @override
  void dispose() {
    _timer?.cancel(); 
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

      
    return Consumer<ExerciceViewModel>(
      builder: (context, viewModel, child) {  
        return Scaffold(
          appBar: AppBar(title: Text('Caméra Flutter')),
          body: FutureBuilder<void>(
            future: _initializeControllerFuture ,
            builder: (context, snapshot) {
              if ((snapshot.connectionState == ConnectionState.done) &&  _keypoints.isNotEmpty) {
                return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Stack(
                      children: [
                        CameraPreview(_controller),
                        /*CustomPaint(
                          size: Size(constraints.maxWidth, constraints.maxHeight),
                          painter: SkeletonPainter(_keypoints,_imageWidth,_imageHeight,_controller, (MediaQuery.of(context).orientation == Orientation.portrait),constraints.maxWidth,constraints.maxHeight),
                        ),*/
                        Text(
                          _movement,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 35.0,
                          ),
                        ),
                        Text(
                          '${viewModel.stopwatch.elapsed.inMinutes}:${(viewModel.stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontSize: 40.0,
                            color: MolibiThemeData.molibiGreen2
                          )
                        ),
                      ],
                    );
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        );
      },
    );

    
  }
}





