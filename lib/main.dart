import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Shop Owner',
      home: MyStatefulWidget(),
    );
  }
}

void showToast(message, Color color) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 2,
    backgroundColor: color,
    textColor: Color(0xFF345995),
    fontSize: 16.0,
  );
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  String task = 'Register New Product';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 50),
        child: Row(
          children: <Widget>[
            NavigationRail(
              backgroundColor: Colors.black87,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                  if (_selectedIndex == 0) task = 'Register New Product';
                  if (_selectedIndex == 1) task = 'Update Product';
                  if (_selectedIndex == 2) task = 'Delete';
                  if (_selectedIndex == 3) task = 'Orders';
                });
              },
              labelType: NavigationRailLabelType.selected,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(
                    Icons.fiber_new,
                    color: Colors.white,
                    size: 30,
                  ),
                  selectedIcon: Icon(
                    Icons.fiber_new,
                    color: Colors.white,
                    size: 40,
                  ),
                  label: Text(
                    'New',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                NavigationRailDestination(
                  icon: Icon(
                    Icons.system_update_alt,
                    color: Colors.white,
                    size: 30,
                  ),
                  selectedIcon: Icon(
                    Icons.system_update_alt,
                    color: Colors.white,
                    size: 40,
                  ),
                  label: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                NavigationRailDestination(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                    size: 30,
                  ),
                  selectedIcon: Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 40,
                  ),
                  label: Text(
                    'Delete',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                NavigationRailDestination(
                  icon: Icon(
                    Icons.add_shopping_cart,
                    color: Colors.white,
                    size: 30,
                  ),
                  selectedIcon: Icon(
                    Icons.add_shopping_cart,
                    color: Colors.white,
                    size: 40,
                  ),
                  label: Text(
                    'Orders',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            VerticalDivider(thickness: 1, width: 1),
            // This is the main content.
            Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Pet Shop",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 30,
                          fontFamily: 'Roboto',
                        )),
                    Text("Owner Console",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 30,
                          fontFamily: 'Roboto',
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Text(task,
                        style: TextStyle(
                          fontWeight: FontWeight.w200,
                          fontSize: 28,
                          fontFamily: 'Roboto',
                        )),
                    if (_selectedIndex == 0)
                      RegisterPet()
                    else if (_selectedIndex == 1)
                      UpdatePet()
                    else if (_selectedIndex == 2)
                      Delete()
                    else if (_selectedIndex == 3)
                      Orders()
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterPet extends StatefulWidget {
  RegisterPet({Key key}) : super(key: key);

  @override
  _RegisterPetState createState() => _RegisterPetState();
}

class _RegisterPetState extends State<RegisterPet> {
  File imageFile;
  String _uploadedFileURL;
  String path1;
  void _openImagePicker() async {
    // ignore: deprecated_member_use
    File pick = await ImagePicker.pickImage(source: ImageSource.gallery);
    path1 = basename(pick.path);
    setState(() {
      String fileName = basename(pick.path);
      print(' Attatchment- ${pick.path}');
      imageFile = pick;
      final StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      final StorageUploadTask task = firebaseStorageRef.putFile(pick);
      print(task.isSuccessful.toString());
    });

    String platformResponse;

    try {
      // ignore: deprecated_member_use
      await ImagePicker.pickImage(source: ImageSource.gallery);
      platformResponse = 'success';
      showToast('Image was successfully uploaded', Colors.white);
    } catch (error) {
      platformResponse = error.toString();
      showToast(error.toString(), Colors.white);
    }

    if (!mounted) return;
    print(platformResponse);
  }

  final _formKey = GlobalKey<FormState>();
  final listOfCategories = [
    "Bakery",
    "Food",
    "Dairy",
    "Fruits",
    "Garden",
    "Meat",
    "Provisions",
    "Snacks",
    "Vegetables"
  ];
  String dropdownValue = 'Fruits';
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final quantity = TextEditingController();
  final dbRef = FirebaseDatabase.instance.reference();
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Enter Product Name",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter Product Name';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: DropdownButtonFormField(
              value: dropdownValue,
              icon: Icon(Icons.arrow_downward),
              decoration: InputDecoration(
                labelText: "Select Category",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              items: listOfCategories.map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please Select Categpry';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: ageController,
              decoration: InputDecoration(
                labelText: "Enter product price",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter product price';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: quantity,
              decoration: InputDecoration(
                labelText: "Enter quantity",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter quantity';
                }
                return null;
              },
            ),
          ),
          Padding(
              padding: EdgeInsets.all(20.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: Colors.black)),
                color: Colors.black87,
                onPressed: () {
                  final StorageReference firebaseStorageRef =
                      FirebaseStorage.instance.ref().child(path1);
                  firebaseStorageRef.getDownloadURL().then((fileURL) {
                    setState(() {
                      _uploadedFileURL = fileURL;
                    });
                  });
                  int price1 = int.parse(ageController.text);
                  if (_formKey.currentState.validate()) {
                    dbRef.child(dropdownValue).child(nameController.text).set({
                      "Name": nameController.text,
                      "Price": price1,
                      "Quantity": quantity.text,
                      "ImageUrl": _uploadedFileURL,
                    }).then((_) {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Successfully Added')));
                      ageController.clear();
                      nameController.clear();
                      quantity.clear();
                    }).catchError((onError) {
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text(onError)));
                    });
                  }
                },
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              )),
          Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Colors.black)),
                    color: Colors.black87,
                    onPressed: () {
                      _openImagePicker();
                    },
                    child: Text(
                      'Upload Image',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )),
        ])));
  }

  @override
  void dispose() {
    super.dispose();
    ageController.dispose();
    nameController.dispose();
    quantity.dispose();
  }
}

