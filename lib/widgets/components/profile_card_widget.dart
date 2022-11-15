import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String avatar;
  final String bannerImage;
  const ProfileCard(
      {required this.name, required this.avatar, required this.bannerImage});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Stack(
        fit: StackFit.loose,
        alignment: Alignment.center,
        children: [
          Container(
              height: 150,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(bannerImage), fit: BoxFit.cover))),
          Container(
            height: 150,
            decoration: const BoxDecoration(color: Color.fromARGB(80, 7, 0, 0)),
          ),
          Column(
            children: [
              Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(avatar), fit: BoxFit.cover))),
              Text(
                name,
                style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(225, 255, 255, 255),
                    fontSize: 17.0),
              )
            ],
          ),
        ],
      ),
    );
  }
}
