import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:molibi_app/themes/theme_molibi.dart';

class MolibiBottomBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const MolibiBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<MolibiBottomBar> createState() => MolibiBottomBarState();
}

class MolibiBottomBarState extends State<MolibiBottomBar> {

  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: AppLocalizations.of(context)!.bottom_bar_home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.radio_button_checked ),
          label: AppLocalizations.of(context)!.bottom_bar_activity_add,          
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.map),
          label: AppLocalizations.of(context)!.bottom_bar_map,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.insights),
          label: AppLocalizations.of(context)!.bottom_bar_challenge,
        ),
      ],
      onTap: widget.onItemTapped,
      currentIndex: widget.selectedIndex,
      selectedItemColor: MolibiThemeData.molibiGreen1,
      unselectedItemColor: MolibiThemeData.molibiGrey2,
      showSelectedLabels: true, 
      showUnselectedLabels: true, 
    );
  }
}