class UpdatePet extends StatefulWidget {
  UpdatePet({Key key}) : super(key: key);

  @override
  _UpdatePetState createState() => _UpdatePetState();
}

class _UpdatePetState extends State<UpdatePet> {
  File imageFile;
  String _uploadedFileURL;
  String path1;
  void _openImagePicker() async {
    // ignore: deprecated_member_use
    var pick = await ImagePicker.pickImage(source: ImageSource.gallery);
    path1 = basename(pick.path);
    setState(() {
      print(' Attatchment- ${pick.path}');
      imageFile = pick;
      String fileName = basename(pick.path);

      final StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      final StorageUploadTask task = firebaseStorageRef.putFile(pick);
      print(task.isSuccessful.toString());
    });

    String platformResponse;

    try {
      // ignore: deprecated_member_use
      await ImagePicker.pickImage(source: ImageSource.gallery);
      platformResponse = 'success';
      showToast('Image was successfully uploaded', Colors.white);
    } catch (error) {
      showToast(error.toString(), Colors.white);
    }

    if (!mounted) return;
    print(platformResponse);
  }

  final _formKey = GlobalKey<FormState>();
  final listOfCategories = [
    "Bakery",
    "Food",
    "Dairy",
    "Fruits",
    "Garden",
    "Meat",
    "Provisions",
    "Snacks",
    "Vegetables"
  ];
  String dropdownValue = 'Fruits';
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final quantity = TextEditingController();
  final dbRef = FirebaseDatabase.instance.reference();
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Enter Product Name",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter Product Name';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: DropdownButtonFormField(
              value: dropdownValue,
              icon: Icon(Icons.arrow_downward),
              decoration: InputDecoration(
                labelText: "Select Category",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              items: listOfCategories.map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please Select Category';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: ageController,
              decoration: InputDecoration(
                labelText: "Enter product price",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter product price';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: quantity,
              decoration: InputDecoration(
                labelText: "Enter quantity",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter quantity';
                }
                return null;
              },
            ),
          ),
          Padding(
              padding: EdgeInsets.all(20.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: Colors.black)),
                color: Colors.black87,
                onPressed: () {
                  final StorageReference firebaseStorageRef =
                      FirebaseStorage.instance.ref().child(path1);
                  firebaseStorageRef.getDownloadURL().then((fileURL) {
                    setState(() {
                      _uploadedFileURL = fileURL;
                    });
                  });
                  int price1 = int.parse(ageController.text);
                  if (_formKey.currentState.validate()) {
                    dbRef
                        .child(dropdownValue)
                        .child(nameController.text)
                        .update({
                      "Name": nameController.text,
                      "Price": price1,
                      "Quantity": quantity.text,
                      "ImageUrl": _uploadedFileURL,
                    }).then((_) {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Successfully Added')));
                      ageController.clear();
                      nameController.clear();
                      quantity.clear();
                    }).catchError((onError) {
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text(onError)));
                    });
                  }
                },
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              )),
          Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Colors.black)),
                    color: Colors.black87,
                    onPressed: () {
                      _openImagePicker();
                    },
                    child: Text(
                      'Upload Image',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )),
        ])));
  }

  @override
  void dispose() {
    super.dispose();
    ageController.dispose();
    nameController.dispose();
    quantity.dispose();
  }
}

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

int i = 0;

List<Container> currOrdersCard = [];
List<Container> pastOrdersCard = [];

List<OrderItem> pastOrders = [];
List<OrderItem> currOrders = [];
String t;
String globalNumber;
String globalKey;

