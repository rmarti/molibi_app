import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:molibi_app/models/challenge.dart';
import 'package:molibi_app/models/feed_item.dart';
import 'package:molibi_app/models/user.dart';
import 'package:molibi_app/constants/sport_type.dart';
import 'package:http/http.dart' as http;
import 'package:molibi_app/tools/token_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class Group {
  final int id;
  String name;
  List<String> sportList;
  String description;
  int member;
  List<User> memberList;
  String privacy;
  String status;
  String urlLogo;
  String coverUrl;
  List<Challenge> challengeList;
  List<FeedItem>feedItemList;

  Group({
    this.id=-1,
    this.name="",
    this.sportList=const[],
    this.description="",
    this.member=0,
    this.memberList=const[],
    this.privacy="",
    this.urlLogo="",
    this.status="",
    this.coverUrl="",
    this.challengeList=const[],
    this.feedItemList=const[],
  });

}



class GroupService{

  List<Group> findListReturn = [];
  List<Group> myListReturn = [];
  



  Future<List<Group>> loadGroupConnectedUser () async{

    return await TokenStorage().getToken().then((response) async {
        if (response != null){
          Map<String, dynamic> decodedToken = JwtDecoder.decode(response);

          return await http.get(
              Uri.parse("${dotenv.env['api_base_url']}:${dotenv.env['api_base_port']}/api/groups/find/user/${decodedToken['id']}"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': "Bearer $response",
              },
            ).then((response) async {
              if (response.statusCode == 200) {
                 final String responseBody = response.body;
                List<dynamic> responseData = jsonDecode(responseBody);
                return List<Group>.from(responseData.map((group) => Group(
                                              id: group['group']['id'],
                                              name: group['group']['name'],
                                              sportList: [AppSportType.walking],
                                              description: group['group']['description'],
                                              member: group['memberListCount'],
                                              privacy: group['group']['visibility'],
                                              urlLogo: group['group']['urlLogo'],
                                            )));
              } 
              else {
                throw Exception('Failed to load groups');
              }
            });
        }
        else {
          throw Exception('Failed to load group\'s user');
        }
      });
  }


  Future<List<Group>> findGroupByQuery (String? param) async{

    return await TokenStorage().getToken().then((response) async {
        if (response != null){

          final Map<String, dynamic> parameters = {
            'requestParam': param,
            // Add more parameters as needed
          };

          return await http.post(
              Uri.parse("${dotenv.env['api_base_url']}:${dotenv.env['api_base_port']}/api/groups/find"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': "Bearer $response",
              },
              body: jsonEncode(parameters),
            ).then((response) async {
              if (response.statusCode == 200) {
                final String responseBody = response.body;

                debugPrint("body : ${response.body}");

                List<dynamic> responseData = jsonDecode(responseBody);
                return List<Group>.from(responseData.map((group) => Group(
                                              id: group['group']['id'],
                                              name: group['group']['name'],
                                              sportList: [AppSportType.walking],
                                              description:  group['group']['description'],
                                              member: group['memberListCount'],
                                              privacy: group['group']['visibility'],
                                              urlLogo:group['group']['urlLogo'],
                                            )));
              } 
              else {
                throw Exception('Failed to load groups');
              }
            });
        }
        else {
          throw Exception('Failed to load group\'s user');
        }
      });
  }

  Future<Group> findGroupById (int? idParam) async{
    if (idParam != null) {
      return await TokenStorage().getToken().then((response) async {
           if (response != null){
                  return await http.get(
                  Uri.parse("${dotenv.env['api_base_url']}:${dotenv.env['api_base_port']}/api/groups/find/$idParam"),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Authorization': "Bearer $response",
                  },
                ).then((response) async {
                  if (response.statusCode == 200) {
                    final String responseBody = response.body;
                    dynamic responseData = jsonDecode(responseBody);
                    return Group(
                                  id: responseData[0]['group']['id'],
                                  name: responseData[0]['group']['name'],
                                  sportList: [AppSportType.walking],
                                  description:  responseData[0]['group']['description'],
                                  member: responseData[0]['memberListCount'],
                                  privacy: responseData[0]['group']['visibility'],
                                  urlLogo:responseData[0]['group']['urlLogo'],
                                  coverUrl:responseData[0]['group']['coverUrl'],
                                );
                  } 
                  else {
                    throw Exception('Failed to load group $idParam');
                  }
                });
            }
            else {
              throw Exception('Failed to load group\'s user');
            }
           
      });
    }
    else {
      throw Exception('Failed to load group');
    }
  }



  Future<Group?> quitGroupConnectedUser (Group group) async{
    final response =  await TokenStorage().getToken();
    if (response != null){
        return await http.post(
          Uri.parse("${dotenv.env['api_base_url']}:${dotenv.env['api_base_port']}/api/groups/quit/${group.id}"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': "Bearer $response",
          },
        ).then((response) async {
          if (response.statusCode == 200) {
            return group;
          } 
          else {
            return null;
          }
        });
    }
    else {
      return null;
    }
  }

  Future<Group?> joinGroupConnectedUser (Group group) async{
    final response =  await TokenStorage().getToken();
    if (response != null){
        return await http.post(
          Uri.parse("${dotenv.env['api_base_url']}:${dotenv.env['api_base_port']}/api/groups/join/${group.id}"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': "Bearer $response",
          },
        ).then((response) async {
          if (response.statusCode == 200) {
            return group;
          } 
          else {
            return null;
          }
        });
    }
    else {
      return null;
    }
  }



}

