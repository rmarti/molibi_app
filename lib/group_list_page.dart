import 'package:flutter/material.dart';
import 'package:molibi_app/constants/group_status.dart';
import 'package:molibi_app/themes/theme_molibi.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:molibi_app/notifiers/group_list_view_model.dart';
import 'package:molibi_app/widget/molibi_group_card.dart';
import 'package:provider/provider.dart';
import 'package:molibi_app/widget/molibi_search.dart';

class GrouplistePage extends StatefulWidget {
  const GrouplistePage({super.key});

  @override
  State<GrouplistePage> createState() => GrouplistePageState();
}

class GrouplistePageState extends State<GrouplistePage> {

  late ScrollController findGroupScrollController;
  late ScrollController myGroupScrollController;
  late GroupListViewModel groupListViewModel;

  @override
  void initState() {
    super.initState();
    findGroupScrollController = ScrollController();
    myGroupScrollController = ScrollController();
    groupListViewModel = Provider.of<GroupListViewModel>(context, listen: false);
    groupListViewModel.loadGroupConnectedUser();
    groupListViewModel.findGroupList;
  }

  
  @override
  void dispose() {
    findGroupScrollController.dispose();
    myGroupScrollController.dispose();
    super.dispose();
  }

  void searchHandler(String value) {
      groupListViewModel.findGroupByQuery(value);
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<GroupListViewModel>(
      builder: (context, viewModel, child) {
        return DefaultTabController(
          initialIndex: 1,
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              shape: const Border(
                bottom: BorderSide(
                  color: MolibiThemeData.molibiGreen1,
                  width: 1.0,
                ),
              ),
              automaticallyImplyLeading: false,
              toolbarHeight: 0.0,
              bottom: TabBar(
                tabs: <Widget>[
                  Tab(
                    text: AppLocalizations.of(context)!.group_app_bar_find,
                  ),
                  Tab(
                    text: AppLocalizations.of(context)!.group_app_bar_my_groups,
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                Container(
                  color: MolibiThemeData.molibiGrey4,
                  child: Column(
                    children: [
                      MolibiSearch(searchHandler: searchHandler),
                      Expanded(
                        child: GridView.builder(
                          controller: findGroupScrollController, // Utilisez un contrôleur distinct pour chaque onglet
                          padding: const EdgeInsets.all(10),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            mainAxisExtent: 250, // Spécifiez ici la hauteur des éléments de la grille
                          ),
                          itemCount: viewModel.findGroupList.length,
                          itemBuilder: (context, index) {
                            return MolibiGroupCard(
                              group: viewModel.findGroupList[index],
                              status: "",
                              viewModel:viewModel
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: MolibiThemeData.molibiGrey4,
                  child: GridView.builder(
                    controller: myGroupScrollController, 
                    padding: const EdgeInsets.all(10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      mainAxisExtent: 250, // Spécifiez ici la hauteur des éléments de la grille
                    ),
                    itemCount: viewModel.myGroupList!.length,
                    itemBuilder: (context, index) {
                      return MolibiGroupCard(
                        group: viewModel.myGroupList![index],
                        status: GroupStatus.member,
                        viewModel:viewModel
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


