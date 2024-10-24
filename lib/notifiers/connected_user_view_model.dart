import 'package:flutter/material.dart';
import 'package:molibi_app/models/user.dart';



class ConnectedUserViewModel extends ChangeNotifier {
  
    UserService userService = UserService();
    late User? userProfil;
    bool needToUpdate = false;


    ConnectedUserViewModel() {
      userProfil = User(birthDate: DateTime.now());
    }

    updateConnectedUser() async {
      final Map<String, dynamic> parameters = {
            'firstName': userProfil?.firstName,
            'lastName': userProfil?.lastName,
            'email': userProfil?.email,
            'gender': userProfil?.gender,
            'birthDate': userProfil?.birthDate.toString(),
            'weight': userProfil?.weight,
            // Add more parameters as needed
          };
      if (needToUpdate) { 
        await userService.updateConnectedUser(parameters).then((response) async {
          needToUpdate = false;
        });      
      }
    }

    Future<bool> loadConnectedUser() async {
      try {
        final response = await userService.loadConnectedUser();
        if (response == null) {
          return false;
        } else {
          userProfil = response;
          notifyListeners();
          return true;
        }
      } catch (e) {
        return false;
      }   
    }

    createUser() async {
      final Map<String, dynamic> parameters = {
            'firstName': userProfil?.firstName,
            'lastName': userProfil?.lastName,
            'email': userProfil?.email,
            'plainPassword': userProfil?.password,
            'gender': userProfil?.gender,
            'birthDate': userProfil?.birthDate.toString(),
            'weight': userProfil?.weight,
          };
      String? passwordTemp = userProfil?.password;
      if (needToUpdate) { 
        await userService.createUser(parameters).then((response) async {

          userProfil=response;
          needToUpdate = false;         
          await authUser(userProfil!.email,passwordTemp!);
        });      
      }
    }

    Future<bool> authUser(String email, String password) async {
      return await userService.authUser(email, password).then((response) async {
        notifyListeners();
        return response;
      });      
    }




    User? get user => userProfil;

    void updateFirstName(String firstName) {
      userProfil?.firstName = firstName;
      needToUpdate = true;
      notifyListeners();
    }

    void updateLastName(String lastName) {
      userProfil?.lastName = lastName;
      needToUpdate = true;
      notifyListeners();
    }

    void updateEmail(String email) {
      userProfil?.email = email;
      needToUpdate = true;
      notifyListeners();
    }

    void updatePassword(String password) {
      userProfil?.password = password;
      needToUpdate = true;
      notifyListeners();
    }

    void updateGender(String gender) {
      userProfil?.gender = gender;
      needToUpdate = true;
      notifyListeners();
    }

    void updateBirthDate(DateTime birthDate) {
      userProfil?.birthDate = birthDate;
      needToUpdate = true;
      notifyListeners();
    }

    void updateWeight(double weight) {
      userProfil?.weight = weight;
      needToUpdate = true;
      notifyListeners();
    }
}
