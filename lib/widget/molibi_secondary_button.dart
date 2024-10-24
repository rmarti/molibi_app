import 'package:flutter/material.dart';
import 'package:molibi_app/themes/theme_molibi.dart';

class MolibiSecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color pressedBackgroundColor;
  final double fontSize;

  const MolibiSecondaryButton({super.key, 
    required this.label,
    required this.onPressed,
    this.backgroundColor = MolibiThemeData.molibiGreen4,
    this.pressedBackgroundColor = MolibiThemeData.molibiGreen1,
    this.fontSize = 21,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      
      onPressed: onPressed,
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(10),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),             
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12), 
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return pressedBackgroundColor; // Color when button is pressed
          }
          return backgroundColor; // Default color
          },
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return backgroundColor; // Color when button is pressed
          }
          return pressedBackgroundColor; // Default color
          }
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold, 
          fontSize: fontSize,
          fontFamily: 'Roboto-black',
        ),
    ),
    );
  }
}
