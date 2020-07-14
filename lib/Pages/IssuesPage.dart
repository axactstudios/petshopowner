import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petshopowner/Classes/Constants.dart';
import 'package:petshopowner/Classes/Issues.dart';

import '../main.dart';

List<Issues> issueOrders = [];
String t;
String globalNumber;
String globalKey;

class IssuesPage extends StatefulWidget {
  @override
  _IssuesPageState createState() => _IssuesPageState();
}

class _IssuesPageState extends State<IssuesPage> {
  DateTime now = DateTime.now();
  String formattedDate(DateTime date) {
    DateFormat('dd-MM-yyyy  kk:mm').format(date);
  }

  void getIssuesList() {
    DatabaseReference usersref =
        FirebaseDatabase.instance.reference().child('Issues');
    usersref.once().then((DataSnapshot snap) {
      // ignore: non_constant_identifier_names
      var KEYS = snap.value.keys;
      // ignore: non_constant_identifier_names

      for (var key in KEYS) {
        globalNumber = key;
        getIssues(key);

        print("number read $key");
      }
    });
  }

  void getIssues(String number) {
    DatabaseReference ordersref =
        FirebaseDatabase.instance.reference().child('Issues').child(number);
    ordersref.once().then((DataSnapshot snap) {
      print('database of $number is read');
      // ignore: non_constant_identifier_names
      var KEYS = snap.value.keys;
      // ignore: non_constant_identifier_names
      var DATA = snap.value;

      for (var key in KEYS) {
        print('database of $number has $key');

        globalKey = key;
        //TODO: Change phone number
        if (DATA[key]['Status'] == 'Issue raised') {
          print('database of $number has $key with status issue raised');
          Issues newIssue = Issues();

          DatabaseReference addressref = FirebaseDatabase.instance
              .reference()
              .child('Users')
              .child(number);
          addressref.once().then((DataSnapshot snap) {
            // ignore: non_constant_identifier_names
            var DATA = snap.value;
            newIssue.address =
                DATA['Add1'] + ', ' + DATA['Add2'] + '-' + DATA['Zip'];
            newIssue.phNo = DATA['phNo'];
            setState(() {
              newIssue.phNo;
              newIssue.address;
            });
            print(newIssue.address);
          });

          newIssue.orderNumber = number;
          newIssue.orderKey = key;
          print(newIssue.orderNumber);
          print(newIssue.orderKey);
          newIssue.orderAmount = DATA[key]['orderAmount'];
          print(newIssue.orderAmount);
          newIssue.request = DATA[key]['Request'];
          newIssue.itemsName = List<String>.from(DATA[key]['itemsName']);
          newIssue.itemsQty = List<int>.from(DATA[key]['itemsQty']);
          newIssue.placedTime = DATA[key]['DateTime'];
          newIssue.completedTime = DATA[key]['CompletedTime'];
          newIssue.desc = DATA[key]['IssueDescription'];
          newIssue.status = DATA[key]['Status'];

          issueOrders.add(newIssue);
          setState(() {
            print('New issue added');
          });
        }
//        } else if (DATA[key]['isCompleted'] == true) {
//          print('Order Length is ${DATA[key]['orderLength'].toString()}');
//          OrderItem newOrder = OrderItem();
//
//          newOrder.orderAmount = DATA[key]['orderAmount'];
//          print(newOrder.orderAmount);
//          newOrder.itemsName = List<String>.from(DATA[key]['itemsName']);
//          newOrder.itemsQty = List<int>.from(DATA[key]['itemsQty']);
//          newOrder.dateTime = DATA[key]['DateTime'];
//          print(newOrder.dateTime);
//          newOrder.completedTime = DATA[key]['CompletedTime'];
//          print(newOrder.completedTime);
//          newOrder.shippedTime = DATA[key]['ShippedTime'];
//          newOrder.status = DATA[key]['Status'];
//          print(newOrder.status);
//          print(newOrder.shippedTime);
//          print(newOrder.itemsQty);
//          print(newOrder.itemsName);
//          pastOrders.add(newOrder);
//          setState(() {
//            print('Past order added');
//          });
//        }
      }
    });
  }

  @override
  void initState() {
    issueOrders.clear();
    getIssuesList();
    setState(() {
      print('All issues updated');
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: <Widget>[
        Container(
          height: (height) - 125 - 97,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: issueOrders.length,
            itemBuilder: (BuildContext context, index) {
              var item = issueOrders[index];
              return Container(
                height: height * 0.40,
                margin: const EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.75),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    border: Border()),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Date: ${item.placedTime}',
                        style:
                            TextStyle(fontFamily: 'Cabin', color: Colors.white),
                      ),
                      Text(
                        'Completion Date: ${item.completedTime}',
                        style:
                            TextStyle(fontFamily: 'Cabin', color: Colors.white),
                      ),
                      Text(
                        'Completed Date: ${item.completedTime}',
                        style:
                            TextStyle(fontFamily: 'Cabin', color: Colors.white),
                      ),
                      Text(
                        'Total Amount: ${item.orderAmount}',
                        style:
                            TextStyle(fontFamily: 'Cabin', color: Colors.white),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Items ordered',
                            style: TextStyle(
                                fontFamily: 'Cabin', color: Colors.white),
                          ),
                          Text(
                            'Qty ordered',
                            style: TextStyle(
                                fontFamily: 'Cabin', color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Container(
                        height: height * 0.07,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: item.itemsName.length,
                            itemBuilder: (context, index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      item.itemsName[index],
                                      style: TextStyle(
                                          fontFamily: 'Cabin',
                                          color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      item.itemsQty[index].toString(),
                                      style: TextStyle(
                                          fontFamily: 'Cabin',
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: height * 0.1,
                        child: Text(
                          'Issue Description: ${item.desc}',
                          style: TextStyle(
                              fontFamily: 'Cabin', color: Colors.white),
                        ),
                      ),
                      Text(
                        'Issue Status is ${item.status}',
                        style:
                            TextStyle(fontFamily: 'Cabin', color: Colors.white),
                      ),
                      Text(
                        'Customer\'s Phone No: ${item.phNo}',
                        style:
                            TextStyle(fontFamily: 'Cabin', color: Colors.white),
                      ),
                      Text(
                        'Customer Address: ${item.address}',
                        style:
                            TextStyle(fontFamily: 'Cabin', color: Colors.white),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      InkWell(
                        onTap: () {
                          DatabaseReference ordersref = FirebaseDatabase
                              .instance
                              .reference()
                              .child('Issues')
                              .child(item.orderNumber);
                          print(item.orderNumber);
                          ordersref.child(item.orderKey).update({
                            "isCompleted": true,
                            "Status": "Issue Solved"
                          }).then((_) {
                            showToast('Updated', Colors.white);
                          }).catchError((onError) {
                            showToast(onError.toString(), Colors.white);
                          });
                          ;
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Issue solved',
                              style: TextStyle(
                                  fontFamily: 'Cabin',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
