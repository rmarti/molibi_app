import 'package:flutter/material.dart';
import 'package:molibi_app/models/challenge.dart';
import 'package:molibi_app/notifiers/base_select_mixin.dart';



class ChallengeListViewModel extends ChangeNotifier with  BaseSelectMixin {
  
    ChallengeService challengeService = ChallengeService();
    List<Challenge> myChallengeList = [];
    List<Challenge> findChallengeList = [];

    ChallengeListViewModel(){
      //myChallengeList = challengeService.fetchChallengelist(123);
      //findChallengeList = challengeService.fetchChallengelist(1234);
    }
    
 

    void loadChallengeConnectedUser() async  {
        myChallengeList = await challengeService.loadChallengeConnectedUser().then((response) async {
          notifyListeners();
          return response;
        }) ;      
    }

    void findChallengeByQuery(String? param) async  {
        findChallengeList = await challengeService.findChallengeByQuery(param).then((response) async {
          notifyListeners();
          return response;
        });      
    }


    Future<Challenge?> joinChallengeConnectedUser(Challenge challenge) async  {
        await challengeService.joinChallengeConnectedUser(challenge).then((response) async {
          
          findChallengeList.remove(challenge);
          myChallengeList.add(challenge);

          notifyListeners();
          return response;
        });    
        return null;  
    }

    Future<Challenge?>  quitChallengeConnectedUser(Challenge challenge) async  {
        await challengeService.quitChallengeConnectedUser(challenge).then((response) async {
          myChallengeList.remove(challenge);
          notifyListeners();
          return response;
        });     
        return null;   
    }



}
