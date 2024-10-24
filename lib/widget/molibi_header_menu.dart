
import 'package:flutter/material.dart';
import 'package:molibi_app/login_page.dart';
import 'package:molibi_app/profil_page.dart';
import 'package:molibi_app/tools/token_storage.dart';
import 'package:molibi_app/notifiers/connected_user_view_model.dart';
import 'package:molibi_app/themes/theme_molibi.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


enum SampleItem { profil, logout }

class MolibiHeaderMenu extends StatelessWidget {
  const MolibiHeaderMenu({
    super.key,
    required this.context,
    required this.viewModel,
  });

  final BuildContext context;
  final ConnectedUserViewModel viewModel;

  @override
  Widget build(BuildContext context) {

    return PopupMenuButton<SampleItem>(
                offset: const Offset(0, 45),
                onSelected: (SampleItem item) async {
                    if (item == SampleItem.logout) {
                      await TokenStorage().deleteToken().then((response) async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      });
                    }
                    else if (item == SampleItem.profil) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilPage(connectedUserViewModel:viewModel)),
                      );
                    }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
                   PopupMenuItem<SampleItem>(
                    value: SampleItem.profil,
                    child: Text(AppLocalizations.of(context)!.menu_profile),
                  ),
                   PopupMenuItem<SampleItem>(
                    value: SampleItem.logout,
                    child: Text(AppLocalizations.of(context)!.menu_logout),
                  ),
                ],
                child:Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: MolibiThemeData.molibiGreen1, // Set the border color
                          width: 2.0, // Set the border width
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: MolibiThemeData.molibilight, // Set the border color
                            width: 2.0, // Set the border width
                          ),
                          borderRadius: BorderRadius.circular(50.0),
                      ),
                      
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),                                  
                        child: SizedBox(
                          width: 35.0,
                          height: 35.0,
                          child: Image.network(
//ToDo mettre l'icone en config
                            viewModel.user != null ? viewModel.user!.profilePicture : "https://media.licdn.com/dms/image/v2/D4D03AQEH6yqjmpWAoQ/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1720369795476?e=1730937600&v=beta&t=ZoD59r58Zgg4A1hAFiagaR6S2hO6xelsJloCJiuYCiw",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              );
  }
}