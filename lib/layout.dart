import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:molibi_app/challenge_list_page.dart';
import 'package:molibi_app/group_list_page.dart';
import 'package:molibi_app/home_page.dart';
import 'package:molibi_app/map_page.dart';
import 'package:molibi_app/new_activity_page.dart';
import 'package:molibi_app/notifiers/notification_notifier.dart';
import 'package:molibi_app/widget/molibi_bottom_bar.dart';
import 'package:molibi_app/widget/molibi_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';


class LayoutPage extends StatefulWidget {
  final int selectedIndex;
  const LayoutPage(
    {
      super.key,
      this.selectedIndex = 0,
    }
  );

  @override
  State<LayoutPage> createState() => LayoutPageState();
}

class LayoutPageState extends State<LayoutPage> {

  int selectedIndex = 0;

  List<Widget?> pageOptions = List<Widget?>.filled(5, null);

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 5:
        return const GrouplistePage();
      case 1:
        return const NewActivityPage();
      case 2:
        return const MapPage();
      case 3:
        return const ChallengelistePage();
      default:
        return const HomePage(); 
    }
  }


  
  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
    pageOptions[selectedIndex] = _buildPage(selectedIndex);
  } 

  void handlerItemTapBottomBar(int index) {
      setState(() {
        selectedIndex = index;
        if (pageOptions[index] == null) {
          pageOptions[index] = _buildPage(index);
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
    ));

    List<String> pageTitle = <String>[
      AppLocalizations.of(context)!.title_home,
      AppLocalizations.of(context)!.title_new_activity,
      AppLocalizations.of(context)!.title_map,
      AppLocalizations.of(context)!.title_challenge,
      AppLocalizations.of(context)!.title_groups,
    ];

    return Consumer<NotificationNotifier>(
        builder: (context, notificationNotifier, child) {          
          return Scaffold(
            appBar: MolibiAppBar(title:pageTitle[selectedIndex]),
            body: IndexedStack(
              index: selectedIndex,
              children: pageOptions.map((page) => page ?? Container()).toList(),
            ),
            bottomNavigationBar: MolibiBottomBar(
                selectedIndex: selectedIndex,
                onItemTapped: handlerItemTapBottomBar,
              ),
          );
        }
    );

  

  }
}





