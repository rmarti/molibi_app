import 'package:flutter/material.dart';
import 'package:molibi_app/challenge_page.dart';
import 'package:molibi_app/models/challenge.dart';
import 'package:molibi_app/notifiers/challenge_view_model.dart';
import 'package:molibi_app/notifiers/user_view_model.dart';
import 'package:molibi_app/themes/theme_molibi.dart';
import 'package:molibi_app/widget/molibi_feed_item.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {

  const UserPage({
    super.key,
    });

  @override
  State<UserPage> createState() => UserPageState();
}

class UserPageState extends State<UserPage> {


  late UserViewModel userViewModel;
  late ScrollController challengeScrollController;
  final _scrollController = ScrollController();

  @override
  void initState() {
    debugPrint("ici");
      challengeScrollController = ScrollController();
      userViewModel = Provider.of<UserViewModel>(context, listen: false);
      super.initState();
  }

  @override
  void dispose() {
    challengeScrollController.dispose();
    super.dispose();
  }
  
    
  void handleOpenChallenge(BuildContext context, int id) {  
    final challengeViewModel = Provider.of<ChallengeViewModel>(context, listen: false);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FutureBuilder<Challenge>(
          future: challengeViewModel.updateChallenge(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Show a loading indicator while waiting for the challenge to load
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}'); // Show an error message if the challenge failed to load
            } else {
              return const ChallengePage(); // Show the ChallengePage once the challenge has been loaded
            }
          },
        ),
      ),
    );
  }
    

  @override
  Widget build(BuildContext context) {

    return Consumer<UserViewModel>(
      builder: (context, viewModel, child) {

        double crossAxisSpacing = 10;
        int crossAxisCount = 4;
        double widthChallenge = (MediaQuery.of(context).size.width - crossAxisSpacing * (crossAxisCount - 1)) / crossAxisCount;


        if (viewModel.user == null) {
          return const CircularProgressIndicator();
        } else {
          return Scaffold(
            body: SafeArea(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: SafeArea(
                      child:Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min, 
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50.0),                                  
                                      child: SizedBox(
                                        width: 55.0,
                                        height: 55.0,
                                        child: Image.network(
                                          viewModel.user!.profilePicture,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          "${viewModel.user!.firstName} ${viewModel.user!.lastName}",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: MolibiThemeData.molibiGrey1,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold
                                          )
                                        ),
                                    ),
                                  ],
                                ),
                              ),
                              const Expanded(
                                flex: 1,
                                child: Text(
                                    "12345166 points",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: MolibiThemeData.molibiGrey2,
                                      fontSize: 8.0,
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children:[
                                Expanded(
                                  flex:2,
                                  child: Row(
                                    children: [
                                      const Text(
                                        "week",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: MolibiThemeData.molibiGreen1,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold
                                        )
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: MolibiThemeData.molibiGreen3,
                                          borderRadius: BorderRadius.circular(8.0), 
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "1253 pts",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: MolibiThemeData.molibiGreen1,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold
                                            )
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Expanded(
                                  flex:3,
                                  child: Text("Ici on aura un grpahique d'évolution",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: MolibiThemeData.molibiGrey2,
                                          fontSize: 8.0,
                                          fontWeight: FontWeight.bold
                                        )),
                                ),
                              ]
                            ),
                          ),
                          Container(     
                            height:  widthChallenge+20,             
                            color:MolibiThemeData.molibiGrey4,
                            child: GridView.builder(
                              controller: challengeScrollController, 
                              padding: const EdgeInsets.all(10),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: crossAxisSpacing,
                                mainAxisSpacing: 10,
                                mainAxisExtent: widthChallenge,
                              ),
                              itemCount: viewModel.user!.challenges.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () => handleOpenChallenge(context,viewModel.user!.challenges[index].id),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: SizedBox(
                                      width: widthChallenge,
                                      height: widthChallenge,
                                      child: Image.network(
                                        viewModel.user!.challenges[index].urlLogo,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                );
                              },
                            ),
                          )
                        ],
                      )
                    )
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return MolibiFeedItem(feedItemIndex: index);
                      },
                      childCount: viewModel.feedItemList?.length,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }
    );
  }
}
