import 'package:flutter/material.dart';
import 'package:molibi_app/themes/theme_molibi.dart';

class MolibiTextFieldComplet extends StatefulWidget {

  final String label;
  final bool obscureText; 
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const MolibiTextFieldComplet({
    super.key,
    required this.label,
    this.obscureText = false,
    this.onSaved,
    this.controller,
    this.validator,
  });

  @override
  State<MolibiTextFieldComplet> createState() => _MolibiTextFieldCompletState();
}

class _MolibiTextFieldCompletState extends State<MolibiTextFieldComplet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:40.0,top:10.0, right:40.0, bottom:10.0), // Ajoutez ici vos marges
      child: TextFormField(
          obscureText: widget.obscureText,
          controller: widget.controller,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left:10.0,top:10.0, right:10.0, bottom:10.0), // Adjust the vertical padding here      
            enabledBorder:const UnderlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: MolibiThemeData.molibiGrey4, width: 2),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: MolibiThemeData.molibiGrey4, width: 2),
            ),
            labelText: widget.label,
            labelStyle: const TextStyle(
              color: MolibiThemeData.molibiGrey1
              // Couleur de fond du label
            ),
            filled: true,
            fillColor: MolibiThemeData.molibilight,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            floatingLabelAlignment: FloatingLabelAlignment.start,         
          ),
          validator: widget.validator,
          onSaved: widget.onSaved
      )
    );
  }
}


