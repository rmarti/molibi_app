import 'dart:io';

import 'package:flutter/material.dart';
import 'package:molibi_app/notifiers/challenge_list_view_model.dart';
import 'package:molibi_app/notifiers/challenge_view_model.dart';
import 'package:molibi_app/notifiers/exercice_view_model.dart';
import 'package:molibi_app/notifiers/group_list_view_model.dart';
import 'package:molibi_app/notifiers/group_view_model.dart';
import 'package:molibi_app/notifiers/home_view_model.dart';
import 'package:molibi_app/notifiers/notification_notifier.dart';
import 'package:molibi_app/notifiers/connected_user_view_model.dart';
import 'package:molibi_app/notifiers/user_view_model.dart';
import 'package:molibi_app/welcome_page.dart';
import 'package:molibi_app/themes/theme_molibi.dart';
import 'package:molibi_app/widget/molibi_notification_snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';



//ATTENTION NE PAS METTRE EN PROD AVEC CE CODE
//QUI PERMET DE CONTOURNER LES CERTIFICATS SSL
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() async{
  
  await dotenv.load(fileName: "assets/.env");
   
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ConnectedUserViewModel()),
          ChangeNotifierProvider(create: (_) => HomeViewModel()),
          ChangeNotifierProvider(create: (_) => ExerciceViewModel()),
          ChangeNotifierProvider(create: (_) => GroupListViewModel()),
          ChangeNotifierProvider(create: (_) => ChallengeListViewModel()),
          ChangeNotifierProvider(create: (_) => ChallengeViewModel()),
          ChangeNotifierProvider(create: (_) => NotificationNotifier()),
          ChangeNotifierProvider(create: (_) => UserViewModel()),
          ChangeNotifierProxyProvider<GroupListViewModel, GroupViewModel>(
            create: (context) {
              return GroupViewModel();
            },
            update: (context, groupListViewModel, groupViewModel) {
              groupViewModel?.findGroup(groupListViewModel.selectedItemId);
              return groupViewModel!;
            },
          ),


        ],
      child: MolibiApp()
      ),
    );
}

class MolibiApp extends StatelessWidget {

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  MolibiApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Molibi - Move more Live Better',
      home: const Scaffold(
        body: Stack(
          children: [
            WelcomePage(), 
            MolibiNotificationSnackBar(), 
          ],
        ),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('fr'), 
      ],
      
      themeMode: ThemeMode.light, //or ThemeMode.dark
      theme: MolibiThemeData.lightTheme,
      darkTheme: MolibiThemeData.darkTheme,
      // darkTheme: MolibiThemeData.lightThemeData,
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey,
    );
  }
  


} 

