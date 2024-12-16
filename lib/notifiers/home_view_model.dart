import 'package:flutter/material.dart';
import 'package:molibi_app/models/feed_item.dart';



class HomeViewModel extends ChangeNotifier {
  
    List<FeedItem>? feedItemList = [];
    FeedItemService feedItemService = FeedItemService();

    HomeViewModel(){
      //feedItemList=feedItemService.fetchFeedItems(1234);
    }

    loadUserFeed(int user) async {
      List<FeedItem>? response = await feedItemService.loadUserFeedItems(user);
      try{        
        // ignore: unnecessary_null_comparison
        if (response == null) {
          return false;
        } else {
          feedItemList = response;
          notifyListeners();
          return true;
        } 
      }
      catch (e) {
        return false;
      }
    }

    void handleReaction(int index, String reaction, String action) {
      final reactionList = List<String>.from(feedItemList![index].reactionList);
      debugPrint(action);
      if ( action == "remove"){
        reactionList.remove(reaction);
        feedItemList![index].connectedUserReaction = "";
      }
      else if ( action == "add"){
        reactionList.add(reaction);
        feedItemList![index].connectedUserReaction = reaction;
      }
      feedItemList![index].reactionList = reactionList;
      notifyListeners();
    }



}
