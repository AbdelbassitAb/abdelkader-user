
import 'package:abdelkader_user/constants/color.dart';
import 'package:abdelkader_user/models/transactions.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';

class Transaction_Card extends StatefulWidget {
  Transaction_Card({Key key, this.data}) : super(key: key);

  final TR data;

  @override
  _Transaction_CardState createState() => _Transaction_CardState();
}

class _Transaction_CardState extends State<Transaction_Card>
    with AfterLayoutMixin<Transaction_Card> {
  @override
  void afterFirstLayout(BuildContext context) {
    // Calling the same function "after layout" to resolve the issue.
    _getSizes();
  }

  _getSizes() {
    final RenderBox renderBoxRed = _key.currentContext.findRenderObject();
    final size = renderBoxRed.size;

   // widthTeeth = size.width;
    setState(() {
      containerHeight = size.height;
    });
  }

  double containerHeight;
  GlobalKey _key = GlobalKey();


  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * 0.2,
                    ),
                    height: containerHeight,
                    padding: EdgeInsets.all(10),
                    // height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          this.widget.data.name,
                          style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          this.widget.data.somme.toString() + ' Da',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  )),

              Expanded(
                flex: 2,
                child: Container(
                  key: _key,
                  padding: EdgeInsets.all(10),
                  //height: MediaQuery.of(context).size.height * 0.3,
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          this.widget.data.description ,
                          style: TextStyle( fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                     if(this.widget.data.workerName != '') Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            color: primaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            this.widget.data.workerName,
                            style: TextStyle(fontSize: 16,color: Colors.black.withOpacity(0.6)),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      if(this.widget.data.type != '') Row(
                        children: [
                          Icon(
                            Icons.list,
                            color: primaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            this.widget.data.type,
                            style: TextStyle(fontSize: 16,color: Colors.black.withOpacity(0.6)),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      if(this.widget.data.chantier != '') Row(
                        children: [
                          Icon(
                            Icons.place_outlined,
                            color: primaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            this.widget.data.chantier,
                            style: TextStyle(fontSize: 16,color: Colors.black.withOpacity(0.6)),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_outlined,
                            color: primaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            this.widget.data.time,
                            style: TextStyle(fontSize: 16,color: Colors.black.withOpacity(0.6)),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }
}
