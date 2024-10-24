import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:molibi_app/themes/theme_molibi.dart';
import 'package:molibi_app/widget/molibi_drop_down.dart';
import 'package:molibi_app/notifiers/exercice_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'dart:math';

class MolibiExerciceCreate extends StatefulWidget {
  const MolibiExerciceCreate({super.key});

  @override
  State<MolibiExerciceCreate> createState() => MolibiExerciceCreateState();
}

class MolibiExerciceCreateState extends State<MolibiExerciceCreate> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {


    void handleButtonPlayPause(ExerciceViewModel viewModel) {  
      viewModel.startExercice();
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
          return Padding(
            padding: const EdgeInsets.only(
              //left: (MediaQuery.of(context).size.width-300)/2, 
              bottom: 8.0
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 30.0),
                    child: MolibiDropDown(),
                  ),
                  GestureDetector(
                    onTap: () => handleButtonPlayPause(viewModel),
                    child: Container(
                      color:MolibiThemeData.molibilight,
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
                                  Row( 
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right:10.0),
                                        child: Row(                                        
                                          children: [
                                            SvgPicture.asset('assets/images/person-walking-solid.svg',
                                              alignment: Alignment.center,
                                              fit: BoxFit.fill,
                                              height:15,
                                              width:15,
                                              colorFilter: const ColorFilter.mode(MolibiThemeData.molibiGreen2, BlendMode.srcIn),
                                            ),
                                            Text(
                                              '${viewModel.steps}',
                                              style: const TextStyle(
                                                fontSize: 21.0,
                                                color: MolibiThemeData.molibiGreen2
                                              )
                                            ),                                                 
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left:10.0),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset('assets/images/person-walking-solid.svg',
                                              alignment: Alignment.center,
                                              fit: BoxFit.fill,
                                              height:15,
                                              width:15,
                                              colorFilter: const ColorFilter.mode(MolibiThemeData.molibiGreen2, BlendMode.srcIn),
                                            ),
                                            Text(
                                              '${viewModel.steps}',
                                              style: const TextStyle(
                                                fontSize: 21.0,
                                                color: MolibiThemeData.molibiGreen2
                                              )
                                            ),
                                            
                                          ],
                                        ),
                                      )
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
              /*
                    MolibiPrimaryButton(
                      onPressed:() => handleButtonReset(viewModel),
                      label:(AppLocalizations.of(context)!.exercice_reset),
                    ),
              */
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
                                  color: MolibiThemeData.molibiGreen1, // Replace 'yourColor' with the color you want
                                  width: 2.0, // You can adjust the width of the border as needed
                                )
                              )
                            ),
                              padding: WidgetStateProperty.all(const EdgeInsets.all(35)),
                              backgroundColor: WidgetStateProperty.all(MolibiThemeData.molibiGreen2), 
                              overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
                                if (states.contains(WidgetState.pressed)) return MolibiThemeData.molibiGreen1; 
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
              
                ],
              ),
          );  
     },
    );
  }
}


