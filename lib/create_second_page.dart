import 'package:flutter/material.dart';
import 'package:molibi_app/create_end_page.dart';
import 'package:molibi_app/themes/theme_molibi.dart';
import 'package:molibi_app/notifiers/connected_user_view_model.dart';
import 'package:molibi_app/widget/molibi_text_field_complet.dart';
import 'package:molibi_app/widget/molibi_secondary_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CreateSecondPage extends StatefulWidget {
  const CreateSecondPage({super.key});

  @override
  State<CreateSecondPage> createState() => _CreateSecondPageState();
}

class _CreateSecondPageState extends State<CreateSecondPage> {
  @override
  Widget build(BuildContext context) {

    final formAccountKey = GlobalKey<FormState>();
    
    void handleButtonPress(BuildContext context) {

      if (formAccountKey.currentState!.validate()) {
          formAccountKey.currentState!.save();         
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateEndPage()),
            );
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
                                label:AppLocalizations.of(context)!.create_account_firstname,
                                onSaved: (value) {
                                  viewModel.updateFirstName(value!);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(context)!.create_account_firstname_error;
                                  }
                                  return null;
                                }
                              ),
                              MolibiTextFieldComplet(
                                label:AppLocalizations.of(context)!.create_account_lastname,
                                onSaved: (value) {
                                  viewModel.updateLastName(value!);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(context)!.create_account_lastname_error;
                                  }
                                  return null;
                                }
                              ),
                              MolibiTextFieldComplet(
                                label:AppLocalizations.of(context)!.create_account_password,
                                onSaved: (value) {
                                  viewModel.updatePassword(value!);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(context)!.create_account_password_error;
                                  }
                                  return null;
                                }
                              ),
                              MolibiTextFieldComplet(
                                label:AppLocalizations.of(context)!.create_account_confirm_password,
                                onSaved: (value) {
                                  //viewModel.updateEmail(value!);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(context)!.create_account_confirm_password_error;
                                  }
                                  return null;
                                }
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(left:40.0,top:50.0, right:40.0, bottom:10.0), 
                                child: MolibiSecondaryButton(
                                  fontSize:15,
                                  onPressed: () => handleButtonPress(context),
                                  label: AppLocalizations.of(context)!.create_account_nextStep_button,
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
