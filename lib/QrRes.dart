import 'package:flutter/material.dart';
class QrRes extends StatefulWidget {
  final Map data;
  final String scan;
  final Map resultList;
  final int index;
  final String ip;
  QrRes({Key key, this.scan, this.data, this.resultList, this.index, this.ip})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _QrRes();
  }
}

class _QrRes extends State<QrRes> {
  String ip;
  @override
  Widget build(BuildContext context) {
    ip = "${widget.ip}";

    if ("${widget.scan}" == "true") {
      String img = "${widget.resultList["image"]}";
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("INFO"),
            backgroundColor: Color.fromRGBO(65, 92, 120, 1.0),
          ),
          body: new ListView.builder(
              itemCount: 1,
              itemBuilder: (BuildContext context, int i) {
                List item = "${widget.resultList["item_name"]}".split(":");

                return new Column(
                  children: <Widget>[
                    Card(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Text("Category: " +
                                "${widget.resultList["category"]}"),
                          ),
                          Image.network("$ip/Image?name=$img"),
                          Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    item[0],
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "Description:" + item[1],
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                    ),
                                  )
                                ],
                              )),
                          Text("Rs." + "${widget.resultList["price"]}"),
                        ],
                      ),
                    ),
                  ],
                );
              }));
    } else {
      String imgs = "${widget.data["image"]}";

      /*for(int i=0;i<("${widget.bytes}".length); i++){
        ;
    }*/

      //int indexed=int.parse("${widget.index}");

      //b.add("${widget.bytes[indexed]}") as Uint8List;
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("INFO"),
            backgroundColor: Color.fromRGBO(65, 92, 120, 1.0),
          ),
          body: new ListView.builder(
              itemCount: 1,
              itemBuilder: (BuildContext context, int i) {
                List item = "${widget.data["item_name"]}".split(":");
                return new Column(
                  children: <Widget>[
                    Card(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Text(
                                "Category: " + "${widget.data["category"]}"),
                          ),
                          Image.network("$ip/Image?name=$imgs"),
                          Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    item[0],
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "Description: " + item[1],
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              )),
                          Text("Rs." + "${widget.data["price"]}"),
                        ],
                      ),
                    ),
                  ],
                );
              }));
    }
  }
}
