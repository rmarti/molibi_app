import 'package:flutter/material.dart';
import 'package:molibi_app/themes/theme_molibi.dart';

class MolibiLabel extends StatelessWidget {

  final String label;


  const MolibiLabel({
    super.key,
    required this.label
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
            text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(
                    text: label, 
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0, // Increase the font size here
                      color: MolibiThemeData.molibiGrey2, // Change the color to white here
                      fontFamily: 'Roboto-light',
                      decoration: TextDecoration.none
                      )
                    ),
                ],
              )
          );
  }
}


