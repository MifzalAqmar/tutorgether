import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'editbook.dart';
import 'newbook.dart';
import 'book.dart';
import 'user.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'cartpage.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class AdminBook extends StatefulWidget {
  final User user;

  const AdminBook({Key key, this.user}) : super(key: key);

  @override
  _AdminBookState createState() => _AdminBookState();
}

class _AdminBookState extends State<AdminBook> {
  List bookdata;
  int curnumber = 1;
  double screenHeight, screenWidth;
  bool _visible = false;
  String curtype = "Recent";
  String cartquantity = "0";
  int quantity = 1;
  String titlecenter = "Loading books...";
  var _tapPosition;
  String server = "https://tutorgether.000webhostapp.com/TutorGether";
  String scanBId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    TextEditingController _prdController = new TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Your Books',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: _visible
                ? new Icon(Icons.expand_more)
                : new Icon(Icons.expand_less),
            onPressed: () {
              setState(() {
                if (_visible) {
                  _visible = false;
                } else {
                  _visible = true;
                }
              });
            },
          ),

          //
        ],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Visibility(
              visible: _visible,
              child: Card(
                  elevation: 10,
                  child: Padding(
                      padding: EdgeInsets.all(5),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () => _sortItem("Recent"),
                                    color: Colors.orange,
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(MdiIcons.update,
                                            color: Colors.black),
                                        Text(
                                          "Recent",
                                          style: TextStyle(color: Colors.black),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Column(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () => _sortItem("Philosophical"),
                                    color: Colors.orange,
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(
                                          MdiIcons.beer,
                                          color: Colors.black,
                                        ),
                                        Text(
                                          "Philosophical",
                                          style: TextStyle(color: Colors.black),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Column(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () => _sortItem("Educational"),
                                    color: Colors.orange,
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(
                                          MdiIcons.rice,
                                          color: Colors.black,
                                        ),
                                        Text(
                                          "Educational",
                                          style: TextStyle(color: Colors.black),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Column(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () => _sortItem("Fictional"),
                                    color: Colors.orange,
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(
                                          MdiIcons.foodVariant,
                                          color: Colors.black,
                                        ),
                                        Text(
                                          "Fictional",
                                          style: TextStyle(color: Colors.black),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Column(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () => _sortItem("Sci-Fi"),
                                    color: Colors.orange,
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(
                                          MdiIcons.bookInformationVariant,
                                          color: Colors.black,
                                        ),
                                        Text(
                                          "Sci-Fi",
                                          style: TextStyle(color: Colors.black),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Column(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () => _sortItem("Horror"),
                                    color: Colors.orange,
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(
                                          MdiIcons.bookMinus,
                                          color: Colors.black,
                                        ),
                                        Text(
                                          "Horror",
                                          style: TextStyle(color: Colors.black),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () => _sortItem("Other"),
                                    color: Colors.orange,
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(
                                          MdiIcons.ornament,
                                          color: Colors.black,
                                        ),
                                        Text(
                                          "Other",
                                          style: TextStyle(color: Colors.black),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ))),
            ),
            Visibility(
                visible: _visible,
                child: Card(
                  elevation: 5,
                  child: Container(
                    height: screenHeight / 12.5,
                    margin: EdgeInsets.fromLTRB(20, 2, 20, 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Flexible(
                            child: Container(
                          height: 30,
                          child: TextField(
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              autofocus: false,
                              controller: _prdController,
                              decoration: InputDecoration(
                                  icon: Icon(Icons.search),
                                  border: OutlineInputBorder())),
                        )),
                        Flexible(
                            child: MaterialButton(
                                color: Colors.orange,
                                onPressed: () =>
                                    {_sortItembyName(_prdController.text)},
                                elevation: 5,
                                child: Text(
                                  "Search Book",
                                  style: TextStyle(color: Colors.black),
                                )))
                      ],
                    ),
                  ),
                )),
            Text(curtype,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            bookdata == null
                ? Flexible(
                    child: Container(
                        child: Center(
                            child: Text(
                    titlecenter,
                    style: TextStyle(
                        color: Colors.orange,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ))))
                : Expanded(
                    child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: (screenWidth / screenHeight) / 0.65,
                        children: List.generate(bookdata.length, (index) {
                          return Container(
                              child: InkWell(
                                  onTap: () => _showPopupMenu(index),
                                  onTapDown: _storePosition,
                                  child: Card(
                                      elevation: 10,
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: screenHeight / 5.9,
                                              width: screenWidth / 3.5,
                                              child: ClipOval(
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.fill,
                                                  imageUrl: server +
                                                      "/bookimage/${bookdata[index]['id']}.jpg",
                                                  placeholder: (context, url) =>
                                                      new CircularProgressIndicator(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          new Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                            Text(bookdata[index]['name'],
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                            Text(
                                              "RM " + bookdata[index]['price'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              "Avail/Sold:" +
                                                  bookdata[index]['quantity'] +
                                                  "/" +
                                                  bookdata[index]['sold'],
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))));
                        })))
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
              child: Icon(Icons.new_releases),
              label: "New Book",
              labelBackgroundColor: Colors.white,
              onTap: createNewBook),
          SpeedDialChild(
              child: Icon(MdiIcons.barcodeScan),
              label: "Scan Book",
              labelBackgroundColor: Colors.white, //_changeLocality()
              onTap: () => scanBookDialog()),
          SpeedDialChild(
              child: Icon(Icons.report),
              label: "Book Report",
              labelBackgroundColor: Colors.white, //_changeLocality()
              onTap: () => null),
        ],
      ),
    );
  }

  void scanBookDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Select scan options:",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              MaterialButton(
                  color: Colors.orange,
                  onPressed: scanBarcodeNormal,
                  elevation: 5,
                  child: Text(
                    "Bar Code",
                    style: TextStyle(color: Colors.black),
                  )),
              MaterialButton(
                  color: Colors.orange,
                  onPressed: scanQR,
                  elevation: 5,
                  child: Text(
                    "QR Code",
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          ),
        );
      },
    );
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      if (barcodeScanRes == "-1") {
        scanBId = "";
      } else {
        scanBId = barcodeScanRes;
        Navigator.of(context).pop();
        _loadSingleBook(scanBId);
      }
    });
  }

  void _loadSingleBook(String bid) {
    String urlLoadJobs = server + "/php/load_books.php";
    http.post(urlLoadJobs, body: {
      "bid": bid,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        Toast.show("Not found", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          bookdata = extractdata["books"];
          print(bookdata);
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      if (barcodeScanRes == "-1") {
        scanBId = "";
      } else {
        scanBId = barcodeScanRes;
        Navigator.of(context).pop();
        _loadSingleBook(scanBId);
      }
    });
  }

  void _loadData() {
    String urlLoadJobs = server + "/php/load_books.php";
    http.post(urlLoadJobs, body: {}).then((res) {
      print(res.body);
      setState(() {
        var extractdata = json.decode(res.body);
        bookdata = extractdata["books"];
        cartquantity = widget.user.quantity;
      });
    }).catchError((err) {
      print(err);
    });
  }

  void _sortItem(String type) {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs = server + "/php/load_books.php";
      http.post(urlLoadJobs, body: {
        "type": type,
      }).then((res) {
        if (res.body == "nodata") {
          setState(() {
            curtype = type;
            titlecenter = "No book found";
            bookdata = null;
          });
          pr.dismiss();
          return;
        } else {
          setState(() {
            curtype = type;
            var extractdata = json.decode(res.body);
            bookdata = extractdata["books"];
            FocusScope.of(context).requestFocus(new FocusNode());
            pr.dismiss();
          });
        }
      }).catchError((err) {
        print(err);
        pr.dismiss();
      });
      pr.dismiss();
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _sortItembyName(String bname) {
    try {
      print(bname);
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs = server + "/php/load_books.php";
      http
          .post(urlLoadJobs, body: {
            "name": bname.toString(),
          })
          .timeout(const Duration(seconds: 4))
          .then((res) {
            if (res.body == "nodata") {
              Toast.show("Book not found", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              pr.dismiss();
              FocusScope.of(context).requestFocus(new FocusNode());
              return;
            }
            setState(() {
              var extractdata = json.decode(res.body);
              bookdata = extractdata["books"];
              FocusScope.of(context).requestFocus(new FocusNode());
              curtype = bname;
              pr.dismiss();
            });
          })
          .catchError((err) {
            pr.dismiss();
          });
      pr.dismiss();
    } on TimeoutException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } on SocketException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  gotoCart() {
    if (widget.user.email == "unregistered") {
      Toast.show("Please register to use...", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => CartPage(
                    user: widget.user,
                  )));
    }
  }

  _onBookDetail(int index) async {
    print(bookdata[index]['name']);
    Book book = new Book(
        bid: bookdata[index]['id'],
        name: bookdata[index]['name'],
        price: bookdata[index]['price'],
        quantity: bookdata[index]['quantity'],
        type: bookdata[index]['type'],
        date: bookdata[index]['date']);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => EditBook(
                  user: widget.user,
                  book: book,
                )));
    _loadData();
  }

  _showPopupMenu(int index) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    await showMenu(
      context: context,
      color: Colors.white,
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
      items: [
        //onLongPress: () => _showPopupMenu(), //onLongTapCard(index),

        PopupMenuItem(
          child: GestureDetector(
              onTap: () => {Navigator.of(context).pop(), _onBookDetail(index)},
              child: Text(
                "Update Book?",
                style: TextStyle(
                  color: Colors.black,
                ),
              )),
        ),
        PopupMenuItem(
          child: GestureDetector(
              onTap: () =>
                  {Navigator.of(context).pop(), _deleteBookDialog(index)},
              child: Text(
                "Delete Book?",
                style: TextStyle(color: Colors.black),
              )),
        ),
      ],
      elevation: 8.0,
    );
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  void _deleteBookDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Delete Book Id " + bookdata[index]['id'],
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
                _deleteBook(index);
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

  void _deleteBook(int index) {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Deleting book...");
    pr.show();
    String bid = bookdata[index]['id'];
    print("bid:" + bid);
    http.post(server + "/php/delete_book.php", body: {
      "bkid": bid,
    }).then((res) {
      print(res.body);
      pr.dismiss();
      if (res.body == " success") {
        Toast.show("Delete success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _loadData();
        Navigator.of(context).pop();
      } else {
        Toast.show("Delete failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
  }

  Future<void> createNewBook() async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => NewBook()));
    _loadData();
  }
}
