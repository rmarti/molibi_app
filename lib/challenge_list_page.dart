import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:molibi_app/constants/challenge_status.dart';
import 'package:molibi_app/themes/theme_molibi.dart';
import 'package:molibi_app/notifiers/challenge_list_view_model.dart';
import 'package:molibi_app/widget/molibi_challenge_card.dart';
import 'package:molibi_app/widget/molibi_search.dart';
import 'package:provider/provider.dart';

class ChallengelistePage extends StatefulWidget {
  const ChallengelistePage({super.key});

  @override
  State<ChallengelistePage> createState() => ChallengelistePageState();
}

class ChallengelistePageState extends State<ChallengelistePage> {


  late ScrollController findChallengeScrollController;
  late ScrollController myChallengeScrollController;
  late ChallengeListViewModel challengeListViewModel;

  @override
  void initState() {
    super.initState();
    findChallengeScrollController = ScrollController();
    myChallengeScrollController = ScrollController();
    challengeListViewModel = Provider.of<ChallengeListViewModel>(context, listen: false);
    challengeListViewModel.loadChallengeConnectedUser();
    challengeListViewModel.findChallengeList;
  }

  
  @override
  void dispose() {
    findChallengeScrollController.dispose();
    myChallengeScrollController.dispose();
    super.dispose();
  }

  void searchHandler(String value) {
      challengeListViewModel.findChallengeByQuery(value);
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<ChallengeListViewModel>(
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
                    text: AppLocalizations.of(context)!.challenge_app_bar_find,
                  ),
                  Tab(
                    text: AppLocalizations.of(context)!.challenge_app_bar_my_challenges,
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
                          controller: findChallengeScrollController, 
                          padding: const EdgeInsets.all(10),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            mainAxisExtent: 250, 
                          ),
                          itemCount: viewModel.findChallengeList.length,
                          itemBuilder: (context, index) {
                            return MolibiChallengeCard(
                              challenge: viewModel.findChallengeList[index],
                              status : ""
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
                    controller: myChallengeScrollController, 
                    padding: const EdgeInsets.all(10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      mainAxisExtent: 250, // Spécifiez ici la hauteur des éléments de la grille
                    ),
                    itemCount: viewModel.myChallengeList.length,
                    itemBuilder: (context, index) {
                      return MolibiChallengeCard(
                        challenge: viewModel.myChallengeList[index],
                        status :ChallengeStatus.member,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}


