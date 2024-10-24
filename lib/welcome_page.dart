import 'package:flutter/material.dart';
import 'package:molibi_app/create_first_page.dart';
import 'package:molibi_app/login_page.dart';
import 'package:molibi_app/themes/theme_molibi.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:molibi_app/widget/molibi_secondary_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});


  
  void handleButtonCreatePress(BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateFirstPage()),
        );
  }
  void handleButtonLoginPress(BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
  }

  @override
  Widget build(BuildContext context) {


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
                                fontSize: 35.0, // Increase the font size here
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
                    child: SvgPicture.asset('assets/images/logo5.svg',
                              alignment: Alignment.center,
                              fit: BoxFit.fill),
                  ),
                  Flexible(
                    child: Center(child: 
                      RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: const [
                            TextSpan(
                              text: 'Move more, live better', 
                              style: TextStyle(
                                fontSize: 60.0, // Increase the font size here
                                color: MolibiThemeData.molibilight, // Change the color to white here
                                fontFamily: 'Zenith',
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.normal , 
                                )
                              ),
                          ],
                        ),
                      )
                    ),
                  ),
                  Flexible(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0), // Added horizontal padding
                      child: MolibiSecondaryButton(
                        onPressed: () => handleButtonCreatePress(context),
                        label: AppLocalizations.of(context)!.get_started,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0), // Added horizontal padding
                      child: MolibiSecondaryButton(
                        onPressed: () => handleButtonLoginPress(context),
                        label: AppLocalizations.of(context)!.login,
                        backgroundColor: MolibiThemeData.molibiGrey4,
                        pressedBackgroundColor: MolibiThemeData.molibiGreen1, 
                      ),
                    ),
                  ),
                                    
                        
                ],
                
              ),
            )
            
        )
      );
  }


}


