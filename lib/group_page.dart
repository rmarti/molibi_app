import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:molibi_app/models/group.dart';
import 'package:molibi_app/themes/theme_molibi.dart';
import 'package:molibi_app/notifiers/group_view_model.dart';
import 'package:molibi_app/widget/molibi_app_bar_transparent.dart';
import 'package:molibi_app/widget/molibi_challenge_card.dart';
import 'package:molibi_app/widget/molibi_primary_button.dart';
import 'package:provider/provider.dart';



class GroupPage extends StatefulWidget {

  const GroupPage(
    {
      super.key
    });

  @override
  State<GroupPage> createState() => GroupPageState();
}

class GroupPageState extends State<GroupPage> {


  @override
  Widget build(BuildContext context) {

    return Consumer<GroupViewModel>(
      builder: (context, viewModel, child) {
        return MolibiGroupPage(group:viewModel.group, groupViewModel: viewModel);
        //return MolibiMyGroupPage(group:viewModel.group, groupViewModel: viewModel);
      }
    );    
  }
}



class MolibiGroupPage extends StatelessWidget {

  final Group group;
  final GroupViewModel groupViewModel;

  const MolibiGroupPage({
    super.key,
    required this.group,
    required this.groupViewModel
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity, 
        child: CustomScrollView(
          slivers: <Widget>[
            MolibiAppBarTransparent(coverUrl:group.coverUrl),
            SliverList(
              delegate: SliverChildListDelegate( [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child:
                            Text(
                                group.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: MolibiThemeData.molibiGrey2,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold
                                )
                              ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppLocalizations.of(context)!.group_status_public),
                              Text(
                                // ignore: prefer_interpolation_to_compose_strings
                                "${group.memberList.length} "+AppLocalizations.of(context)!.group_members,
                                style: const TextStyle(
                                  color: MolibiThemeData.molibiGrey3,
                                  fontSize: 14.0
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.4,
                          child:
                            MolibiPrimaryButton(label: AppLocalizations.of(context)!.group_join, onPressed: ()=>{}),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),                    
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child:
                              Text(
                                AppLocalizations.of(context)!.group_description,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontSize:22,
                                  color:MolibiThemeData.molibiGrey2,
                                  fontWeight:FontWeight.bold,
                                  ),
                                ),
                          ),
                        ),                 
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child:
                              Text(
                                group.description,
                                textAlign: TextAlign.justify,
                                ),
                          ),
                        ),                                       
                        Container(
                          color: MolibiThemeData.molibiGrey4,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                            AppLocalizations.of(context)!.group_challenges,
                                            style: const TextStyle(
                                                fontSize:22,
                                                color:MolibiThemeData.molibiGrey2,
                                                fontWeight:FontWeight.bold,
                                              ),
                                            ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        AppLocalizations.of(context)!.group_challenges_view_all,
                                        style: const TextStyle(
                                          color: MolibiThemeData.molibiGrey3,
                                          fontSize: 14.0
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 270,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: group.challengeList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: MolibiChallengeCard(
                                        challenge: group.challengeList[index],
                                        status : "",
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),                                    
                        SizedBox(
                          height: 50.0, 
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                        AppLocalizations.of(context)!.group_members,
                                        style: const TextStyle(
                                            fontSize:22,
                                            color:MolibiThemeData.molibiGrey2,
                                            fontWeight:FontWeight.bold,
                                          ),
                                        ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  AppLocalizations.of(context)!.group_members_view_all,
                                  style: const TextStyle(
                                    color: MolibiThemeData.molibiGrey3,
                                    fontSize: 14.0
                                  ),
                                ),
                              )
                            ],
                          )
                        ), 
                        Row(
                            children: List.generate(group.memberList.length, (index) {
                              return  Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                          borderRadius: BorderRadius.circular(40.0), // You can adjust the radius as needed
                                          child: SizedBox(
                                            width: 40.0,
                                            height: 40.0,
                                            child: Image.network(
                                              group.memberList[index].profilePicture,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                              );
                            }),
                          ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.4,
                          child:
                              MolibiPrimaryButton(label: AppLocalizations.of(context)!.group_join, onPressed: ()=>{}),
                        ),
                        const SizedBox(
                            height: 5.0,
                          ), 
                      ],),
                    ),
                  ),
                
                ],
              ),
            ),
          ]
        ),
      )
    );
  }
}



















/*



class MolibiMyGroupPage extends StatefulWidget {

  final Group group;
  final GroupViewModel groupViewModel;

  const MolibiMyGroupPage({
    super.key,
    required this.group,
    required this.groupViewModel
  });

  @override
  State<MolibiMyGroupPage> createState() => _MolibiMyGroupPageState();
}

class _MolibiMyGroupPageState extends State<MolibiMyGroupPage> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
           
            MolibiAppBarTransparent(coverUrl:widget.group.coverUrl),
            SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(text: 'Onglet 1'),
                        Tab(text: 'Onglet 2'),
                      ],
                    ),
                  ],
                ),
              ]),
            ),
                   
        ],
        body:TabBarView(
              controller: _tabController,
              children: [
                ListView.builder(
                  padding: const EdgeInsets.all(0),
                  itemCount: widget.group.feedItemList.length,
                  itemBuilder: (context, index) {
                    return MolibiFeedItem(feedItem: widget.group.feedItemList[index]);
                  },
                ),
                GridView.builder(
                  padding: const EdgeInsets.all(0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 250, // Spécifiez ici la hauteur des éléments de la grille
                  ),
                  itemCount: widget.group.challengeList.length,
                  itemBuilder: (context, index) {
                    return MolibiChallengeCard(
                      challenge: widget.group.challengeList[index],
                      status:"",
                    );
                  },
                ),
              ],
            ),


      ),
    );
  }

  
}
*/

