import 'package:flutter/material.dart';
import 'package:molibi_app/notifiers/exercice_view_model.dart';
import 'package:molibi_app/widget/molibi_exercice.dart';
import 'package:molibi_app/widget/molibi_exercice_camera.dart';
import 'package:provider/provider.dart';


class NewActivityPage extends StatefulWidget {
  const NewActivityPage({super.key});

  @override
  State<NewActivityPage> createState() => NewActivityPageState();
}

class NewActivityPageState extends State<NewActivityPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ExerciceViewModel>(
        builder: (context, model, _) {      
           return ValueListenableBuilder<String>(
              valueListenable: model.sport,
              builder: (context, dropDownValue, child) {
                return  
                  model.sport.value == 'fitness'
                      ? MolibiExerciceCamera()
                      : MolibiExercice();
              }
           );         
        }
      ),
    );      
  }
}



