import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {},
                      child: TextField(
                        onTap: () {
                        Navigator.pushNamed(context, '/search');
                        },
                        readOnly: true,
                        style: const TextStyle(
                        fontSize: 15.0,
                      ),
                      textAlign: TextAlign.left,
                      cursorHeight: 20,
                      cursorWidth: 1,
                      obscureText: false,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search anime',
                        contentPadding: EdgeInsets.only(left: 10.0),
                        suffixIcon: Icon(
                          Icons.search_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ),);
  }
}
