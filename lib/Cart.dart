import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:http/http.dart' as http;

class Cart extends StatefulWidget {
  final List data;
  final int v;
  final List jsn;
  final int tableNo;
  final String ip;

  Cart({Key key, this.data, this.v, this.ip, this.jsn, this.tableNo})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Cart();
  }
}

class _Cart extends State<Cart> {
  String img;
  List qty = new List();
  List selected = new List();
  List total = new List();
  int totals = 0;
  int id;

  /*Future<int> getIntFromSharedPref() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
     List quantity;
     prefs.
     for(int i=0;i<int.parse("${widget.v}");i++)
     {
       quantity.add(qty[i]);
       print(quantity);
     }
  }*/
  Widget build(BuildContext context) {
    String ip = "${widget.ip}";
    int tableNo = int.parse("${widget.tableNo}");
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Cart",
          ),
          backgroundColor: Color.fromRGBO(65, 92, 120, 1.0),
          bottom: PreferredSize(
            child: Container(
              padding: EdgeInsets.only(bottom: 40),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 100),
                    child: Text(
                      "RS",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Text(
                    totals.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                    ),
                  ),
                ],
              ),
            ),
            preferredSize: Size.fromHeight(120),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ButtonTheme(
                minWidth: 200,
                child: ElevatedButton(
                  // splashColor: Colors.grey,
                  // elevation: 8,
                  // shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(30.0)),
                  // color: Color.fromRGBO(65, 92, 120, 1.0),
                  onPressed: () {
                    for (int i = 0; i < int.parse("${widget.v}"); i++) {
                      int ind = int.parse("${widget.data[i]}");
                      int id = int.parse("${widget.jsn[ind]["id"]}");
                      if (totals == 0 && i == 0) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            // return object of type Dialog
                            return AlertDialog(
                              title: new Text("Error"),
                              content: new Text(
                                  "Order quantity must be greater than zero"),
                              actions: <Widget>[
                                // usually buttons at the bottom of the dialog
                                new TextButton(
                                  child: new Text("Close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        if (qty[i] == 0) {
                        } else {
                          placeOrder(ip, tableNo, id, qty[i]);
                          print("posted");
                        }
                      }
                    }
                  },
                  child: Text(
                    "Place Order",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                )),
          ],
        )),
        body: new ListView.builder(
            itemCount: int.parse("${widget.v}"),
            itemBuilder: (BuildContext context, int index) {
              int length = int.parse("${widget.v}");
              int ind = int.parse("${widget.data[index]}");
              qty.add(0);
              img = "${widget.jsn[ind]["image"]}";
              List name = "${widget.jsn[ind]["item_name"]}".split(":");
              selected.add(0);
              total.add(0);
              //   print(selected[index].toString()+index.toString());
              return new Card(
                child: ListTile(
                  leading: Image.network("$ip/Image?name=$img",
                      height: 80, width: 80, fit: BoxFit.cover),
                  title: Text(name[0]),
                  trailing: Text(
                    "RS." + "${widget.jsn[ind]["price"]}",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.remove,
                          size: 18,
                        ),
                        onPressed: () {
                          print(index);
                          setState(() {
                            selected[index] = 2;
                            changeQty(index);
                            total[index] =
                                int.parse("${widget.jsn[ind]["price"]}") *
                                    qty[index];
                            totals = remTotal(total, length);
                          });
                        },
                      ),
                      badges.Badge(
                          badgeContent: Text(
                            qty[index].toString(),
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          badgeStyle: badges.BadgeStyle(
                            badgeColor: Colors.white,
                            shape: badges.BadgeShape.square,
                          )),
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          size: 18,
                        ),
                        onPressed: () {
                          setState(() {
                            selected[index] = 1;
                            changeQty(index);
                            total[index] =
                                int.parse("${widget.jsn[ind]["price"]}") *
                                    qty[index];
                            totals = remTotal(total, length);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            }));
  }

  Future placeOrder(String ip, int tableNo, int itemNo, int quantity) async {
    http.Response response = await http
        .get("$ip/tableNo?table_no=$tableNo&item_no=$itemNo&quantity=$quantity");
    return response;
  }

  int changeQty(int index) {
    if (selected[index] == 1) {
      return qty[index]++;
    } else {
      if (qty[index] == 0) {
        return qty[index];
      } else {
        return qty[index]--;
      }
    }
  }

  int remTotal(List total, int length) {
    int tot = 0;
    for (int i = 0; i < length; i++) {
      tot += total[i];
    }
    return tot;
  }
}
