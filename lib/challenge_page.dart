import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:molibi_app/themes/theme_molibi.dart';
import 'package:molibi_app/notifiers/challenge_view_model.dart';
import 'package:molibi_app/widget/molibi_app_bar_transparent.dart';
import 'package:molibi_app/widget/molibi_primary_button.dart';
import 'package:provider/provider.dart';



class ChallengePage extends StatefulWidget {

  const ChallengePage(
    {
      super.key
    });

  @override
  State<ChallengePage> createState() => ChallengePageState();
}

class ChallengePageState extends State<ChallengePage> {


  @override
  Widget build(BuildContext context) {

    return Consumer<ChallengeViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          body: SizedBox(
            width: double.infinity, 
            child: CustomScrollView(
              slivers: <Widget>[
                MolibiAppBarTransparent(coverUrl:viewModel.challenge.coverUrl),
                SliverList(
                  delegate: SliverChildListDelegate( [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [                                  
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child:
                                Text(
                                  viewModel.challenge.name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: MolibiThemeData.molibiGrey2,
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(AppLocalizations.of(context)!.challenge_status_public),
                                    Text(
                                      "${viewModel.challenge.memberList.length} ${AppLocalizations.of(context)!.challenge_participants}",
                                      style: const TextStyle(
                                        color: MolibiThemeData.molibiGrey3,
                                        fontSize: 14.0
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Text("${AppLocalizations.of(context)!.challenge_from} ${viewModel.challenge.startDate != null ? DateFormat.yMd(Localizations.localeOf(context).toString()).format(viewModel.challenge.startDate!) : 'N/A'}"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Text("${AppLocalizations.of(context)!.challenge_everyone} ")
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width*0.4,
                                child:
                                  MolibiPrimaryButton(label: AppLocalizations.of(context)!.challenge_participate, onPressed: ()=>{}),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                color: MolibiThemeData.molibiGrey4,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom:8.0),
                                  child: Column(
                                    mainAxisAlignment:MainAxisAlignment.start,
                                    children:[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            AppLocalizations.of(context)!.challenge_organizer,
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                              fontSize:22,
                                              color:MolibiThemeData.molibiGrey1,
                                              fontWeight:FontWeight.bold,
                                              ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height:120,
                                        child: Row(
                                          children: [
                                            const Expanded(
                                              flex:1,
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Align(
                                                  alignment: Alignment.topCenter,
                                                  child: Text("a revoir"),
                                                  
                                                  /*
                                                  ClipRRect(
                                                            borderRadius: BorderRadius.circular(10.0), // You can adjust the radius as needed
                                                            child: SizedBox(
                                                                child: Image.network(
                                                                  viewModel.challenge?.owner!.urlLogo,
                                                                  fit: BoxFit.cover,
                                                                ),
                                                            ),
                                                          ),*/
                                                ),
                                              ),
                                            ),
                                            const Expanded(
                                              flex:2,
                                              child: Column(
                                                children:[
                                                  Expanded(
                                                    child: Text(
                                                      "a revoir 2",
                                                      //viewModel.challenge.owner!.name,
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  //Text("${viewModel.challenge.owner!.memberList.length} ${AppLocalizations.of(context)!.challenge_members}"),
                                                ]
                                              ),
                                            ),
                                            Expanded(
                                              flex:1,
                                              child: Column(
                                                children:[                                          
                                                  MolibiPrimaryButton(label: "Join", onPressed: ()=>{}),
                                                  const Expanded(
                                                    child: Align(
                                                      alignment: Alignment.bottomCenter,
                                                      child: Text ("a revoir 3") 
                                                      //Text("${viewModel.challenge.owner!.challengeList.length} ${AppLocalizations.of(context)!.challenge_challenge}")
                                                    )
                                                  ),
                                                ]
                                              ),
                                            )
                                          ]
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),                    
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child:
                                    Text(
                                      AppLocalizations.of(context)!.challenge_description,
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontSize:22,
                                        color:MolibiThemeData.molibiGrey1,
                                        fontWeight:FontWeight.bold,
                                        ),
                                      ),
                                ),
                              ),                 
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child:
                                    Text(
                                      viewModel.challenge.description,
                                      textAlign: TextAlign.justify,
                                      ),
                                ),
                              ),                                       
                                                              
                              SizedBox(
                                height: 50.0, 
                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                              AppLocalizations.of(context)!.challenge_participants,
                                              style: const TextStyle(
                                                  fontSize:22,
                                                  color:MolibiThemeData.molibiGrey1,
                                                  fontWeight:FontWeight.bold,
                                                ),
                                              ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        AppLocalizations.of(context)!.challenge_participants_view_all,
                                        style: const TextStyle(
                                          color: MolibiThemeData.molibiGreen1,
                                          fontSize: 14.0
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ), 
                              Row(
                                children: List.generate(viewModel.challenge.memberList.length, (index) {
                                      return  Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(40.0), // You can adjust the radius as needed
                                                  child: SizedBox(
                                                    width: 40.0,
                                                    height: 40.0,
                                                    child: Image.network(
                                                      viewModel.challenge.memberList[index].profilePicture,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                      );
                                    }),
                                  ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width*0.4,
                                child:
                                  MolibiPrimaryButton(label: AppLocalizations.of(context)!.challenge_participate, onPressed: ()=>{}),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ), 
                            ]
                          )
                        )
                      )
                    ]
                  )
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}


