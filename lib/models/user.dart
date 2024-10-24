
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:molibi_app/models/challenge.dart';
import 'package:molibi_app/tools/token_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class User {
  int id;
  String firstName;
  String lastName;
  String email;
  String password;
  String gender;
  DateTime? birthDate;
  double weight;
  String profilePicture;
  List<Challenge> challenges;


   User({
    this.id = -1,
    this.email = "",
    this.firstName = "",
    this.lastName = "",
    this.password = "",
    this.gender = "",
    this.weight = 0.0,
    this.profilePicture = "",
    List<Challenge>? challenges,
    required this.birthDate,
  }) : challenges = challenges ?? [];

}



class UserService{


    Future<User?> loadUser( int? idUser) async {  
      return await TokenStorage().getToken().then((response) async {
        if (response != null){

          return await http.get(
              Uri.parse("${dotenv.env['api_base_url']}:${dotenv.env['api_base_port']}/api/users/find/$idUser"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': "Bearer $response",
              },
            ).then((response) async {
              if (response.statusCode == 200) {
                final String responseBody = response.body;
                dynamic responseData = jsonDecode(responseBody);
                User userReturn = User(
                  id:responseData[0]["user"]['id'],
                  firstName: responseData[0]["user"]['firstName'],
                  lastName: responseData[0]["user"]['lastName'],
                  birthDate: DateTime.parse(responseData[0]["user"]['birthDate']),
                  profilePicture: responseData[0]["user"]['profilePicture'],
                );

                try {
          debugPrint(responseBody);
                  for (int i = 0; i < responseData[0]["user"]['challengeResultList'].length; i++) {

                    Challenge challenge= Challenge(
                      id:responseData[0]["user"]['challengeResultList'][i]["challenge"]["id"],
                      name:responseData[0]["user"]['challengeResultList'][i]["challenge"]["name"],
                      urlLogo:responseData[0]["user"]['challengeResultList'][i]["challenge"]["urlLogo"],
                    );
                    userReturn.challenges.add(challenge);
                  }
                } catch (e) {
                  debugPrint("exception : $e");
                  throw Exception('Failed to load user challenges');
                }

                return userReturn;
              } 
              else {
                throw Exception('Failed to load user');
              }
            });
        }
        return null;
      });                     
              
    }                 

    
    Future<User?> loadConnectedUser() async {  
      return await TokenStorage().getToken().then((response) async {
        if (response != null){
          Map<String, dynamic> decodedToken = JwtDecoder.decode(response);

          return await http.get(
              Uri.parse("${dotenv.env['api_base_url']}:${dotenv.env['api_base_port']}/api/users/${decodedToken['id']}"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': "Bearer $response",
              },
            ).then((response) async {
              if (response.statusCode == 200) {
                Map<String, dynamic> responseData = jsonDecode(response.body);
                return User(
                  id:responseData['id'],
                  email: responseData['email'],
                  firstName: responseData['firstName'],
                  lastName: responseData['lastName'],
                  gender: responseData['gender'],
                  birthDate: DateTime.parse(responseData['birthDate']),
                  profilePicture: responseData['profilePicture'],
                  weight: responseData['weight'].toDouble(),
                );  
              } 
              else {
                throw Exception('Failed to load user');
              }
            });
        }
        return null;
      });                     
              
    }


    Future<User?> updateConnectedUser(Map<String, dynamic> parameters) async {  
      return await TokenStorage().getToken().then((response) async {
        if (response != null){
          Map<String, dynamic> decodedToken = JwtDecoder.decode(response);

          return await http.patch(
              Uri.parse("${dotenv.env['api_base_url']}:${dotenv.env['api_base_port']}/api/users/${decodedToken['id']}"),
              headers: <String, String>{
                'Content-Type': 'application/merge-patch+json',
                'Authorization': "Bearer $response",
              },
              body: jsonEncode(parameters)
            ).then((response) async {

              if (response.statusCode == 200) {
                Map<String, dynamic> responseData = jsonDecode(response.body);
                return User(
                  id:responseData['id'],
                  email: responseData['email'],
                  firstName: responseData['firstName'],
                  lastName: responseData['lastName'],
                  gender: responseData['gender'],
                  birthDate: DateTime.parse(responseData['birthDate']),
                  profilePicture: responseData['profilePicture'],
                  weight: responseData['weight'].toDouble(),
                );  
              } 
              else {
                throw Exception('Failed to load user');
              }
            });
        }
        return null;
      });
                     
              
    }



    Future<User?> createUser(Map<String, dynamic> parameters) async {  
          return await http.post(
              Uri.parse("${dotenv.env['api_base_url']}:${dotenv.env['api_base_port']}/api/users"),
              headers: <String, String>{
                'Content-Type': 'application/ld+json',
              },
              body: jsonEncode(parameters)
            ).then((response) async {

              if (response.statusCode == 201) {
                Map<String, dynamic> responseData = jsonDecode(response.body);
                return User(
                  id:responseData['id'],
                  email: responseData['email'].toLowerCase(),
                  firstName: responseData['firstName'],
                  lastName: responseData['lastName'],
                  gender: responseData['gender'],
                  birthDate: DateTime.parse(responseData['birthDate']),
                  profilePicture: responseData['profilePicture'],
                  weight: responseData['weight'].toDouble(),
                );  
              } 
              else {
                throw Exception('Failed to load user');
              }
            });
                     
    }




    Future<bool> authUser(String email, String password) async {
      Map<String, Object> userData;

      userData = {
        "email": email.toLowerCase(),
        "password": password,
      };
debugPrint("${dotenv.env['api_base_url']}:${dotenv.env['api_base_port']}/auth");
      return await http.post(
        Uri.parse("${dotenv.env['api_base_url']}:${dotenv.env['api_base_port']}/auth"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userData),
      ).then((response) async {
debugPrint('Response status: ${response.statusCode}');
debugPrint('Response body: ${response.body}');
debugPrint('Response body: ${response.headers}');

        if (response.statusCode == 200) {
          //String token = response['token'];
          Map<String, dynamic> responseData = jsonDecode(response.body);
          try {
            return await TokenStorage().saveToken(responseData['token']).then((response) async {
      debugPrint("test1");
              return true;
            });
          }
          catch(e){
      debugPrint("test2 ${e.toString()}");
            return false;
          }
        }
        else{
      debugPrint("test3 ");
      debugPrint(response.body);
          return false;
        } 
      })/*.catchError((error) {
      debugPrint("test4");
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
        return false;
      })*/;
    }

}

