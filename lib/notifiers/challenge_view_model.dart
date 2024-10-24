import 'package:flutter/material.dart';
import 'package:molibi_app/models/challenge.dart';



class ChallengeViewModel extends ChangeNotifier {
  
  ChallengeService challengeService = ChallengeService();
  late Challenge challenge;

  ChallengeViewModel ();


  Future<Challenge> updateChallenge (int id) async  {
      debugPrint("on est ici $id");
      final response= await challengeService.findChallengeById(id);
      notifyListeners();
      debugPrint("response : ");
      debugPrint(response.toString());
      challenge = response;
      return response;
  }
 

}
