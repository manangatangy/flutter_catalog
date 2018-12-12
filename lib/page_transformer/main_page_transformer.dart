import 'package:flutter/material.dart';
import 'package:flutter_catalog/page_transformer/intro_page_view.dart';

void main() {
  runApp(PageTransformerDemoApp());
}

class PageTransformerDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PageTransformerDemoView(),
    );
  }
}