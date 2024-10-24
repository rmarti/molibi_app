import 'package:flutter/material.dart';
import 'package:molibi_app/models/group.dart';
import 'package:molibi_app/notifiers/base_select_mixin.dart';



class GroupListViewModel extends ChangeNotifier  with  BaseSelectMixin {
  
    GroupService groupService = GroupService();
    List<Group> findGroupList = [];
    List<Group>? myGroupList = [];

    GroupListViewModel(){
      //findGroupList = groupService.fetchGroupList();
      //myGroupList = groupService.fetchMyGroupList(12);
    }


    void loadGroupConnectedUser() async  {
        myGroupList = await groupService.loadGroupConnectedUser().then((response) async {
          notifyListeners();
          return response;
        });      
    }

    void findGroupByQuery(String? param) async  {
        findGroupList = await groupService.findGroupByQuery(param).then((response) async {
          notifyListeners();
          return response;
        });      
    }


    Future<Group?> joinGroupConnectedUser(Group group) async  {
        final response = await groupService.joinGroupConnectedUser(group);
        
        if(response == null) {
          return null; 
        }
        else{          
          findGroupList.remove(group);
          myGroupList?.add(group);
          notifyListeners();
          return response;
        }
    }

    Future<Group?> quitGroupConnectedUser(Group group) async  {
        final response = await groupService.quitGroupConnectedUser(group);
        if(response == null) {
          return null; 
        }
        else{
          myGroupList?.remove(group);
          notifyListeners();
          return response;
        }  
    }




}
