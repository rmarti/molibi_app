import 'package:flutter/material.dart';
import 'package:molibi_app/constants/challenge_status.dart';
import 'package:molibi_app/constants/sport_type.dart';
import 'package:molibi_app/challenge_page.dart';
import 'package:molibi_app/models/challenge.dart';
import 'package:molibi_app/notifiers/challenge_list_view_model.dart';
import 'package:molibi_app/notifiers/notification_notifier.dart';
import 'package:molibi_app/themes/theme_molibi.dart';
import 'package:molibi_app/notifiers/challenge_view_model.dart';
import 'package:molibi_app/widget/molibi_primary_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MolibiChallengeCard extends StatelessWidget {

  final Challenge challenge;
  final String status;

  const MolibiChallengeCard({
    super.key,
    required this.challenge,
    required this.status,
  });



  void handleButtonActiontPress(BuildContext context,Challenge challeng) {

    ChallengeListViewModel groupListViewModel = Provider.of<ChallengeListViewModel>(context, listen: false);
  
    if (status == ChallengeStatus.member) {
      actionQuit(context,challeng,groupListViewModel);
    }
    else if (status == ChallengeStatus.waiting) {
      debugPrint("ici");
      actionJoin(context,challeng,groupListViewModel);
    }
    else {
      debugPrint("la");
      actionJoin(context,challeng,groupListViewModel);
    }

  }

  void actionQuit(BuildContext context, Challenge challenge, ChallengeListViewModel challengeListViewModel) {
        challengeListViewModel.quitChallengeConnectedUser(challenge).then((response) async {
              Provider.of<NotificationNotifier>(context, listen: false).showInfoMessage(message: 'test2');
        });
 }



  void actionJoin(BuildContext context, Challenge challenge, ChallengeListViewModel challengeListViewModel) {
        challengeListViewModel.joinChallengeConnectedUser(challenge).then((response) async {
              Provider.of<NotificationNotifier>(context, listen: false).showInfoMessage(message: 'test2');
        });
  }


  void handleOpenChallenge(BuildContext context, int id) {
     
    final challengeViewModel = Provider.of<ChallengeViewModel>(context, listen: false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FutureBuilder<Challenge>(
          future: challengeViewModel.updateChallenge(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Show a loading indicator while waiting for the challenge to load
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}'); // Show an error message if the challenge failed to load
            } else {
              return const ChallengePage(); // Show the ChallengePage once the challenge has been loaded
            }
          },
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    String urlLogo =  challenge.urlLogo;
    String label = "";

    if (status == ChallengeStatus.member) {
      label=AppLocalizations.of(context)!.challenge_button_quit;
    }
    else if (status == ChallengeStatus.waiting) {
      label=AppLocalizations.of(context)!.challenge_button_cancel;
    }
    else {
      label=AppLocalizations.of(context)!.challenge_button_join;
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(        
        borderRadius: BorderRadius.circular(10.0),
        color:MolibiThemeData.molibilight,
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => handleOpenChallenge(context,challenge.id),

                    child: Text(
                      challenge.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height:5),
                  GestureDetector(
                    onTap: () => handleOpenChallenge(context,challenge.id),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0), // You can adjust the radius as needed
                      child: SizedBox(
                        width: 60.0,
                        height: 60.0,
                        child: Image.network(
                          urlLogo,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height:5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: challenge.sportList.map((sport) {
                          return Icon(
                              AppSportType.getIconForSportType(sport),
                              color: MolibiThemeData.molibiGrey3,
                              size: 14.0
                            );
                        }).toList(),
                      ),
                      Text(
                        challenge.memberListCount.toString(),
                        style: const TextStyle(
                          color: MolibiThemeData.molibiGrey3,
                          fontSize: 14.0
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height:5),
                  GestureDetector(                    
                    onTap: () => handleOpenChallenge(context,challenge.id),
                    child: Text(
                      challenge.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            MolibiPrimaryButton(
                label: label,
                onPressed: () => handleButtonActiontPress(context,challenge),
              ),
          ],
        ),
      ),
    );
  }
  
}


