import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:molibi_app/services/ai_movement_detection_service.dart';
import 'package:molibi_app/services/image_treatment_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:molibi_app/themes/theme_molibi.dart';
import 'package:molibi_app/tools/movement_detector.dart';
import 'package:molibi_app/tools/skeleton_painter.dart';
import 'package:molibi_app/widget/molibi_drop_down.dart';
import 'package:molibi_app/notifiers/exercice_view_model.dart';
import 'package:provider/provider.dart';

class MolibiExerciceCamera extends StatefulWidget {

  const MolibiExerciceCamera({super.key});


  @override
  State<MolibiExerciceCamera> createState() => MolibiExerciceCameraState();
}

class MolibiExerciceCameraState extends State<MolibiExerciceCamera> {


  late CameraController _controller;
  List<List<double>> _keypoints = [];
  List<List<List<double>>> keypointsRanges = [];
  bool isCapturing = false;
  late Future<void> _initializeControllerFuture= Future.value();
  final Completer<void> _initializeCompleter = Completer<void>();
  late AiMovementDetectionService aiService;
  double distance = 0;
  double resizedWidth = 0;
  double resizedHeight = 0;
  double renderSizeWidth = 0;
  double renderSizeHeigh = 0;
  bool imageStreamIsActive=false;
  
  final GlobalKey _customPaintKey = GlobalKey();

  @override
  void initState() {

    if (!_initializeCompleter.isCompleted) {
      _initializeControllerFuture = _initializeCamera();
      _initializeCompleter.complete(_initializeCamera());
    }
    super.initState();
    _initializeModel();

  }


  @override
  void dispose() {    
    _stopImageStream();
    _controller.dispose();
    super.dispose();
  }


  Future<void> _initializeModel() async {
    aiService = AiMovementDetectionService();
    await aiService.loadModel();
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

  void _getCustomPaintSize() {
    final RenderBox? renderBox = _customPaintKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final size = renderBox.size;
      renderSizeWidth = size.width;
      renderSizeHeigh = size.height;  
    } 
  }



  Future<void> _processImage(CameraImage image, bool movementToDetect, int rotationDegrees) async {

    
    ImageTreatmentService treatment = ImageTreatmentService();
    final output = List.generate(1, (_) => List.generate(1, (_) => List.generate(17, (_) => List.filled(3, 0.0))));      
    ImageData data = treatment.preprocess(image, rotationDegrees);

    Uint8List input = data.input;
    resizedWidth = data.width;
    resizedHeight = data.height;

    aiService.interpreter.run(input, output);  
    _keypoints = output[0][0];

    //on à 10 captures toutes les 1 sec. On a donc un range de 3secondes
    if (keypointsRanges.length >= 30) {
      keypointsRanges.removeAt(0); // Supprime le premier élément
    }
    keypointsRanges.add(_keypoints);

    if (movementToDetect){
      int detectIndex = movement(keypointsRanges);
      if( detectIndex>0){
debugPrint("squatt ok $detectIndex");
        //on a identifié un mouvement, on efface la plzge de keypoints correspondant. On ne l'efface pas jusqu'au bout. La position haute pouvant etre le debut d'un nouveau squatt
        //le mouvement a été mis à jours ds le modele
        keypointsRanges.removeRange(0, detectIndex-1 );
      }
    }
  }


  int movement( keypointsRanges) {
    SquatDetector squatDetector = SquatDetector();

    int squatIndex = squatDetector.detect(context,keypointsRanges);

    if (squatIndex>0){
      Provider.of<ExerciceViewModel>(context, listen: false).squatCount+=1;      
      return squatIndex;
    }

    return squatIndex;
  }


