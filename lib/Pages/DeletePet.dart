import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:petshopowner/Classes/Constants.dart';

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
    "Food",
    "Bedding",
    "Bowls",
    "Bath Items",
    "Collar & Lashes",
    "Hair Care",
    "Tooth Care",
    "Toys"
  ];
  String dropdownValue = 'Food';
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
              icon: Icon(
                Icons.arrow_downward,
                color: kPrimaryColor,
              ),
              decoration: InputDecoration(
                labelText: "Select Category",
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: kPrimaryColor)),
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
                    borderSide: BorderSide(color: kPrimaryColor)),
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
                  side: BorderSide(color: kPrimaryColor),
                ),
                color: kPrimaryColor,
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
                  style: TextStyle(fontFamily: 'Cabin', color: Colors.white),
                ),
              )),
        ])));
  }
}
