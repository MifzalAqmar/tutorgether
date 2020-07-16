import 'dart:convert';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'book.dart';
import 'user.dart';

class EditBook extends StatefulWidget {
  final User user;
  final Book book;

  const EditBook({Key key, this.user, this.book}) : super(key: key);

  @override
  _EditBookState createState() => _EditBookState();
}

class _EditBookState extends State<EditBook> {
  String server = "https://tutorgether.000webhostapp.com/TutorGether";
  TextEditingController bnameEditingController = new TextEditingController();
  TextEditingController priceEditingController = new TextEditingController();
  TextEditingController qtyEditingController = new TextEditingController();
  TextEditingController typeEditingController = new TextEditingController();
  double screenHeight, screenWidth;
  final focus0 = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  File _image;
  bool _takepicture = true;
  bool _takepicturelocal = false;
  String selectedType;
  List<String> listType = [
    "Philosophical",
    "Educational",
    "Fictional",
    "Sci-Fi",
    "Horror",
    "Other",
  ];

  @override
  void initState() {
    super.initState();
    print("edit Book");
    bnameEditingController.text = widget.book.name;
    priceEditingController.text = widget.book.price;
    qtyEditingController.text = widget.book.quantity;
    typeEditingController.text = widget.book.type;
    selectedType = widget.book.type;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Update Your Book'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            GestureDetector(
                onTap: _choose,
                child: Column(
                  children: [
                    Visibility(
                      visible: _takepicture,
                      child: Container(
                        height: screenHeight / 3,
                        width: screenWidth / 1.5,
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl:
                              server + "/bookimage/${widget.book.bid}.jpg",
                          placeholder: (context, url) =>
                              new CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                        ),
                      ),
                    ),
                    Visibility(
                        visible: _takepicturelocal,
                        child: Container(
                          height: screenHeight / 3,
                          width: screenWidth / 1.5,
                          decoration: BoxDecoration(
                            image: new DecorationImage(
                              colorFilter: new ColorFilter.mode(
                                  Colors.black.withOpacity(0.6),
                                  BlendMode.dstATop),
                              image: _image == null
                                  ? AssetImage('assets/images/phonecam.png')
                                  : FileImage(_image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )),
                  ],
                )),
            SizedBox(height: 6),
            Container(
                width: screenWidth / 1.2,
                //height: screenHeight / 2,
                child: Card(
                    elevation: 6,
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Table(
                                defaultColumnWidth: FlexColumnWidth(1.0),
                                children: [
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("Book ID",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ))),
                                    ),
                                    TableCell(
                                        child: Container(
                                      height: 30,
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text(
                                            " " + widget.book.bid,
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          )),
                                    )),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("Book Name",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 30,
                                        child: TextFormField(
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                            controller: bnameEditingController,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
                                            onFieldSubmitted: (v) {
                                              FocusScope.of(context)
                                                  .requestFocus(focus0);
                                            },
                                            decoration: new InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.all(5),
                                              fillColor: Colors.white,
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                borderSide: new BorderSide(),
                                              ),

                                              //fillColor: Colors.green
                                            )),
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("Price (RM)",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 30,
                                        child: TextFormField(
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                            controller: priceEditingController,
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            focusNode: focus0,
                                            onFieldSubmitted: (v) {
                                              FocusScope.of(context)
                                                  .requestFocus(focus1);
                                            },
                                            decoration: new InputDecoration(
                                              fillColor: Colors.white,
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                borderSide: new BorderSide(),
                                              ),
                                              //fillColor: Colors.green
                                            )),
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("Quantity",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 30,
                                        child: TextFormField(
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                            controller: qtyEditingController,
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            focusNode: focus1,
                                            onFieldSubmitted: (v) {
                                              FocusScope.of(context)
                                                  .requestFocus(focus2);
                                            },
                                            decoration: new InputDecoration(
                                              fillColor: Colors.white,
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                borderSide: new BorderSide(),
                                              ),
                                              //fillColor: Colors.green
                                            )),
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("Type",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 40,
                                        child: Container(
                                          height: 40,
                                          child: DropdownButton(
                                            //sorting dropdownoption
                                            hint: Text(
                                              'Type',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    101, 255, 218, 50),
                                              ),
                                            ), // Not necessary for Option 1
                                            value: selectedType,
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedType = newValue;
                                                print(selectedType);
                                              });
                                            },
                                            items: listType.map((selectedType) {
                                              return DropdownMenuItem(
                                                child: new Text(selectedType,
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            101,
                                                            255,
                                                            218,
                                                            50))),
                                                value: selectedType,
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                ]),
                            SizedBox(height: 3),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              minWidth: screenWidth / 1.5,
                              height: 40,
                              child: Text('Update Book'),
                              color: Colors.orange,
                              textColor: Colors.black,
                              elevation: 5,
                              onPressed: () => updateBookDialog(),
                            ),
                          ],
                        )))),
          ],
        )),
      ),
    );
  }

  void _choose() async {
    _image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 800, maxWidth: 800);
    _cropImage();
    setState(() {});
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
              ]
            : [
                CropAspectRatioPreset.square,
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {
        _takepicture = false;
        _takepicturelocal = true;
      });
    }
  }

  updateBookDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Update Book Id " + widget.book.bid,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content:
              new Text("Are you sure?", style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.orange,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                updateBook();
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.orange,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  updateBook() {
    if (bnameEditingController.text.length < 4) {
      Toast.show("Please enter book name", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (qtyEditingController.text.length < 1) {
      Toast.show("Please enter book quantity", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (priceEditingController.text.length < 1) {
      Toast.show("Please enter book price", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    double price = double.parse(priceEditingController.text);

    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Updating book...");
    pr.show();
    String base64Image;

    if (_image != null) {
      base64Image = base64Encode(_image.readAsBytesSync());
      http.post(server + "/php/update_book.php", body: {
        "bid": widget.book.bid,
        "bname": bnameEditingController.text,
        "quantity": qtyEditingController.text,
        "price": price.toStringAsFixed(2),
        "type": typeEditingController.text,
        "encoded_string": base64Image,
      }).then((res) {
        print(res.body);
        pr.dismiss();
        if (res.body == "success") {
          Toast.show("Update success", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          Navigator.of(context).pop();
        } else {
          Toast.show("Update failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
        pr.dismiss();
      });
    } else {
      http.post(server + "/php/update_book.php", body: {
        "bid": widget.book.bid,
        "bname": bnameEditingController.text,
        "quantity": qtyEditingController.text,
        "price": price.toStringAsFixed(2),
        "type": typeEditingController.text,
      }).then((res) {
        print(res.body);
        pr.dismiss();
        if (res.body == "success") {
          Toast.show("Update success", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          Navigator.of(context).pop();
        } else {
          Toast.show("Update failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
        pr.dismiss();
      });
    }
  }
}
