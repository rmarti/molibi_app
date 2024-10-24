import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:molibi_app/constants/reaction_type.dart';
import 'package:molibi_app/models/feed_item.dart';
import 'package:molibi_app/notifiers/home_view_model.dart';
import 'package:molibi_app/notifiers/notification_notifier.dart';
import 'package:molibi_app/notifiers/user_view_model.dart';
import 'package:molibi_app/themes/theme_molibi.dart';
import 'package:molibi_app/user_page.dart';
import 'package:provider/provider.dart';

class MolibiFeedItem extends StatelessWidget {

  final int feedItemIndex;
  
  const MolibiFeedItem({
    super.key,
    required this.feedItemIndex
  });

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);    
    final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);    

    FeedItem? feedItem = homeViewModel.feedItemList?[feedItemIndex];

    return Container(
      color:MolibiThemeData.molibiGrey4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height:70,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius:BorderRadius.only(
                          bottomRight: Radius.circular(20.0), 
                        ), 
                      ),
                    child: Container(
                      decoration: const BoxDecoration(
                          color: MolibiThemeData.molibilight,
                          borderRadius:BorderRadius.only(
                            topLeft: Radius.circular(40.0), 
                            topRight: Radius.circular(10.0), 
                            bottomLeft: Radius.circular(10.0), 
                          ),
                      ),                                    
                      child: Container(
                          width: 70.0,
                          height: 70.0,
                          decoration: const BoxDecoration(
                            color: MolibiThemeData.molibiGrey4,
                            borderRadius:BorderRadius.only(
                              bottomRight: Radius.circular(25.0), 
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10,bottom:10.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40.0),
                              child: SizedBox(
                                width: 60.0,
                                height: 60.0,
                                child: Image.network(
                                  feedItem!.user.profilePicture,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: MolibiThemeData.molibilight,
                        borderRadius:BorderRadius.only(
                          topLeft: Radius.circular(20.0), 
                          topRight: Radius.circular(20.0), 
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, bottom:8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                userViewModel.loadUser(feedItem.user.id).then((response) async {
                                  if (response == true){                               
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const UserPage()),
                                      );
                                  }
                                  else{
                                      Provider.of<NotificationNotifier>(context, listen: false).showErrorMessage(message: "test");              
                                  }
                                });
                              },
                              child: Text(
                                '${feedItem.user.firstName[0].toUpperCase()}${feedItem.user.firstName.substring(1)} ${feedItem.user.lastName[0].toUpperCase()}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: MolibiThemeData.molibiGrey1,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                right:8.0,
                              ),
                              child: Container(
                                width:double.infinity,
                                decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: MolibiThemeData.molibiGrey4,
                                        width: 1.0,
                                      )
                                    ),
                                ),
                                child : Text(
                                      DateFormat.yMd(Localizations.localeOf(context).toString()).format(feedItem.date),
                                      style: const TextStyle(
                                        fontSize: 8,
                                        color: MolibiThemeData.molibiGrey3,
                                      ),
                                    )
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width:double.infinity,
              decoration: const BoxDecoration(
                color: MolibiThemeData.molibilight,
                borderRadius:BorderRadius.only(
                  topLeft: Radius.circular(20.0), 
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                      feedItem.contentText
                    ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: MolibiThemeData.molibilight,
                borderRadius:BorderRadius.only(
                  bottomLeft: Radius.circular(20.0), 
                  bottomRight: Radius.circular(20.0), 
                ), 
                boxShadow: [
                  BoxShadow(
                    color: MolibiThemeData.molibiGrey3,
                    spreadRadius: 0,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(left:20.0, bottom:8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                        onTap: () {
                          feedItem.connectedUserReaction.isEmpty?
                          homeViewModel.handleReaction(feedItemIndex, ReactionType.like, "add"):
                          homeViewModel.handleReaction(feedItemIndex, ReactionType.like, "remove");
                        },child:Icon(
                          feedItem.connectedUserReaction == ReactionType.like ? Icons.favorite : Icons.favorite_border,
                          color: MolibiThemeData.molibiGreen2, 
                        )
                    ),
                    Text(
                      feedItem.reactionList.isEmpty ? "" : feedItem.reactionList.length.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: MolibiThemeData.molibiGrey3,
                      )
                    ),
                  ],
                ),//
              ),
            )
                                
                        
          ],
        ),
      ),
    );
  }
}