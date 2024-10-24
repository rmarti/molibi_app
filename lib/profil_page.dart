import 'package:flutter/material.dart';
import 'package:molibi_app/change_password_page.dart';
import 'package:molibi_app/themes/theme_molibi.dart';
import 'package:molibi_app/notifiers/notification_notifier.dart';
import 'package:molibi_app/widget/molibi_app_bar.dart';
import 'package:molibi_app/widget/molibi_label.dart';
import 'package:molibi_app/widget/molibi_text_field.dart';
import 'package:molibi_app/widget/molibi_primary_button.dart';
import 'package:molibi_app/notifiers/connected_user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilPage extends StatefulWidget {
  final ConnectedUserViewModel connectedUserViewModel;

  const ProfilPage({
    super.key,
    required this.connectedUserViewModel
    });

  @override
  State<ProfilPage> createState() => ProfilPageState();
}

class ProfilPageState extends State<ProfilPage> {


  late ConnectedUserViewModel connectedUserViewModel;
  @override
  void initState() {
      super.initState();
  }

  

  @override
  Widget build(BuildContext context) {

    final formProfileKey = GlobalKey<FormState>();
    void handleValidation() {


      if (formProfileKey.currentState!.validate()) {
            formProfileKey.currentState!.save();

            widget.connectedUserViewModel.updateConnectedUser().then((response) {
              Provider.of<NotificationNotifier>(context, listen: false).showInfoMessage(message: 'test');
            });
      }
    }
    
    void handleButtonPress(BuildContext context,ConnectedUserViewModel connectedUserViewModel) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
      );
    }


    return Consumer<ConnectedUserViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.user == null) {
          return const CircularProgressIndicator();
        } else {
          return Scaffold(
            appBar: MolibiAppBar(title: AppLocalizations.of(context)!.title_profil, displayBack:true),
            body :  
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,            
                child: Form(
                  key:formProfileKey,                
                  child:Column(
                    children:[
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 16.0,
                            left: 16.0,
                            right: 16.0,
                            bottom: 16.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(50.0),                                  
                                  child: SizedBox(
                                    width: 55.0,
                                    height: 55.0,
                                    child: Image.network(
                                      viewModel.user!.profilePicture,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              ]
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 16.0,
                            left: 16.0,
                            right: 16.0,
                            bottom: 16.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Expanded(
                                flex: 4,
                                child: MolibiLabel(label: "Name"),
                              ),
                              Expanded(
                                flex: 6,
                                  child: MolibiTextField(
                                  content: viewModel.user?.firstName ,
                                  onSaved: (value) {
                                      viewModel.updateFirstName(value!);
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return AppLocalizations.of(context)!.update_account_firstName_error;
                                    }
                                    return null;
                                  }
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 16.0,
                            left: 16.0,
                            right: 16.0,
                            bottom: 16.0,
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                flex: 4,
                                child: MolibiLabel(label: "Lastname"),
                              ),
                              Expanded(
                                flex: 6,
                                child: MolibiTextField(
                                  content: viewModel.user?.lastName ,
                                  onSaved: (value) {
                                      viewModel.updateLastName(value!);
                                    },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return AppLocalizations.of(context)!.update_account_lastName_error;
                                    }
                                    return null;
                                  }
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 16.0,
                            left: 16.0,
                            right: 16.0,
                            bottom: 16.0,
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                flex: 4,
                                child: MolibiLabel(label: "Email"),
                              ),
                              Expanded(
                                flex: 6,
                                child: MolibiTextField(
                                  content: viewModel.user?.email ,
                                  onSaved: (value) {
                                      viewModel.updateEmail(value!);
                                  },                                  
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return AppLocalizations.of(context)!.update_account_email_error;
                                    }
                                    return null;
                                  }
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color:MolibiThemeData.molibiGrey4,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 10.0,
                              left: 16.0,
                              right: 16.0,
                              bottom: 10.0,
                            ),
                            child: Row(
                              children: [
                                const Expanded(
                                  flex: 4,
                                  child: MolibiLabel(label: "Password"),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: MolibiPrimaryButton(label: "Change my password",onPressed: () => handleButtonPress(context,viewModel),),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 16.0,
                            left: 16.0,
                            right: 16.0,
                            bottom: 16.0,
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                flex: 4,
                                child: MolibiLabel(label: "Gender"),
                              ),
                              Expanded(
                                flex: 6,
                                child: MolibiTextField(
                                  content: viewModel.user?.gender ,
                                  onSaved: (value) {
                                      viewModel.updateGender(value!);
                                  },                                  
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return AppLocalizations.of(context)!.update_account_gender_error;
                                    }
                                    return null;
                                  }
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 16.0,
                            left: 16.0,
                            right: 16.0,
                            bottom: 16.0,
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                flex: 4,
                                child: MolibiLabel(label: "Birthdate"),
                              ),
                              Expanded(
                                flex: 6,
                                child: MolibiTextField(
                                  content: viewModel.user?.birthDate.toString() ,
                                  onSaved: (value) {
                                      viewModel.updateBirthDate(DateTime.parse(value!));
                                  },                                  
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return AppLocalizations.of(context)!.update_account_birthDate_error;
                                    }
                                    return null;
                                  }
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 16.0,
                            left: 16.0,
                            right: 16.0,
                            bottom: 16.0,
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                flex: 4,
                                child: MolibiLabel(label: "Weight"),
                              ),
                              Expanded(
                                flex: 6,
                                child: MolibiTextField(
                                  content: viewModel.user!.weight.toString() ,
                                  onSaved: (value) {
                                      viewModel.updateWeight(double.parse(value!));
                                  },                                  
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return AppLocalizations.of(context)!.update_account_weight_error;
                                    }
                                    return null;
                                  }
                                ),
                              ),
                            ],
                          ),
                        ),
                        MolibiPrimaryButton(label: "Valid", onPressed: handleValidation)
                      ]
                    )
                  )
              )
          );
        }
      }
    );
  }
}
