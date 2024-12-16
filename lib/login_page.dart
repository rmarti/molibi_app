import 'package:flutter/material.dart';
import 'package:molibi_app/layout.dart';
import 'package:molibi_app/notifiers/notification_notifier.dart';
import 'package:molibi_app/themes/theme_molibi.dart';
import 'package:molibi_app/notifiers/home_view_model.dart';
import 'package:molibi_app/notifiers/connected_user_view_model.dart';
import 'package:molibi_app/widget/molibi_text_field_complet.dart';
import 'package:molibi_app/widget/molibi_secondary_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:email_validator/email_validator.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text:"romain.martinez@gmail.com");
  final _passwordController = TextEditingController(text:"aze");


  @override
  Widget build(BuildContext context) {

    Future<void> handleButtonLoginPress(BuildContext context) async {
        final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
        final connectedUserViewModel = Provider.of<ConnectedUserViewModel>(context, listen: false);        

        if (_formKey.currentState!.validate()) {
           connectedUserViewModel.authUser(_emailController.text, _passwordController.text).then((response) async {
              if(response == true){
                connectedUserViewModel.loadConnectedUser().then((response) async {
                  if (response == true){
                    homeViewModel.loadUserFeed(connectedUserViewModel.user!.id).then((response) async {
                        if (response == true){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LayoutPage(selectedIndex: 0)),
                          );
                        }
                        else{
                            Provider.of<NotificationNotifier>(context, listen: false).showErrorMessage(message: AppLocalizations.of(context)!.login_connect_error,);              
                        }
                    });
                  }
                  else{
                      Provider.of<NotificationNotifier>(context, listen: false).showErrorMessage(message: AppLocalizations.of(context)!.login_connect_error);              
                  }
                });
              }
              else{
                Provider.of<NotificationNotifier>(context, listen: false).showErrorMessage(message: AppLocalizations.of(context)!.login_connect_error);
              }
          });
        }
        else{
          Provider.of<NotificationNotifier>(context, listen: false).showErrorMessage(message: AppLocalizations.of(context)!.login_connect_error);
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
                  child: Column(
                    children: [
                      Flexible(
                        flex:3,
                        child: 
                        Center(child:
                          RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: const [
                                TextSpan(
                                  text: 'Molibi', 
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 45.0,
                                    color: MolibiThemeData.molibilight, 
                                    fontFamily: 'roboto-Black',
                                    decoration: TextDecoration.none
                                    )
                                  ),
                              ],
                            ),
                          ),
                        )
                      ),
                      Flexible(
                        flex:7,
                        child: 
                        Column(
                          children: [
                            Center(child:
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    TextSpan(
                                      text: AppLocalizations.of(context)!.login_title, 
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0, 
                                        color: MolibiThemeData.molibiGrey1, 
                                        fontFamily: 'Roboto-light',
                                        decoration: TextDecoration.none
                                        )
                                      ),
                                      
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height:18),
                            Center(
                              child:
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: 
                                        TextSpan(
                                          text:  AppLocalizations.of(context)!.login_description, 
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15.0, 
                                            color: MolibiThemeData.molibiGrey4,
                                            fontFamily: 'Roboto-light',
                                            decoration: TextDecoration.none,                                            
                                          )
                                        ),  
                                  ),
                            ),
                            Form(
                              key:_formKey,
                              child: Column(
                                children: [
                                  SizedBox(
                                    child:  MolibiTextFieldComplet(
                                      controller: _emailController,
                                      label:AppLocalizations.of(context)!.login_email,
                                      onSaved: (value) {
                                      },
                                      validator: (value) {                                        
                                        if (value == null || value.isEmpty) {
                                          return AppLocalizations.of(context)!.login_error_email;
                                        } else if (!EmailValidator.validate(value)) {
                                          return AppLocalizations.of(context)!.login_error_invalid_email;
                                        }
                                        return null;
                                      }
                                    ),

                                  ),
                                  SizedBox(
                                    child:  MolibiTextFieldComplet(
                                      controller: _passwordController,
                                      obscureText:true,
                                      label:AppLocalizations.of(context)!.login_password,
                                      onSaved: (value) {
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return AppLocalizations.of(context)!.login_password_error_email;
                                        }
                                        return null;
                                      }
                                    ),

                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.only(left:40.0,top:10.0, right:40.0, bottom:10.0), 
                                      child: MolibiSecondaryButton(
                                        fontSize:15,
                                        onPressed: () => handleButtonLoginPress(context),
                                        label: AppLocalizations.of(context)!.login_connect_button,
                                      ),
                                    ),
                                ],
                              )
                            
                            ),
                            
                          ],
                        )
                      ),
                    ],
                    
                  ),
                )
            )
          );
      }
    );
  }
}
