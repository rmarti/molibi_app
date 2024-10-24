import 'package:flutter/material.dart';
import 'package:molibi_app/themes/theme_molibi.dart';

class MolibiTextarea extends StatelessWidget {

  final String label;


  const MolibiTextarea({
    super.key,
    required this.label
  });

  @override
  Widget build(BuildContext context) {
    return const Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            child: TextField(
              style: TextStyle(
                color: MolibiThemeData.molibiGrey3,
                fontSize: 12.0, 
                fontFamily: 'Roboto-lightvr',
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,    
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
                  enabledBorder:UnderlineInputBorder(
                    borderSide: BorderSide(color: MolibiThemeData.molibiGrey3, width: 1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: MolibiThemeData.molibiGrey3, width: 1),
                  ),                                                                  
                )
            ),
          ),
        );
  }
}


