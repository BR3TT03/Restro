import 'dart:io';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:hotel_automation/Cart.dart';
import 'package:hotel_automation/QrRes.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';

class Menu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Menu();
  }
}

class _Menu extends State<Menu> {
  
  String _scan, _value = "", a = "qr", scan = "false";
  var res;
  int id;
  List name, jsn;
  List items = new List();
  List bytes = new List();
  List<int> count = new List<int>();
  List<int> select = new List<int>();
  List item;
  int table_No =1;
  int counter = 0, d;
  String ip = "hotel-mgmt-api.herokuapp.com";
  //Data request to server
  //getData function
  Future<String> getData() async {
    


    http.Response response =
        await http.get(Uri.encodeFull("https://$ip/welcome"));

    this.setState(() {
      jsn = json.decode(response.body);
      item = jsn;
    });
    print(jsn);
  }

  @override
  void initState() {
        this.getData();
  }

  //Qr Scan
  Future<Map> _qr() async {
    scan = "true";
    _scan = await FlutterBarcodeScanner.scanBarcode("#004297", "Cancel", true);
    _value = _scan;
    item = _value.split("/");
    if (item.contains("KCC")) {
      a = item[1];
      table_No=int.parse(item[2]);
      print(table_No);
      http.Response response = await http.get("http://$ip/id?id=$a");
      res = await json.decode(response.body);
      return res;
    }
    //index = data[7]["price"];
  }

//App UI starts here...
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("KCC Restaurant"),
        backgroundColor: Color.fromRGBO(65, 92, 120, 1.0),
      ),
     body:   
      ListView.builder(
          itemCount: jsn == null ? 0 : jsn.length,
          itemBuilder: (BuildContext context, int index) {
            name = jsn[index]["item_name"].split(":");
            String img = jsn[index]["image"];
            count.add(1);
            select.add(0);
           
            return GestureDetector(
                //onTap:(){print(index.toString());},
                child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        d = index;
                        var route = MaterialPageRoute(
                          builder: (BuildContext context) => QrRes(
                            data: jsn[index],
                            ip: ip,
                            // index: d,
                          ),
                        );
                        Navigator.of(context).push(route);
                      },
                      splashColor: Colors.green.withAlpha(100),
                      child: Column(
                        children: <Widget>[
                          (Image.network("http://$ip/Image?name=$img")),
                          Padding(
                            padding: EdgeInsets.only(top: 4, bottom: 8),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  name[0],
                                ),
                                Text(
                                  "Rs. " + jsn[index]["price"].toString(),
                                ),
                                //Card's cart icon

                                InkWell(
                                  child: Badge(
                                    badgeContent:
                                        Icon(Icons.add_shopping_cart, size: 20),
                                    badgeColor: getColor(index),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      if (count[index] == 3) {
                                        select[index] = 0;
                                        count[index] = 1;
                                        items.remove(index);
                                        counter--;
                                      } else {
                                        select[index] = 1;
                                        count[index] = 3;
                                        items.add(index);
                                        counter++;
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ));
          }),
      //Buttons
      floatingActionButton: Stack(
        children: <Widget>[
          //Cart Button
          Padding(
            padding: EdgeInsets.only(right: 0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                heroTag: "btn1",
                backgroundColor: Color.fromRGBO(65, 92, 120, 1.0),
                onPressed: () {
                  var route = MaterialPageRoute(
                    builder: (BuildContext context) =>
                        Cart(data: items, v: counter, ip: ip, jsn: jsn, table_No: table_No),
                  );
                  Navigator.of(context).push(route);
                  /*Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Cart(order);
                  }));*/
                },
                child: Badge(
                  padding: EdgeInsets.all(4),
                  badgeColor: Colors.red,
                  shape: BadgeShape.square,
                  borderRadius: 15,
                  badgeContent: Text(
                    counter.toString(),
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  child: Icon(
                    Icons.add_shopping_cart,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            //QrScan Button
            padding: EdgeInsets.only(left: 30),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                backgroundColor: Color.fromRGBO(65, 92, 120, 1.0),
                heroTag: "btn2",
                onPressed: () {
                  Future<Map> values = _qr();
                  values.then((resultList) {
                    var route = MaterialPageRoute(
                      builder: (BuildContext context) =>
                          QrRes(scan: scan, resultList: resultList, ip: ip),
                    );
                    Navigator.of(context).push(route);
                  });
                },
                child: Icon(
                  Icons.camera_enhance,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color getColor(int index) {
    if (select[index] == 0) {
      return Colors.grey;
    } else
      return Colors.red;
  }

  ListView listView() {}
}
