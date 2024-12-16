import 'dart:math';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:molibi_app/constants/sport_type.dart';
import 'package:molibi_app/notifiers/exercice_view_model.dart';
import 'package:molibi_app/themes/theme_molibi.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MolibiDropDown extends StatefulWidget {

  final ExerciceViewModel model;

  const MolibiDropDown({super.key, required this.model});

  @override
  MolibiDropDownState createState() => MolibiDropDownState();
  
}

class MolibiDropDownState extends State<MolibiDropDown> {

  final List<String> items = AppSportType.getSportTypes();
  List<String> itemsName=[];
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    if (items.isNotEmpty) {
      selectedValue = items.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    itemsName = AppSportType.getSportTypesName(context);
    return DropdownButtonHideUnderline(
      child: IntrinsicWidth(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Row(
            children: [
              const SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.create_exercice_select_item,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: MolibiThemeData.molibiGrey4,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          items: items
              .map((String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: MolibiThemeData.molibiGrey4,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          value: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value;
              widget.model.sport.value = value!;
              debugPrint("value : $value");
            });
          },
          buttonStyleData: ButtonStyleData(
            height: 50,
            //width: 120,
            padding: const EdgeInsets.only(left: 14, right: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: MolibiThemeData.molibiGreen1,
              ),
              color: MolibiThemeData.molibiGreen2,
            ),
            elevation: 2,
          ),
          iconStyleData: IconStyleData(
            icon: Transform.rotate(
              angle: 90 * pi / 180, // Rotate 90 degrees
              child: const Icon(
                Icons.arrow_right_outlined,
              ),
            ),
            iconSize: 34,
            iconEnabledColor: MolibiThemeData.molibiGreen1,
            iconDisabledColor: MolibiThemeData.molibiGreen1,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            //width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: MolibiThemeData.molibiGreen2,
            ),
            //offset: const Offset(-20, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: WidgetStateProperty.all(6),
              thumbVisibility: WidgetStateProperty.all(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.only(left: 14, right: 14),
          ),
        ),
      ),
    );    
  }
}