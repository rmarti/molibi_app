import 'package:flutter/material.dart';
import 'package:molibi_app/widget/molibi_exercice_create.dart';


class NewActivityPage extends StatefulWidget {
  const NewActivityPage({super.key});

  @override
  State<NewActivityPage> createState() => NewActivityPageState();
}

class NewActivityPageState extends State<NewActivityPage> {


  @override
  Widget build(BuildContext context) {


    return const Scaffold(
      body: MolibiExerciceCreate()
    );
  }
}



