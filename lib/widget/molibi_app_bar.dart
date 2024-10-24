
import 'package:flutter/material.dart';
import 'package:molibi_app/themes/theme_molibi.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:molibi_app/notifiers/connected_user_view_model.dart';
import 'package:molibi_app/widget/molibi_header_menu.dart';
import 'package:provider/provider.dart';


class MolibiAppBar extends StatelessWidget implements PreferredSizeWidget {

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  final String title;
  final bool displayBack;
  


  const MolibiAppBar({
    super.key,
    required this.title,
    this.displayBack=false,
  });



  @override
  Widget build(BuildContext context) {

    return Consumer<ConnectedUserViewModel>(
      builder: (context, viewModel, child) {    
        return SafeArea(
          child:
            AppBar(
              automaticallyImplyLeading: displayBack,
              elevation: 0,
              title: Text(
                title,
                style: const TextStyle(
                  color: MolibiThemeData.molibiGreen1, // Change the color here
                )
              ),
              centerTitle: true,
              bottom: 
                  (title == AppLocalizations.of(context)!.title_groups || title == AppLocalizations.of(context)!.title_challenge)
                  ? PreferredSize(
                      preferredSize: const Size.fromHeight(1.0),
                      child: Container(
                        height: 0.0,
                      ),
                    )
                  : PreferredSize(
                      preferredSize: const Size.fromHeight(1.0),
                      child: Container(
                        color: MolibiThemeData.molibiGreen1,
                        height: 1.0,
                      ),
                    ),
              actions: [
                MolibiHeaderMenu(context: context, viewModel: viewModel),
              ],
            ),
        );
      }
    );
    
  }
}
