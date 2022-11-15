import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimerLoadingScreen extends StatelessWidget {
  int type;
  @override

  ShimerLoadingScreen({required this.type});
  Widget build(BuildContext context) {
    switch (type) {
      case 6:
        return
          animeCard(1, 2.7, context);
      default:
        return 
          animeCard(2, 1.4, context);
    }
  }

  Scaffold animeCard(perLine, scale, context) {
    return Scaffold(
        appBar: AppBar(
                    elevation: 0,
                    title: Container(
                      height: 33,
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: Theme.of(context).cardColor),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Shimmer.fromColors(
                        baseColor: Theme.of(context).cardColor,
                        highlightColor: Theme.of(context).shadowColor,
                        child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Theme.of(context).cardColor,
                        ),
                      ),),
                    ),
                  ),
        body: OrientationBuilder(builder: (context, orientation) {
                    orientation == Orientation.portrait ? 2 : 1;
                    return SafeArea(
                        child: Shimmer.fromColors(
                          baseColor: Theme.of(context).cardColor,
                          highlightColor: Theme.of(context).shadowColor,
                          child: GridView.count(
                              physics: const AlwaysScrollableScrollPhysics(),
                              childAspectRatio:
                                  MediaQuery.of(context).size.width /
                                      (MediaQuery.of(context).size.height / scale),
                              crossAxisCount: perLine,
                              crossAxisSpacing: 1,
                              mainAxisSpacing: 5,
                              children: List.generate(6, (context) {
                                return Card(
                                  margin: const EdgeInsets.only(left: 10, right: 10),
                                  semanticContainer: true,
                                  elevation: 0,
                                  color: Colors.grey[50],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                );
                              }),
                            ),));
                  }));
  }
}