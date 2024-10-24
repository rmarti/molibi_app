import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapPage extends StatefulWidget {

  const MapPage({
    super.key,
  });

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {

  
  List<Marker> markers = [];
  List<Polyline> polylines = [];
  List<Polygon> polygons = [];



  @override
  void initState() {
      super.initState();
  }



  @override
  void dispose() {
    super.dispose();
  }
  
/*
haut gauche : 29.728425294,-57.212116832

bas droite : -29.736421082,57.234877015
*/
  @override
  Widget build(BuildContext context) {

    final LatLngBounds bounds = LatLngBounds(
      LatLng(-29.736421082,57.234877015), 
      LatLng(29.728425294,-57.212116832), 
    );

    return FlutterMap(
      
        mapController: MapController(),     
         
        
        options: MapOptions(
          initialCenter: const LatLng(3.55,-10.88), // Coordonnées de Paris
          initialZoom: 5.0,
          cameraConstraint: CameraConstraint.contain(
          bounds: bounds,
        ),
        ),
        children: [
          TileLayer(
            urlTemplate: "${dotenv.env['map_base_url']}:${dotenv.env['map_base_port']}/{z}/{x}/{y}.png",
            //subdomains: ['a', 'b', 'c'],
            userAgentPackageName: 'app.molibi', 
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: [
                  const LatLng(48.85747835480789,2.291033972530806),
                  const LatLng(48.85730849277844,2.29074703674089),
                  const LatLng(48.85713763870117,2.2905189141768947),
                  const LatLng(48.856985768217854,2.290370934971032),
                  const LatLng(48.8568002788211,2.290209185448478),
                  const LatLng(48.85657980362889,2.290073114545949),
                  const LatLng(48.85548213650024,2.289603173808167),
                  const LatLng(48.85509530020067,2.2894706722583416),
                  const LatLng(48.854960171578426,2.289287433438934),
                  const LatLng(48.85473606643362,2.2889478455882264),
                  const LatLng(48.8546386247809,2.288857698190136)
                  ],
                //points: [LatLng(30, 40), LatLng(20, 50), LatLng(25, 45)],
                color: Colors.red,
                strokeWidth: 25
              ),
              Polyline(
                points: [
                  const LatLng(48.85747835480789,2.291033972530806),
                  const LatLng(48.85730849277844,2.29074703674089),
                  const LatLng(48.85713763870117,2.2905189141768947),
                  const LatLng(48.856985768217854,2.290370934971032),
                  const LatLng(48.8568002788211,2.290209185448478),
                  const LatLng(48.85657980362889,2.290073114545949)
                  ],
                //points: [LatLng(30, 40), LatLng(20, 50), LatLng(25, 45)],
                color: Color.fromARGB(255, 43, 255, 0),
                strokeWidth: 15
              ),
            ],
          ),
        ],
      );

  }
}
