import 'package:flutter/material.dart';
import 'package:molibi_app/themes/theme_molibi.dart';

class MolibiPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color pressedBackgroundColor;
  final double fontSize;

  const MolibiPrimaryButton({super.key, 
    required this.label,
    required this.onPressed,
    this.backgroundColor = MolibiThemeData.molibiGreen4,
    this.pressedBackgroundColor = MolibiThemeData.molibiGreen2,
    this.fontSize = 21,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
          onPressed: onPressed,
          style: ButtonStyle(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),             
                ),
              ),
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 16), 
              ),
              backgroundColor: WidgetStateProperty.all(
                MolibiThemeData.molibiGreen2
              ),
              overlayColor: WidgetStateProperty.all(
                MolibiThemeData.molibiGreen1,
              ),
              foregroundColor: WidgetStateProperty.all(
                MolibiThemeData.molibiGrey4
              ),
            ),
            child:Text (label,
            style: const TextStyle(
               fontWeight: FontWeight.bold
              )
            )
          );
  }
}
