
import 'package:flutter/material.dart';
import 'package:molibi_app/themes/theme_molibi.dart';
import 'package:molibi_app/notifiers/connected_user_view_model.dart';
import 'package:molibi_app/widget/molibi_header_menu.dart';
import 'package:provider/provider.dart';

class MolibiAppBarTransparent extends StatelessWidget implements PreferredSizeWidget {

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  final String coverUrl;

  const MolibiAppBarTransparent({
    super.key,
    this.coverUrl="",
  });



  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectedUserViewModel>(
      builder: (context, viewModel, child) { 
        return SliverAppBar(                  
          expandedHeight: 200.0,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Image.network(
              coverUrl,
              fit: BoxFit.cover,
            ),
          ),
          backgroundColor: MolibiThemeData.molibilight,         
          bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), 
            child: Container(
              color: MolibiThemeData.molibiGreen1, 
              height: 1.0, // Height of the border
            ),
          ),         
          actions: [
            MolibiHeaderMenu(context: context, viewModel: viewModel),
          ]
        );  
      }
    );    
  }
}