import 'package:flutter/material.dart';
import 'package:molibi_app/notifiers/home_view_model.dart';
import 'package:molibi_app/widget/molibi_activity_bloc.dart';
import 'package:molibi_app/widget/molibi_feed_item.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();


  @override
  Widget build(BuildContext context) {


    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          body: CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              const SliverToBoxAdapter(
                child: MolibiActivityBloc(),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return MolibiFeedItem(feedItemIndex:index);
                  },
                  childCount: viewModel.feedItemList?.length,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}





