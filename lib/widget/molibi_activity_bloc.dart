import 'package:flutter/material.dart';
import 'package:molibi_app/notifiers/activity_view_model.dart';
import 'package:molibi_app/themes/theme_molibi.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MolibiActivityBloc extends StatefulWidget {


  const MolibiActivityBloc({
    super.key,
    }
  );


  @override
  MolibiActivityBlocState createState() => MolibiActivityBlocState();
}

class MolibiActivityBlocState extends State<MolibiActivityBloc> with ActivityViewModel{
   

    @override
    void dispose() {
      super.dispose();
    }


    
    @override
    Widget build(BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            //width: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    MolibiThemeData.molibiGreen1,
                    MolibiThemeData.molibiGreen2,
                  ],
              ),    
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const SizedBox(
                      width: double.infinity,
                      child: Text("Daily", textAlign: TextAlign.right, style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: 
                            Row(
                              children: [
                                  SvgPicture.asset('assets/images/person-walking-solid.svg',
                                    alignment: Alignment.center,
                                    fit: BoxFit.fill,
                                    height:15,
                                    width:15,
                                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                  ),
                                  const SizedBox(width: 8),
                                  Text("$totalSteps pas", style: const TextStyle(color: Colors.white))
                              ]),
                        ),
                        Expanded(
                          child: 
                            Row(
                                children: [
                                  SvgPicture.asset('assets/images/location-arrow-solid.svg',
                                    alignment: Alignment.center,
                                    fit: BoxFit.fill,
                                    height:15,
                                    width:15,
                                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                  ),
                                  const SizedBox(width: 8),
                                  Text("${totalDistance?.toStringAsFixed(1)} m", style: const TextStyle(color: Colors.white))
                                ]),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: 
                            Row(
                              children: [
                                SvgPicture.asset('assets/images/fire-flame-curved-solid.svg',
                                  alignment: Alignment.center,
                                  fit: BoxFit.fill,
                                  height:15,
                                  width:15,
                                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                ),
                                const SizedBox(width: 8),
                                Text("$totalCalories Kcal", style: const TextStyle(color: Colors.white))
                              ])
                            
                        ),
                        const Expanded(
                          child: Text(" pts", style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
    }


}