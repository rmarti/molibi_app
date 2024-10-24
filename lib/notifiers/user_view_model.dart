import 'package:flutter/material.dart';
import 'package:molibi_app/models/feed_item.dart';
import 'package:molibi_app/models/user.dart';



class UserViewModel extends ChangeNotifier {
  
    UserService userService = UserService();
    late User? userLoad;

    List<FeedItem>? feedItemList = [];
    FeedItemService feedItemService = FeedItemService();


    userViewModel() {
      userLoad = User(birthDate: DateTime.now());
    }

    Future<bool> loadUser(int idUser) async {
      try {
        final response = await userService.loadUser(idUser);
        if (response == null) {
          return false;
        } else {
          userLoad = response;
          
          final responseFeed = await feedItemService.loadUserFeedItems(idUser);
          try{        
            // ignore: unnecessary_null_comparison
            if (responseFeed == null) {
              return false;
            } else {
              feedItemList = responseFeed;
              notifyListeners();
              return true;
            } 
          }
          catch (e) {
            return false;
          }  
        }
      } catch (e) {
        return false;
      }   
    }

    User? get user => userLoad;

}
