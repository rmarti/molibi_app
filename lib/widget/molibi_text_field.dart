import 'package:flutter/material.dart';
import 'package:molibi_app/themes/theme_molibi.dart';

class MolibiTextField extends StatefulWidget {

  final bool obscureText; 
  final String? content;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;

 const MolibiTextField({
    super.key,
    this.obscureText = false,
    this.content="", 
    this.onSaved,
    this.validator,
  });

  @override
  State<MolibiTextField> createState() => _MolibiTextFieldState();
}

class _MolibiTextFieldState extends State<MolibiTextField> {
  
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textController.text = widget.content!;
  }

  @override
  void didUpdateWidget(MolibiTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.content != widget.content) {
      textController.text = widget.content!;
    }
  }

  @override
  Widget build(BuildContext context) {

    return TextFormField(
      onChanged: widget.onSaved,
      controller: textController,
      obscureText: widget.obscureText,
      style: const TextStyle(
        color: MolibiThemeData.molibiGrey3,
        fontSize: 12.0, 
        fontFamily: 'Roboto-lightvr',
      ),
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
        enabledBorder:UnderlineInputBorder(
          borderSide: BorderSide(color: MolibiThemeData.molibiGrey3, width: 1),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: MolibiThemeData.molibiGrey3, width: 1),
        ),
        filled: true, 
        fillColor: MolibiThemeData.molibilight,
        isDense: true,                                
      ),
      validator: widget.validator,
    );
  }
}


