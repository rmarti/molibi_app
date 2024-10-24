import 'package:flutter/material.dart';
import 'package:molibi_app/constants/sport_type.dart';
import 'package:molibi_app/group_page.dart';
import 'package:molibi_app/models/group.dart';
import 'package:molibi_app/notifiers/group_list_view_model.dart';
import 'package:molibi_app/themes/theme_molibi.dart';
import 'package:molibi_app/notifiers/base_select_mixin.dart';
import 'package:molibi_app/notifiers/group_view_model.dart';
import 'package:molibi_app/widget/molibi_primary_button.dart';
import 'package:molibi_app/constants/group_status.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class MolibiGroupCard extends StatefulWidget {

  final Group group;
  final String status;
  final BaseSelectMixin viewModel;

  const MolibiGroupCard({
    super.key,
    required this.group,
    required this.status,
    required this.viewModel
  });

  @override
  State<MolibiGroupCard> createState() => _MolibiGroupCardState();
}

class _MolibiGroupCardState extends State<MolibiGroupCard> {
  void handleButtonActiontPress(BuildContext context,) {

    GroupListViewModel groupListViewModel = Provider.of<GroupListViewModel>(context, listen: false);
         
    if (widget.status == GroupStatus.member) {
      actionQuit(context,widget.group,groupListViewModel);
    }
    else if (widget.status == GroupStatus.waiting) {
      actionJoin(context,widget.group,groupListViewModel);
    }
    else {
      actionJoin(context,widget.group,groupListViewModel);
    }

  }

  void actionQuit(BuildContext context, Group group, GroupListViewModel groupListViewModel) async {
        final response = await groupListViewModel.quitGroupConnectedUser(group);
        if (!mounted) return;
        if(response == null) {
    //      Provider.of<NotificationNotifier>(context, listen: false).showInfoMessage(message: AppLocalizations.of(context)!.group_quit_error);
        }
        else{  
    //      Provider.of<NotificationNotifier>(context, listen: false).showInfoMessage(message: AppLocalizations.of(context)!.group_quit_success);
        }
 }

  void actionJoin(BuildContext context, Group group, GroupListViewModel groupListViewModel) async {
        final response = await groupListViewModel.joinGroupConnectedUser(group);   
        if (!mounted) return;
        if(response == null) {
    //      Provider.of<NotificationNotifier>(context, listen: false).showInfoMessage(message: AppLocalizations.of(context)!.group_join_error);
        }
        else{  
    //      Provider.of<NotificationNotifier>(context, listen: false).showInfoMessage(message: AppLocalizations.of(context)!.group_join_success);
        }
  }

  void handleOpenGroup(BuildContext context, int id) {
      
       final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FutureBuilder<Group>(
            future: groupViewModel.findGroup(id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Show a loading indicator while waiting for the challenge to load
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}'); // Show an error message if the challenge failed to load
              } else {
                return const GroupPage(); // Show the ChallengePage once the challenge has been loaded
              }
            },
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {

    String label = "";
    String urlLogo =  widget.group.urlLogo;

    if (widget.status == GroupStatus.member) {
      label=AppLocalizations.of(context)!.group_button_quit;
    }
    else if (widget.status == GroupStatus.waiting) {
      label=AppLocalizations.of(context)!.group_button_cancel;
    }
    else {
      label=AppLocalizations.of(context)!.group_button_join;
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(        
        borderRadius: BorderRadius.circular(10.0),
        color:MolibiThemeData.molibilight,
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => handleOpenGroup(context,widget.group.id),
                    child: Text(
                      widget.group.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height:5),
                  GestureDetector(
                    onTap: () => handleOpenGroup(context,widget.group.id),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0), // You can adjust the radius as needed
                      child: SizedBox(
                        width: 60.0,
                        height: 60.0,
                        child: Image.network(
                          urlLogo,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height:5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: widget.group.sportList.map((sport) {
                          return Icon(
                              AppSportType.getIconForSportType(sport),
                              color: MolibiThemeData.molibiGrey3,
                              size: 14.0
                            );
                        }).toList(),
                      ),
                      Text(
                        widget.group.member.toString(),
                        style: const TextStyle(
                          color: MolibiThemeData.molibiGrey3,
                          fontSize: 14.0
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height:10),
                  GestureDetector(                    
                    onTap: () => handleOpenGroup(context,widget.group.id),
                    child: Text(
                      widget.group.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            MolibiPrimaryButton(
              label: label,
              onPressed: () => handleButtonActiontPress(context),
            ),
          ],
        ),
      ),
    );
  }
}


