import 'package:flutter/material.dart';
import 'package:molibi_app/themes/theme_molibi.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MolibiSearch extends StatefulWidget {
  final Function(String ) searchHandler;

  const MolibiSearch({
    super.key,
    required this.searchHandler,
  });


  @override
  State<MolibiSearch> createState() => _MolibiSearchState();
}

class _MolibiSearchState extends State<MolibiSearch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MolibiThemeData.molibiGreen2, 
      child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left:10.0,top:10.0, right:10.0, bottom:10.0), // Ajoutez ici vos marges
                child: TextFormField(
                    obscureText: false,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left:10.0,top:10.0, right:10.0, bottom:10.0), // Adjust the vertical padding here      
                      enabledBorder:const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: MolibiThemeData.molibiGreen1, width: 2),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: MolibiThemeData.molibiGreen1, width: 2),
                      ),
                      labelText: AppLocalizations.of(context)!.search,
                      labelStyle: const TextStyle(
                        color: MolibiThemeData.molibiGrey2
                        // Couleur de fond du label
                      ),
                      filled: true,
                      fillColor: MolibiThemeData.molibilight,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      floatingLabelAlignment: FloatingLabelAlignment.start,         
                    ),                    
                    onChanged: (value) {
                      String searchQuery = "";
                      setState(() {
                        searchQuery = value;
                      });
                      widget.searchHandler(searchQuery);
                    },
                    onSaved: (value) {
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.search_error;
                      }
                      return null;
                    }
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right:10.0),
              child: 
                IconButton(
                  icon: const Icon(Icons.search_rounded),
                  tooltip: AppLocalizations.of(context)!.search,
                  onPressed: () {},
                  iconSize: 35.0,
                  color: MolibiThemeData.molibilight,
                ),
            ),
          ],
        ),
    );
  }
}