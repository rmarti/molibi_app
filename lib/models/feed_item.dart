import 'dart:convert';
import 'package:molibi_app/models/user.dart';
import 'package:molibi_app/tools/token_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;


class FeedItem {
  final int id;
  User user;
  DateTime date;
  String contentText;
  List<String> contentImage;
  double calories;
  int moliPoints;
  double distance;
  int step;
  List<String> reactionList;
  String connectedUserReaction;


  FeedItem({
    this.id=-1,
    required this.user,
    required this.date,
    this.contentText="",
    this.contentImage=const [],
    this.reactionList=const [],
    this.connectedUserReaction="",
    this.calories=0.0,
    this.moliPoints=0,
    this.distance=0.0,
    this.step=0,
  });



}



class FeedItemService{

      User user1 =User(
          id: 1234,
          email: "romain@mailtest.fr",
          firstName: "romain-test",
          lastName: "martinez-test",
          profilePicture: "https://i.pinimg.com/564x/bc/61/97/bc61979451b11263cab4f49e21ffc131.jpg",
          birthDate: DateTime.now()
      );

      User user2 =User(
          id: 159,
          email: "2romain@mailtest.fr2",
          firstName: "2romain-test2",
          lastName: "2martinez-test2",
          profilePicture: "https://i.pinimg.com/564x/e6/33/ee/e633eefbeb77cd4323a1557d33c91c83.jpg",
          birthDate: DateTime.now()
      );

    Future<List<FeedItem>> loadUserFeedItems(int user) async {

      return await TokenStorage().getToken().then((token) async {
        return await http.get(
                      Uri.parse("${dotenv.env['api_base_url']}:${dotenv.env['api_base_port']}/api/items/user/$user"),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                        'Authorization': "Bearer $token",
                      },
                    ).then((response) async {
                      if (response.statusCode == 200) {

                          final String responseBody = response.body;

                          List<dynamic> responseData = jsonDecode(responseBody);

                          return List<FeedItem>.from(responseData.map((item) => FeedItem(
                                                                          id: item['id'],
                                                                        user:User(
                                                                            id: item['owner']['id'],
                                                                            birthDate: DateTime.now(),
                                                                            firstName: item['owner']['firstName'],
                                                                            lastName: item['owner']['lastName'],
                                                                            profilePicture: "https://i.pinimg.com/564x/bc/61/97/bc61979451b11263cab4f49e21ffc131.jpg",
                                                                        ),
                                                                        contentText: item['content'] ,
                                                                        date:DateTime.now()
                                                                      )));
                                                                      
                      }
                      else{
                        throw Exception('Failed to load feed items');
                      }
                  });
      });
          
    }

    List<FeedItem> fetchFeedItems(int user) {

      List<FeedItem> feedItems = [];

      FeedItem it1 = FeedItem(
        id: 123,
        user:user1,
        date:DateTime.now(),
        contentText:"J'ai couru 50 km en 30 jours et je partage mes progrès avec nous ! Utilisez le hashtag #RunningChallenge pour inspirer et être inspiré. Prêts à relever le défi ? 🏅 #FitnessGoals #TeamSpirit",
        calories:13590,
        moliPoints:1548,
        distance:21.15,
        step:21045,
        reactionList:["like","like","like"]
      );
      FeedItem it2 = FeedItem(
          id: 1234,
          user:user2,
          date:DateTime.now(),
          contentText:"Nouvelle course virtuelle ce week-end ! Choisissez votre distance, enfilez vos baskets, et courez à votre rythme. Partagez vos photos de course avec #VirtualRun et rejoignez notre communauté de passionnés ! 🌟 #RunTogether #StayActive",
          calories:985321,
          moliPoints:4536,
          distance:18.59,
          step:18647,
          reactionList:[]
        );

      FeedItem it3 = FeedItem(
          id: 1234,
          user:user2,
          date:DateTime.now(),
          contentText:"2Nouvelle course virtuelle ce week-end ! Choisissez votre distance, enfilez vos baskets, et courez à votre rythme. Partagez vos photos de course avec #VirtualRun et rejoignez notre communauté de passionnés ! 🌟 #RunTogether #StayActive",
          calories:985321,
          moliPoints:4536,
          distance:18.59,
          step:18647,
          reactionList:[]
        );

      FeedItem it4 = FeedItem(
          id: 1234,
          user:user2,
          date:DateTime.now(),
          contentText:"3Nouvelle course virtuelle ce week-end ! Choisissez votre distance, enfilez vos baskets, et courez à votre rythme. Partagez vos photos de course avec #VirtualRun et rejoignez notre communauté de passionnés ! 🌟 #RunTogether #StayActive",
          calories:985321,
          moliPoints:4536,
          distance:18.59,
          step:18647,
          reactionList:[]
        );

      if (user == 123) {
        feedItems.add(it1);
      }
      else{
        feedItems.add(it4);
        feedItems.add(it1);
        feedItems.add(it2);
        feedItems.add(it3);
      }
      return feedItems;
    }
}

