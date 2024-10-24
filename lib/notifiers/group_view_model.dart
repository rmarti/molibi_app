import 'package:flutter/material.dart';
import 'package:molibi_app/models/group.dart';
import 'package:molibi_app/notifiers/base_select_mixin.dart';



class GroupViewModel extends ChangeNotifier  with  BaseSelectMixin {
  
  GroupService groupService = GroupService();
  late Group group;

  GroupViewModel ();

  Future<Group> findGroup (int id) async  {
      return await groupService.findGroupById(id).then((response) async {
        notifyListeners();
        group = response;
        return response;
      });      
  }
 

}
