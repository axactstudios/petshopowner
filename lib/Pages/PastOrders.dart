import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:petshopowner/Classes/OrderItem.dart';

import 'Orders.dart';

class PastOrders extends StatefulWidget {
  @override
  _PastOrdersState createState() => _PastOrdersState();
}

List<Container> currOrdersCard = [];
List<Container> pastOrdersCard = [];

List<OrderItem> pastOrders = [];
List<OrderItem> currOrders = [];
String t;
String globalNumber;
String globalKey;

class _PastOrdersState extends State<PastOrders> {
  void getOrderList() {
    DatabaseReference usersref =
        FirebaseDatabase.instance.reference().child('Orders');
    usersref.once().then((DataSnapshot snap) {
      // ignore: non_constant_identifier_names
      var KEYS = snap.value.keys;
      // ignore: non_constant_identifier_names

      for (var key in KEYS) {
        currOrdersCard.clear();
        pastOrdersCard.clear();
        globalNumber = key;
        getOrders(key);

        print("number read $key");
      }
    });
  }

  void getOrders(String number) {
    DatabaseReference ordersref =
        FirebaseDatabase.instance.reference().child('Orders').child(number);
    ordersref.once().then((DataSnapshot snap) {
      print('database of $number is read');
      // ignore: non_constant_identifier_names
      var KEYS = snap.value.keys;
      // ignore: non_constant_identifier_names
      var DATA = snap.value;

      for (var key in KEYS) {
        print('database of $number has $key');
        List<ListTile> currListTile = [];
        List<ListTile> pastListTile = [];

        globalKey = key;

        currListTile.clear();
        pastListTile.clear();
        //TODO: Change phone number
        if (DATA[key]['Status'] == 'Placed' ||
            DATA[key]['Status'] == 'Shipped') {
          print('database of $number has $key with status not complete');
          OrderItem newOrder = OrderItem();

          DatabaseReference addressref = FirebaseDatabase.instance
              .reference()
              .child('Users')
              .child(number);
          addressref.once().then((DataSnapshot snap) {
            // ignore: non_constant_identifier_names
            var DATA = snap.value;
            newOrder.address =
                DATA['Add1'] + ', ' + DATA['Add2'] + '-' + DATA['Zip'];
            newOrder.phNo = DATA['phNo'];
            setState(() {
              newOrder.phNo;
              newOrder.address;
            });
            print(newOrder.address);
          });

          newOrder.orderNumber = number;
          newOrder.orderKey = key;
          print(newOrder.orderNumber);
          print(newOrder.orderKey);
          newOrder.orderAmount = DATA[key]['orderAmount'];
          print(newOrder.orderAmount);
          newOrder.itemsName = List<String>.from(DATA[key]['itemsName']);
          newOrder.itemsQty = List<int>.from(DATA[key]['itemsQty']);
          newOrder.dateTime = DATA[key]['DateTime'];
          newOrder.completedTime = DATA[key]['CompletedTime'];
          newOrder.shippedTime = DATA[key]['ShippedTime'];
          newOrder.status = DATA[key]['Status'];

          currOrders.add(newOrder);
          setState(() {
            print('Current order added');
          });
        } else if (DATA[key]['isCompleted'] == true) {
          print('Order Length is ${DATA[key]['orderLength'].toString()}');
          OrderItem newOrder = OrderItem();

          newOrder.orderAmount = DATA[key]['orderAmount'];
          print(newOrder.orderAmount);
          newOrder.itemsName = List<String>.from(DATA[key]['itemsName']);
          newOrder.itemsQty = List<int>.from(DATA[key]['itemsQty']);
          newOrder.dateTime = DATA[key]['DateTime'];
          print(newOrder.dateTime);
          newOrder.completedTime = DATA[key]['CompletedTime'];
          print(newOrder.completedTime);
          newOrder.shippedTime = DATA[key]['ShippedTime'];
          newOrder.status = DATA[key]['Status'];
          print(newOrder.status);
          print(newOrder.shippedTime);
          print(newOrder.itemsQty);
          print(newOrder.itemsName);
          pastOrders.add(newOrder);
          setState(() {
            print('Past order added');
          });
        }
      }
    });
  }

  Order createOrder(List<OrderItem> d) {
    Order temp = new Order(d);
    return temp;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pastOrders.clear();
    getOrderList();
    print('Hello');
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: <Widget>[
        Text(
          'Past Orders',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Container(
          height: (height) - 125 - 97,
          child: ListView.builder(
            itemCount: pastOrders.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, index) {
              var item = pastOrders[index];
              return new Container(
                margin: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    border: Border()),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        'Date: ${item.dateTime}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Shipping Date: ${item.shippedTime}',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Completed Date: ${item.completedTime}',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Total Amount: ${item.orderAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Order Status is ${item.status}',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 20,
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