  void _stopImageStream(){    
    _controller.stopImageStream()
       .then((value) => imageStreamIsActive = false);
  }

  
  void _startImageStream() {
    int captureCount = 0;
    DateTime? lastProcessTime;

    if (!_initializeCompleter.isCompleted) {
      _initializeControllerFuture = _initializeCamera();
    }
    
    _getCustomPaintSize();

    // Lancer le flux une seule fois
    _controller.startImageStream((CameraImage image) async {
      try {
        // Vérifier si le contrôleur est initialisé
        if (!_controller.value.isInitialized) return;

        imageStreamIsActive=true;

        final now = DateTime.now();
        if (lastProcessTime == null || 
          now.difference(lastProcessTime!).inMilliseconds >= 50) {

          // Récupérer l'orientation de la caméra
          final CameraDescription cameraDescription = _controller.description;
          final int orientationDegrees = cameraDescription.sensorOrientation;

          
          // On ne lance pas la recherche à chaque fois
          if (captureCount % 5 == 0) {
            await _processImage(image, true,orientationDegrees);
          } else {
            await _processImage(image, false, orientationDegrees);
          }

          captureCount++;
          
          // Mettre à jour le dernier temps de traitement
          lastProcessTime = now;
        }
      } catch (e) {
        debugPrint("Erreur de capture d'image : $e");
      }
    });
  }





