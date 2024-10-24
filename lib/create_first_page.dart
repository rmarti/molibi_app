import 'package:flutter/material.dart';
import 'package:molibi_app/create_second_page.dart';
import 'package:molibi_app/layout.dart';
import 'package:molibi_app/themes/theme_molibi.dart';
import 'package:molibi_app/notifiers/connected_user_view_model.dart';
import 'package:molibi_app/widget/molibi_text_field_complet.dart';
import 'package:molibi_app/widget/molibi_secondary_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateFirstPage extends StatefulWidget {
  const CreateFirstPage({super.key});

  @override
  State<CreateFirstPage> createState() => _CreateFirstPageState();
}

class _CreateFirstPageState extends State<CreateFirstPage> {
  @override
  Widget build(BuildContext context) {

    final formEmailKey = GlobalKey<FormState>();

    void handleButtonCreatePress(BuildContext context) {

        if (formEmailKey.currentState!.validate()) {
          formEmailKey.currentState!.save();
          
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateSecondPage()),
          );
        }
    }

    void handleButtonPress2(BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LayoutPage()),
        );
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
                                    fontSize: 45.0, // Increase the font size here
                                    color: MolibiThemeData.molibilight, // Change the color to white here
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
                                      text: AppLocalizations.of(context)!.create_account, 
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0, // Increase the font size here
                                        color: MolibiThemeData.molibiGrey1, // Change the color to white here
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
                                          text:  AppLocalizations.of(context)!.create_account_description, 
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15.0, // Increase the font size here
                                            color: MolibiThemeData.molibiGrey4, // Change the color to white here
                                            fontFamily: 'Roboto-light',
                                            decoration: TextDecoration.none,
                                            
                                          )
                                        ),  
                                  ),
                            ),
                            Form(
                              key:formEmailKey,
                              child: Column(
                                children: [
                                  SizedBox(
                                    child:  MolibiTextFieldComplet(
                                      label:AppLocalizations.of(context)!.create_account_email,
                                      onSaved: (value) {
                                        viewModel.updateEmail(value!);
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return AppLocalizations.of(context)!.create_account_error_email;
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
                                        onPressed: () => handleButtonCreatePress(context),
                                        label: AppLocalizations.of(context)!.create_account_button,
                                      ),
                                    ),
                                ],
                              )
                            
                            ),
                            Center(child:
                                RichText(
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: [
                                      TextSpan(
                                        text: AppLocalizations.of(context)!.create_account_or_continue, 
                                        style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15.0, 
                                          color: MolibiThemeData.molibiGrey4, 
                                          fontFamily: 'roboto-Black',
                                          decoration: TextDecoration.none
                                          )
                                        )
                                    ],
                                  ),
                                ),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(left:40.0,top:10.0, right:40.0, bottom:10.0),
                                child: FilledButton(
                                  onPressed: () => handleButtonPress2(context),
                                  style: ButtonStyle(
                                      elevation: WidgetStateProperty.all(10),
                                      shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),             
                                        ),
                                      ),
                                      padding: WidgetStateProperty.all(
                                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12), 
                                      ),
                                      backgroundColor: WidgetStateProperty.all(
                                        MolibiThemeData.molibiGrey4
                                      ),
                                      foregroundColor: WidgetStateProperty.all(
                                        MolibiThemeData.molibiGrey1
                                      ),
                                    ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset('assets/images/logo-google.svg',
                                            alignment: Alignment.center,
                                            fit: BoxFit.fill,
                                            height:20,
                                            width:20,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text ("Google"),
                                    ],
                                  )
                                ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(left:40.0,top:10.0, right:40.0, bottom:10.0), // Added horizontal padding
                              child:
                                Center(
                                  child: RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: const [
                                        TextSpan(
                                          text: 'By clicking continue, you agree to our ', 
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12.0, // Increase the font size here
                                            color: MolibiThemeData.molibiGrey4, // Change the color to white here
                                            fontFamily: 'Roboto-light',
                                            decoration: TextDecoration.none,                                          
                                            )
                                          ), 
                                          
                                        TextSpan(
                                          text: 'Terms of Service  ', 
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12.0, // Increase the font size here
                                            color: MolibiThemeData.molibiGrey1, // Change the color to white here
                                            fontFamily: 'Roboto-light',
                                            decoration: TextDecoration.none,                                          
                                            )
                                          ), 

                                          
                                        TextSpan(
                                          text: 'and ', 
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12.0, // Increase the font size here
                                            color: MolibiThemeData.molibiGrey4, // Change the color to white here
                                            fontFamily: 'Roboto-light',
                                            decoration: TextDecoration.none,                                          
                                            )
                                          ), 

                                          
                                        TextSpan(
                                          text: 'Privacy Policy ', 
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12.0, // Increase the font size here
                                            color: MolibiThemeData.molibiGrey1, // Change the color to white here
                                            fontFamily: 'Roboto-light',
                                            decoration: TextDecoration.none,                                          
                                            )
                                          ),                                        
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                            )
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
