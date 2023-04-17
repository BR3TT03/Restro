import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';


import './products.dart';

class ProductManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductManager();
  }
}

class _ProductManager extends State<ProductManager> {
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //getData();
    return Column(children:[ 
    /*FloatingActionButton(
      onPressed: () {
        setState(() {
          _products.add('Advance Food Tester');
        });
      },
      child: Icon(Icons.add_shopping_cart),

    ),*/
    
    //Products(data)
    ],);
  }
}