  @override
  Widget build(BuildContext context) { 

    void handleButtonPlayPause(ExerciceViewModel viewModel) {  
        viewModel.startExercice();

        if (imageStreamIsActive){
          _stopImageStream();
        }
        else{
          _startImageStream();
        }

    }
    
    void handleButtonReset(ExerciceViewModel viewModel) {  
      viewModel.resetExercice();      
    }

    List<Widget> buildCircularRectangles(ExerciceViewModel viewModel) {
      double radius = 135; 
      int count = 60;
      double angleStep = (2 * pi) / count; 

      int countLightColor = ((viewModel.stopwatch.elapsed.inSeconds % 60)).round();

      return List.generate(count, (index) {


        double angle = (index-15) * angleStep; // Current angle
        double x = radius * cos(angle);   // X position
        double y = radius * sin(angle);   // Y position

        return Positioned(
          left: x + radius,  // Adjust position
          top: y + radius,
          child: Transform.rotate(
            angle: angle,
            child: Container(
              width: 30,
              height: 5,
              color: index<countLightColor ? MolibiThemeData.molibiGreen2 : MolibiThemeData.molibiGrey3,
            ),
          ),
        );
      });
    }

    return Consumer<ExerciceViewModel>(
      builder: (context, viewModel, child) {          
        return ValueListenableBuilder<String>(
          valueListenable: viewModel.sport,
          builder: (context, dropDownValue, child) {
            return FutureBuilder<void>(
              future: _initializeControllerFuture ,
              builder: (context, snapshot) {
                if ((snapshot.connectionState == ConnectionState.done)) {
                  return LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      return Stack(
                        children: [
                           SizedBox(
                            key: _customPaintKey,
                            width: double.infinity,
                            child: CameraPreview(_controller),
                          ),
                          Visibility(
                            visible: resizedWidth > 0 && resizedHeight > 0 && renderSizeWidth > 0 && renderSizeHeigh > 0,
                            child: CustomPaint(
                              size: Size(constraints.maxWidth, constraints.maxHeight),
                              painter: SkeletonPainter(_keypoints,resizedWidth,resizedHeight,_controller, (MediaQuery.of(context).orientation == Orientation.portrait),renderSizeWidth,renderSizeHeigh),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 30.0),
                                child: MolibiDropDown(model: viewModel), 
                              ),
                              Text(
                                "squat  : ${viewModel.squatCount}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  fontSize: 35.0,
                                  backgroundColor: Colors.yellow,
                                ),
                              ),
                              Text(
                                "squat  : ${viewModel.mouvement}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontSize: 35.0,
                                  backgroundColor: Colors.yellow,
                                ),
                              ),
/*
                              Text(
                                AppLocalizations.of(context)!.exercice_camera_warning,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  fontSize: 35.0,
                                ),
                              ),
  */                            GestureDetector(
                                onTap: () => handleButtonPlayPause(viewModel),
                                child: Container(
                                  //color:MolibiThemeData.molibilight,
                                  color: Colors.transparent,
                                  width : 300,
                                  height : 300,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [                                  
                                          Column(
                                            mainAxisAlignment:MainAxisAlignment.center ,
                                            children: [
                                              Row(
                                                children: [
                                                  viewModel.isRunning? 
                                                  const Icon(
                                                      Icons.pause, 
                                                      size: 50.0,
                                                      color: MolibiThemeData.molibiGreen2
                                                    ): 
                                                  const Icon(
                                                    Icons.play_arrow, 
                                                    size: 50.0,
                                                    color: MolibiThemeData.molibiGreen2
                                                  ),
                                                  Text(
                                                    '${viewModel.stopwatch.elapsed.inMinutes}:${(viewModel.stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}',
                                                    style: const TextStyle(
                                                      fontSize: 40.0,
                                                      color: MolibiThemeData.molibiGreen2
                                                    )
                                                  ),
                                                ],
                                              ),
                                              
                                            ],
                                          ),
                                        ],
                                      ),
                                       ...buildCircularRectangles(viewModel),
                                    ]
                                  ),
                                ),
                              
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top:15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => handleButtonPlayPause(viewModel),
                                      
                                      style: ButtonStyle(
                                        shape: WidgetStateProperty.all(
                                          const CircleBorder(
                                            side: BorderSide(
                                              color: MolibiThemeData.molibiGreen1, // Replace 'yourColor' with the color you want
                                              width: 2.0, // You can adjust the width of the border as needed
                                            )
                                          )
                                        ),
                                        padding: WidgetStateProperty.all(const EdgeInsets.all(35)),
                                        backgroundColor: WidgetStateProperty.all(MolibiThemeData.molibiGreen2), 
                                        overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
                                          if (states.contains(WidgetState.pressed)) return MolibiThemeData.molibiGreen1;
                                          return null; 
                                        }),
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: 
                                          viewModel.isRunning? 
                                          Text(
                                            AppLocalizations.of(context)!.create_exercice_pause,
                                            style:const TextStyle(
                                              color:MolibiThemeData.molibiGrey4,
                                              fontWeight: FontWeight.bold
                                            )
                                          ):
                                          viewModel.notStart?
                                            Text(
                                              AppLocalizations.of(context)!.create_exercice_start,
                                              style:const TextStyle(
                                                color:MolibiThemeData.molibiGrey4,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ):
                                            Text(
                                              AppLocalizations.of(context)!.create_exercice_restart,
                                              style:const TextStyle(
                                                color:MolibiThemeData.molibiGrey4,
                                                fontWeight: FontWeight.bold
                                              ),
                                            )
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => handleButtonReset(viewModel),
                                      child:
                                        !viewModel.isRunning && !viewModel.notStart? 
                                        const Icon(
                                          Icons.refresh, 
                                          size: 50.0,
                                          color: MolibiThemeData.molibiGreen1
                                        ):
                                        Container()
                                    ),
                                    
                                    !viewModel.isRunning && !viewModel.notStart? 
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          shape: WidgetStateProperty.all(
                                          const CircleBorder(
                                            side: BorderSide(
                                              color: MolibiThemeData.molibiGreen1, 
                                              width: 2.0, 
                                            )
                                          )
                                        ),
                                          padding: WidgetStateProperty.all(const EdgeInsets.all(35)),
                                          backgroundColor: WidgetStateProperty.all(MolibiThemeData.molibiGreen2), 
                                          overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
                                            if (states.contains(WidgetState.pressed)) return MolibiThemeData.molibiGreen1;
                                            return null; 
                                          }),
                                        ),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            AppLocalizations.of(context)!.create_exercice_save,
                                            style:const TextStyle(
                                              color:MolibiThemeData.molibiGrey4,
                                              fontWeight: FontWeight.bold
                                            )
                                          )
                                        ),
                                      ):
                                      Container()
                                  ],
                                  
                                ),
                                
                              )
                              /*
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
                              ),*/
                            ],
                          )
                         
                        ],
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            );
          }
        );

          /*
         
  */      
          
          
     },
    );
  }
}

