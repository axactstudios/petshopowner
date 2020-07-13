import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:fluttertoast/fluttertoast.dart';

class UpdatePet extends StatefulWidget {
  UpdatePet({Key key}) : super(key: key);

  @override
  _UpdatePetState createState() => _UpdatePetState();
}

class _UpdatePetState extends State<UpdatePet> {
//  File imageFile;
//  String _uploadedFileURL;
//  String path1;
//  void _openImagePicker() async {
//    // ignore: deprecated_member_use
//    var pick = await ImagePicker.pickImage(source: ImageSource.gallery);
//    path1 = basename(pick.path);
//    setState(() {
//      print(' Attatchment- ${pick.path}');
//      imageFile = pick;
//      String fileName = basename(pick.path);
//
//      final StorageReference firebaseStorageRef =
//      FirebaseStorage.instance.ref().child(fileName);
//      final StorageUploadTask task = firebaseStorageRef.putFile(pick);
//      print(task.isSuccessful.toString());
//    });
//
//    String platformResponse;
//
//    try {
//      // ignore: deprecated_member_use
//      await ImagePicker.pickImage(source: ImageSource.gallery);
//      platformResponse = 'success';
//      showToast('Image was successfully uploaded', Colors.white);
//    } catch (error) {
//      showToast(error.toString(), Colors.white);
//    }
//
//    if (!mounted) return;
//    print(platformResponse);
//  }

  String fileType = '';
  File file;
  String fileName = '';
  String operationText = '';
  bool isUploaded = true;
  String result = '';
  String downUrl = '';

  void _uploadFile(File file, String filename) async {
    final FirebaseStorage _storage =
        FirebaseStorage(storageBucket: 'gs://jwm-ecommerce.appspot.com');

    StorageReference storageReference;
    storageReference = _storage.ref().child("Images/Categories/$filename");

    final StorageUploadTask uploadTask = storageReference.putFile(file);
    Fluttertoast.showToast(msg: 'Uploading...', gravity: ToastGravity.CENTER);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    print("URL is $url");
    Fluttertoast.showToast(
        msg: 'Upload Complete', gravity: ToastGravity.CENTER);
    setState(() {
      downUrl = url;
    });
  }

  Future filePicker(BuildContext context) async {
    try {
      file = await FilePicker.getFile(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg'],
      );
      setState(() {
        fileName = p.basename(file.path);
      });
      print(fileName);

      _uploadFile(file, fileName);
    } on PlatformException catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sorry...'),
              content: Text('Unsupported exception: $e'),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
    setState(() {
      print(fileName);
    });
  }

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
                  int price1 = int.parse(ageController.text);
                  if (_formKey.currentState.validate()) {
                    dbRef
                        .child(dropdownValue)
                        .child(nameController.text)
                        .update({
                      "Name": nameController.text,
                      "Price": '$price1',
                      "Quantity": quantity.text,
                      "ImageUrl": downUrl,
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
                      filePicker(context);
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
