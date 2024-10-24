import 'package:flutter/material.dart';
import 'package:molibi_app/layout.dart';
import 'package:molibi_app/notifiers/home_view_model.dart';
import 'package:molibi_app/notifiers/notification_notifier.dart';
import 'package:molibi_app/themes/theme_molibi.dart';
import 'package:molibi_app/notifiers/connected_user_view_model.dart';
import 'package:molibi_app/widget/molibi_date_picker.dart';
import 'package:molibi_app/widget/molibi_text_field_complet.dart';
import 'package:molibi_app/widget/molibi_secondary_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateEndPage extends StatefulWidget {
  const CreateEndPage({super.key});

  @override
  State<CreateEndPage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreateEndPage> {
  @override
  Widget build(BuildContext context) {

    final formAccountKey = GlobalKey<FormState>();
    
    Future<void> handleButtonCreatePress(BuildContext context) async {

      if (formAccountKey.currentState!.validate()) {
            formAccountKey.currentState!.save();
            HomeViewModel homeVm = Provider.of<HomeViewModel>(context, listen: false);
            await Provider.of<ConnectedUserViewModel>(context, listen: false).createUser().then((response) async {
              Provider.of<NotificationNotifier>(context, listen: false).showInfoMessage(message: 'test');
              ConnectedUserViewModel userVm = Provider.of<ConnectedUserViewModel>(context, listen: false);
              homeVm.loadUserFeed(userVm.userProfil!.id).then((response) async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LayoutPage(selectedIndex: 0)),
                  );
              });
            });
              /*     
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilPage()),
            );
              */

        }
    }


    return Consumer<ConnectedUserViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
              body : Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        MolibiThemeData.molibiGreen2,
                        MolibiThemeData.molibiGreen1,
                      ],
                    )
                  ),
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Form(
                        key:formAccountKey,
                        child: Column(
                          children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 70, bottom:60),
                                child: Center(child:
                                  RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: const [
                                        TextSpan(
                                          text: 'Molibi', 
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 35.0, // Increase the font size here
                                            color: MolibiThemeData.molibilight, // Change the color to white here
                                            fontFamily: 'roboto-Black',
                                            decoration: TextDecoration.none
                                            )
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),      
                              
                              MolibiTextFieldComplet(
                                label:AppLocalizations.of(context)!.create_account_gender,
                                onSaved: (value) {
                                  viewModel.updateGender(value!);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(context)!.create_account_gender_error;
                                  }
                                  return null;
                                }
                              ),
                              MolibiDatePicker(
                                label:AppLocalizations.of(context)!.create_account_birthDate,
                                onSaved: (value) {
                                  viewModel.updateBirthDate(DateTime.parse(value!));
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(context)!.create_account_birthDate_error;
                                  }
                                  return null;
                                }
                              ),
                              MolibiTextFieldComplet(
                                label:AppLocalizations.of(context)!.create_account_weight,
                                onSaved: (value) {
                                  viewModel.updateWeight(double.parse(value!));
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(context)!.create_account_weight_error;
                                  }
                                  return null;
                                }
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(left:40.0,top:50.0, right:40.0, bottom:10.0), 
                                child: MolibiSecondaryButton(
                                  fontSize:15,
                                  onPressed: () => handleButtonCreatePress(context),
                                  label: AppLocalizations.of(context)!.create_account_final_button,
                                ),
                              )         
                                  
                          ],
                          
                        ),
                      ),
                    ),
              )
            );
        }
    );
  }
}
