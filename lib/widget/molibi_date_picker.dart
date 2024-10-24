import 'package:flutter/material.dart';
import 'package:molibi_app/themes/theme_molibi.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MolibiDatePicker extends StatefulWidget {

  final String label;
  
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;

  const MolibiDatePicker({
    super.key,
    required this.label,
    this.onSaved,
    this.validator}
  );


  @override
  MolibiDatePickerState createState() => MolibiDatePickerState();
}

class MolibiDatePickerState extends State<MolibiDatePicker> {
    DateTime? selectedDate;
    final dateController = TextEditingController();


    @override
    void dispose() {
      dateController.dispose();
      super.dispose();
    }

    Future<void> selectDate(BuildContext context) async {

      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(), 
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),         
      );
  
      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = picked;
        });
        dateController.text = '${selectedDate!.toLocal()}'.split(' ')[0];
      }
    }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:40.0,top:10.0, right:40.0, bottom:10.0), // Ajoutez ici vos marges
      child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TextFormField(
                  controller: dateController,
                  obscureText: false,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left:10.0,top:10.0, right:10.0, bottom:10.0), // Adjust the vertical padding here      
                    enabledBorder:const OutlineInputBorder(
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
                ),
              ),
              const SizedBox(width: 10.0),
              ElevatedButton(
                onPressed: () => selectDate(context),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Change the value to your desired radius
                  ),
                  padding:const EdgeInsets.all(15), 
                ),    
                child: SvgPicture.asset(
                      'assets/images/calendar-days-solid.svg',
                      alignment: Alignment.center,
                      fit: BoxFit.fill,
                      height:20,
                      width:20,
                ),
              ),
            ],
          ),
    );
  }
}