class _OrdersState extends State<Orders> {
  DateTime now = DateTime.now();
  String formattedDate(DateTime date) {
    DateFormat('dd-MM-yyyy  kk:mm').format(date);
  }

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
            print('Current order add');
          });
        } else if (DATA[key]['Status'] == 'Completed') {
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
    currOrders.clear();
    pastOrders.clear();
    getOrderList();
    setState(() {
      print('All orders updated');
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: <Widget>[
        Text(
          'Current Orders',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Container(
          height: (height / 2) - 125 - 12,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: currOrders.length,
            itemBuilder: (BuildContext context, index) {
              var item = currOrders[index];
              return Container(
                height: 355,
                margin: const EdgeInsets.all(7.0),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Date: ${item.dateTime}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Shipping Date: ${item.shippedTime}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Completed Date: ${item.completedTime}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Total Amount: ${item.orderAmount}',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Items ordered',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Qty ordered',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Container(
                        height: 85,
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
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      item.itemsQty[index].toString(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Order Status is Order ${item.status}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Customer\'s Phone No: ${item.phNo}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Customer Address: ${item.address}',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 37,
                      ),
                      InkWell(
                        onTap: () {
                          DatabaseReference ordersref = FirebaseDatabase
                              .instance
                              .reference()
                              .child('Orders')
                              .child(item.orderNumber);
                          item.shippedTime == "Shipped"
                              ? null
                              : ordersref.child(item.orderKey).update({
                                  "Status": "Shipped",
                                  "ShippedTime": DateFormat('dd-MM-yyyy kk:mm')
                                      .format(DateTime.now())
                                }).then((_) {
                                  showToast(
                                      'successfully updated', Colors.white);
                                }).catchError((onError) {
                                  showToast(onError.toString(), Colors.white);
                                });
                          ;
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black54,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Order shipped',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      InkWell(
                        onTap: () {
                          DatabaseReference ordersref = FirebaseDatabase
                              .instance
                              .reference()
                              .child('Orders')
                              .child(item.orderNumber);
                          print(item.orderNumber);
                          ordersref.child(item.orderKey).update({
                            "isCompleted": true,
                            "Status": "Completed",
                            "CompletedTime": DateFormat('dd-MM-yyyy kk:mm')
                                .format(DateTime.now())
                          }).then((_) {
                            showToast('successfully updated', Colors.white);
                          }).catchError((onError) {
                            showToast(onError.toString(), Colors.white);
                          });
                          ;
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Order completed',
                              style: TextStyle(
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
        Text(
          'Past Orders',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Container(
          height: (height / 2) - 125 - 12,
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
                        'Total Amount: ${item.orderAmount}',
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

// ignore: non_constant_identifier_names

class Delete extends StatefulWidget {
  Delete({Key key}) : super(key: key);

  @override
  _DeleteState createState() => _DeleteState();
}

class _DeleteState extends State<Delete> {
  String platformResponse;
  final nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final listOfCategories = [
    "Bakery",
    "Food",
    "Dairy",
    "Fruits",
    "Garden",
    "Meat",
    "Provisions",
    "Snacks",
    "Vegetables"
  ];
  String dropdownValue = 'Fruits';
  final dbRef = FirebaseDatabase.instance.reference();
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),
            child: DropdownButtonFormField(
              value: dropdownValue,
              icon: Icon(Icons.arrow_downward),
              decoration: InputDecoration(
                labelText: "Select Category",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              items: listOfCategories.map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please Select Category';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Enter Product Name",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter Product Name';
                }
                return null;
              },
            ),
          ),
          Padding(
              padding: EdgeInsets.all(20.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: Colors.black)),
                color: Colors.black87,
                onPressed: () {
                  if (_formKey.currentState.validate())
                    dbRef
                        .child(dropdownValue)
                        .child(nameController.text)
                        .remove()
                        .then((_) {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Deleted Successfully')));
                      nameController.clear();
                    }).catchError((onError) {
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text(onError)));
                    });
                },
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              )),
        ])));
  }
}

class OrderItem {
  bool isCompleted;
  int orderAmount;
  List<String> itemsName;
  List<int> itemsQty;
  String dateTime,
      completedTime,
      shippedTime,
      status,
      orderNumber,
      orderKey,
      address,
      phNo;

  OrderItem(
      {this.isCompleted,
      this.itemsName,
      this.itemsQty,
      this.orderAmount,
      this.dateTime,
      this.shippedTime,
      this.completedTime,
      this.status,
      this.orderNumber,
      this.orderKey});
}

class Order {
  List<OrderItem> d = [];
  Order(this.d);
}
