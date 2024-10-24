import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:molibi_app/constants/sport_type.dart';
import 'package:molibi_app/models/group.dart';
import 'package:molibi_app/models/user.dart';
import 'package:molibi_app/tools/token_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Challenge {
  int id;
  String urlLogo;
  String name;
  String description;
  String coverUrl;
  int memberListCount;
  List<User> memberList;
  List<String> sportList;
  Group? owner;
  DateTime? startDate;
  DateTime? endDate;


  Challenge({
    this.id=-1,
    this.urlLogo= "",
    this.name= "",
    this.description="",
    this.memberList=const [],
    this.sportList=const [],
    this.coverUrl="",
    this.memberListCount=0,
    this.owner,
    this.startDate,
    this.endDate,
  });

}

DateTime specificDate = DateTime(2022, 12, 31, 23, 59, 59);

class ChallengeService{


  Future<Challenge> findChallengeById (int? idParam) async{
    if (idParam != null) {
      return await TokenStorage().getToken().then((response) async {
           if (response != null){
              debugPrint ("${dotenv.env['api_base_url']}:${dotenv.env['api_base_port']}/api/challenges/find/$idParam");
                  return await http.get(
                  Uri.parse("${dotenv.env['api_base_url']}:${dotenv.env['api_base_port']}/api/challenges/find/$idParam"),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Authorization': "Bearer $response",
                  },
                ).then((response) async {
                  if (response.statusCode == 200) {
                    final String responseBody = response.body;
                    dynamic responseData = jsonDecode(responseBody);
                    debugPrint("on est ici?");
                    debugPrint(responseData[0]['challenge']['name']);
                    try {
                      return Challenge (
                        id: responseData[0]['challenge']['id'],
                        urlLogo:responseData[0]['challenge']['urlLogo'],
                        coverUrl:responseData[0]['challenge']['coverUrl'],
                        name: responseData[0]['challenge']['name'],
                        memberList: [],
                        memberListCount:responseData[0]['memberListCount'],
                        sportList: [AppSportType.cycling,AppSportType.walking],
                        description:responseData[0]['challenge']['description'],
                        startDate:DateTime.now(),
                        endDate:DateTime.now(),
                      );
                    } catch (e) {
                      debugPrint('Error parsing JSON: $e');
                      throw Exception('Failed to load challenge $idParam');
                    }
                  } 
                  else {
                    throw Exception('Failed to load challenge $idParam');
                  }
                });
            }
            else {
              throw Exception('Failed to load challenge\'s user');
            }
           
      });
    }
    else {
      throw Exception('Failed to load challenge');
    }
  }


  Future<List<Challenge>> findChallengeByQuery (String? param) async{

    return await TokenStorage().getToken().then((response) async {
        if (response != null){

          final Map<String, dynamic> parameters = {
            'requestParam': param,
            // Add more parameters as needed
          };

          return await http.post(
              Uri.parse("${dotenv.env['api_base_url']}:${dotenv.env['api_base_port']}/api/challenges/find"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': "Bearer $response",
              },
              body: jsonEncode(parameters),
            ).then((response) async {
              if (response.statusCode == 200) {
                 final String responseBody = response.body;
                List<dynamic> responseData = jsonDecode(responseBody);
                return List<Challenge>.from(responseData.map((challenge) => Challenge (
                                        id: challenge['challenge']['id'],
                                        urlLogo:challenge['challenge']['urlLogo'],
                                        name: challenge['challenge']['name'],
                                        memberList: [],
                                        memberListCount:challenge['memberListCount'],
                                        sportList: [AppSportType.cycling,AppSportType.walking],
                                        description:challenge['challenge']['description'],
                                        startDate:DateTime.now(),
                                        endDate:DateTime.now()
                                      )));
              } 
              else {
                throw Exception('Failed to load challenges');
              }
            });
        }
        else {
          throw Exception('Failed to load challenge\'s user');
        }
      });
  }


  Future<List<Challenge>> loadChallengeConnectedUser () async{

    return await TokenStorage().getToken().then((response) async {
        if (response != null){
          Map<String, dynamic> decodedToken = JwtDecoder.decode(response);

          return await http.get(
              Uri.parse("${dotenv.env['api_base_url']}:${dotenv.env['api_base_port']}/api/challenges/find/user/${decodedToken['id']}"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': "Bearer $response",
              },
            ).then((response) async {
              if (response.statusCode == 200) {
                final String responseBody = response.body;
                debugPrint("body : ${response.body}");
                List<dynamic> responseData = jsonDecode(responseBody);
                return List<Challenge>.from(responseData.map((challenge) => Challenge (
                                        id: challenge['challenge']['id'],
                                        urlLogo:challenge['challenge']['urlLogo'],
                                        name: challenge['challenge']['name'],
                                        memberList: [],
                                        memberListCount:challenge['memberListCount'],
                                        sportList: [AppSportType.cycling,AppSportType.walking],
                                        description:challenge['challenge']['description'],
                                        startDate:DateTime.now(),
                                        endDate:DateTime.now()
                                      )));
              } 
              else {
                return [];
                //throw Exception('Failed to load challenges');
              }
            });
        }
        else {
          throw Exception('Failed to load challenge\'s user');
        }
      });
  }




  Future<Challenge> quitChallengeConnectedUser (Challenge challenge) async{
    return await TokenStorage().getToken().then((response) async {
         if (response != null){
              return await http.post(
                Uri.parse("${dotenv.env['api_base_url']}:${dotenv.env['api_base_port']}/api/challenges/quit/${challenge.id}"),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Authorization': "Bearer $response",
                },
              ).then((response) async {
                if (response.statusCode == 200) {
                  return challenge;
                } 
                else {
                  throw Exception('Failed to load challenge ${challenge.id}');
                }
              });
          }
          else {
            throw Exception('Failed to load challenge\'s user');
          }
         
    });
  }

  Future<Challenge> joinChallengeConnectedUser (Challenge challenge) async{
    return await TokenStorage().getToken().then((response) async {
         if (response != null){
              return await http.post(
                Uri.parse("${dotenv.env['api_base_url']}:${dotenv.env['api_base_port']}/api/challenges/join/${challenge.id}"),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Authorization': "Bearer $response",
                },
              ).then((response) async {
                if (response.statusCode == 200) {
                  return challenge;
                } 
                else {
                  throw Exception('Failed to load challenge ${challenge.id}');
                }
              });
          }
          else {
            throw Exception('Failed to load challenge\'s user');
          }
         
    });
  }


}

