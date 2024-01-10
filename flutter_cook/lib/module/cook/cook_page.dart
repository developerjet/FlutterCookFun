import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CookPage extends StatefulWidget {
  const CookPage({ Key? key }) : super(key: key);

  @override
  _CookPageState createState() => _CookPageState();
}

class _CookPageState extends State<CookPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("烹饪"));
  }
}