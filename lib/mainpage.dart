import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'adminbook.dart';
import 'user.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'cartpage.dart';
import 'paymenthistorypage.dart';
import 'profilepage.dart';

class MainPage extends StatefulWidget {
  final User user;

  const MainPage({Key key, this.user}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  List bookdata;
  int curnumber = 1;
  double screenHeight, screenWidth;
  bool _visible = false;
  String curtype = "Recent";
  String cartquantity = "0";
  int quantity = 1;
  bool _isadmin = false;
  String titlecenter = "Loading books...";
  String server = "https://tutorgether.000webhostapp.com/TutorGether";

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadCartQuantity();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    if (widget.user.email == "admin@tutorgether.com") {
      _isadmin = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    TextEditingController _prdController = new TextEditingController();
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          drawer: mainDrawer(context),
          appBar: AppBar(
            title: Text(
              'Books List',
              style: TextStyle(
                color: Colors.black,
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
          body: RefreshIndicator(
              key: refreshKey,
              color: Colors.orange,
              onRefresh: () async {
                await refreshList();
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/mainpage2.jpg"),
                      fit: BoxFit.cover),
                ),
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
                                            onPressed: () =>
                                                _sortItem("Recent"),
                                            color: Colors.orange,
                                            padding: EdgeInsets.all(10.0),
                                            child: Column(
                                              children: <Widget>[
                                                Icon(MdiIcons.update,
                                                    color: Colors.black),
                                                Text(
                                                  "Recent",
                                                  style: TextStyle(
                                                      color: Colors.black),
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
                                            onPressed: () =>
                                                _sortItem("Philosophical"),
                                            color: Colors.orange,
                                            padding: EdgeInsets.all(10.0),
                                            child: Column(
                                              children: <Widget>[
                                                Icon(
                                                  MdiIcons.book,
                                                  color: Colors.black,
                                                ),
                                                Text(
                                                  "Philosophical",
                                                  style: TextStyle(
                                                      color: Colors.black),
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
                                            onPressed: () =>
                                                _sortItem("Educational"),
                                            color: Colors.orange,
                                            padding: EdgeInsets.all(10.0),
                                            child: Column(
                                              children: <Widget>[
                                                Icon(
                                                  MdiIcons.bookAccount,
                                                  color: Colors.black,
                                                ),
                                                Text(
                                                  "Educational",
                                                  style: TextStyle(
                                                      color: Colors.black),
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
                                            onPressed: () =>
                                                _sortItem("Fictional"),
                                            color: Colors.orange,
                                            padding: EdgeInsets.all(10.0),
                                            child: Column(
                                              children: <Widget>[
                                                Icon(
                                                  MdiIcons.bookAccountOutline,
                                                  color: Colors.black,
                                                ),
                                                Text(
                                                  "Fictional",
                                                  style: TextStyle(
                                                      color: Colors.black),
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
                                            onPressed: () =>
                                                _sortItem("Sci-Fi"),
                                            color: Colors.orange,
                                            padding: EdgeInsets.all(10.0),
                                            child: Column(
                                              children: <Widget>[
                                                Icon(
                                                  MdiIcons
                                                      .bookInformationVariant,
                                                  color: Colors.black,
                                                ),
                                                Text(
                                                  "Sci-Fi",
                                                  style: TextStyle(
                                                      color: Colors.black),
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
                                            onPressed: () => _sortItem("Other"),
                                            color: Colors.orange,
                                            padding: EdgeInsets.all(10.0),
                                            child: Column(
                                              children: <Widget>[
                                                Icon(
                                                  MdiIcons.ornament,
                                                  color: Colors.black,
                                                ),
                                                Text(
                                                  "Other",
                                                  style: TextStyle(
                                                      color: Colors.black),
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
                                        color: Colors.black,
                                      ),
                                      autofocus: false,
                                      controller: _prdController,
                                      decoration: InputDecoration(
                                          icon: Icon(
                                            Icons.search,
                                            color: Colors.orange,
                                          ),
                                          border: OutlineInputBorder())),
                                )),
                                Flexible(
                                    child: MaterialButton(
                                        color: Colors.orange,
                                        onPressed: () => {
                                              _sortItembyName(
                                                  _prdController.text)
                                            },
                                        elevation: 5,
                                        child: Text(
                                          "Search Book",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
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
                                childAspectRatio:
                                    (screenWidth / screenHeight) / 0.8,
                                children:
                                    List.generate(bookdata.length, (index) {
                                  return Container(
                                      child: Card(
                                          elevation: 10,
                                          child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap: () =>
                                                      _onImageDisplay(index),
                                                  child: Container(
                                                    height: screenHeight / 5.9,
                                                    width: screenWidth / 3.5,
                                                    child: ClipOval(
                                                        child:
                                                            CachedNetworkImage(
                                                      fit: BoxFit.fill,
                                                      imageUrl: server +
                                                          "/bookimage/${bookdata[index]['id']}.jpg",
                                                      placeholder: (context,
                                                              url) =>
                                                          new CircularProgressIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          new Icon(Icons.error),
                                                    )),
                                                  ),
                                                ),
                                                Text(bookdata[index]['name'],
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white)),
                                                Text(
                                                  "RM " +
                                                      bookdata[index]['price'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  "Quantity available:" +
                                                      bookdata[index]
                                                          ['quantity'],
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                MaterialButton(
                                                  color: Colors.orange,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0)),
                                                  minWidth: 100,
                                                  height: 30,
                                                  child: Text(
                                                    'Add to Cart',
                                                  ),
                                                  textColor: Colors.black,
                                                  elevation: 10,
                                                  onPressed: () =>
                                                      _addtocartdialog(index),
                                                ),
                                              ],
                                            ),
                                          )));
                                })))
                  ],
                ),
              )),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              if (widget.user.email == "unregistered@tutorgether.com") {
                Toast.show("Please register first.", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                return;
              } else if (widget.user.email == "admin@tutorgether.com") {
                Toast.show("In Admin mode.", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                return;
              } else if (widget.user.quantity == " 0") {
                Toast.show("Cart empty", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                return;
              } else {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => CartPage(
                              user: widget.user,
                            )));
                _loadData();
                _loadCartQuantity();
              }
            },
            icon: Icon(Icons.add_shopping_cart),
            label: Text(cartquantity),
          ),
        ));
  }

  _onImageDisplay(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: new Container(
              color: Colors.black,
              height: screenHeight / 2.2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      height: screenWidth / 1.5,
                      width: screenWidth / 1.5,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.scaleDown,
                              image: NetworkImage(server +
                                  "/bookimage/${bookdata[index]['id']}.jpg")))),
                ],
              ),
            ));
      },
    );
  }

  void _loadData() async {
    String urlLoadJobs = server + "/php/load_books.php";
    await http.post(urlLoadJobs, body: {}).then((res) {
      if (res.body == " nodata") {
        cartquantity = "0";
        titlecenter = "No book found";
        setState(() {
          bookdata = null;
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          bookdata = extractdata["books"];
          cartquantity = widget.user.quantity;
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _loadCartQuantity() async {
    String urlLoadJobs = server + "/php/load_cartquantity.php";
    await http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      if (res.body == " nodata") {
      } else {
        widget.user.quantity = res.body;
      }
    }).catchError((err) {
      print(err);
    });
  }

  Widget mainDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(widget.user.name),
            accountEmail: Text(widget.user.email),
            otherAccountsPictures: <Widget>[
              Text("RM " + widget.user.credit,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ],
            currentAccountPicture: CircleAvatar(
              backgroundColor:
                  Theme.of(context).platform == TargetPlatform.android
                      ? Colors.black
                      : Colors.black,
              child: Text(
                widget.user.name.toString().substring(0, 1).toUpperCase(),
                style: TextStyle(fontSize: 40.0),
              ),
              backgroundImage: NetworkImage(
                  server + "/profileimages/${widget.user.email}.jpg?"),
            ),
            onDetailsPressed: () => {
              Navigator.pop(context),
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ProfilePage(
                            user: widget.user,
                          )))
            },
          ),
          ListTile(
              title: Text(
                "Book List",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                    Navigator.pop(context),
                    _loadData(),
                  }),
          ListTile(
              title: Text(
                "Shopping Cart",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                    Navigator.pop(context),
                    gotoCart(),
                  }),
          ListTile(
              title: Text(
                "Payment History",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: _paymentPage),
          ListTile(
              title: Text(
                "User Profile",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                    Navigator.pop(context),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => ProfilePage(
                                  user: widget.user,
                                )))
                  }),
          Visibility(
            visible: _isadmin,
            child: Column(
              children: <Widget>[
                Divider(
                  height: 2,
                  color: Colors.black,
                ),
                Center(
                  child: Text(
                    "Admin Menu",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                    title: Text(
                      "My Books",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () => {
                          Navigator.pop(context),
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => AdminBook(
                                        user: widget.user,
                                      ))),
                        }),
              ],
            ),
          )
        ],
      ),
    );
  }

  _addtocartdialog(int index) {
    if (widget.user.email == "unregistered@tutorgether.com") {
      Toast.show("Please register first.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (widget.user.email == "admin@tutorgether.com") {
      Toast.show("In Admin mode.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    quantity = 1;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, newSetState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Add " + bookdata[index]['name'] + " to Cart?",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Select quantity of book",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () => {
                              newSetState(() {
                                if (quantity > 1) {
                                  quantity--;
                                }
                              })
                            },
                            child: Icon(
                              MdiIcons.minus,
                              color: Colors.orange,
                            ),
                          ),
                          Text(
                            quantity.toString(),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          FlatButton(
                            onPressed: () => {
                              newSetState(() {
                                if (quantity <
                                    (int.parse(bookdata[index]['quantity']) -
                                        2)) {
                                  quantity++;
                                } else {
                                  Toast.show("Quantity not available", context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                }
                              })
                            },
                            child: Icon(
                              MdiIcons.plus,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              actions: <Widget>[
                MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      _addtoCart(index);
                    },
                    child: Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.orange,
                      ),
                    )),
                MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.orange,
                      ),
                    )),
              ],
            );
          });
        });
  }

  void _addtoCart(int index) {
    if (widget.user.email == "unregistered@tutorgether.com") {
      Toast.show("Please register first.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (widget.user.email == "admin@tutorgether.com") {
      Toast.show("In Admin mode.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    try {
      int cquantity = int.parse(bookdata[index]["quantity"]);
      print(cquantity);
      print(bookdata[index]["id"]);
      print(widget.user.email);
      if (cquantity > 0) {
        ProgressDialog pr = new ProgressDialog(context,
            type: ProgressDialogType.Normal, isDismissible: true);
        pr.style(message: "Add to cart...");
        pr.show();
        String urlLoadJobs = server + "/php/insert_cart.php";
        http.post(urlLoadJobs, body: {
          "email": widget.user.email,
          "bkid": bookdata[index]["id"],
          "quantity": quantity.toString(),
        }).then((res) {
          print(res.body);
          if (res.body == " failed") {
            Toast.show("Failed add to cart", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            pr.dismiss();
            return;
          } else {
            List respond = res.body.split(",");
            setState(() {
              cartquantity = respond[1];
              widget.user.quantity = cartquantity;
            });
            Toast.show("Successfully added to cart", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
          pr.dismiss();
        }).catchError((err) {
          print(err);
          pr.dismiss();
        });
        pr.dismiss();
      } else {
        Toast.show("Out of stock", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } catch (e) {
      Toast.show("Failed add to cart", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
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
        if (res.body == " nodata") {
          setState(() {
            bookdata = null;
            curtype = type;
            titlecenter = "No book found";
          });
          pr.dismiss();
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
            if (res.body == " nodata") {
              Toast.show("Book not found", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              pr.dismiss();
              setState(() {
                titlecenter = "No book found";
                curtype = "search for " + "'" + bname + "'";
                bookdata = null;
              });
              FocusScope.of(context).requestFocus(new FocusNode());

              return;
            } else {
              setState(() {
                var extractdata = json.decode(res.body);
                bookdata = extractdata["books"];
                FocusScope.of(context).requestFocus(new FocusNode());
                curtype = "search for " + "'" + bname + "'";
                pr.dismiss();
              });
            }
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

  gotoCart() async {
    if (widget.user.email == "unregistered@tutorgether.com") {
      Toast.show("Please register first.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else if (widget.user.email == "admin@tutorgether.com") {
      Toast.show("In Admin mode.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else if (widget.user.quantity == " 0") {
      Toast.show("Cart empty", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => CartPage(
                    user: widget.user,
                  )));
      _loadData();
      _loadCartQuantity();
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text(
              'Are you sure?',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            content: new Text(
              'Do you want to exit?',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text(
                    "Exit",
                    style: TextStyle(
                      color: Colors.orange,
                    ),
                  )),
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.orange,
                    ),
                  )),
            ],
          ),
        ) ??
        false;
  }

  void _paymentPage() {
    if (widget.user.email == "unregistered@tutorgether.com") {
      Toast.show("Please register first.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else if (widget.user.email == "admin@tutorgether.com") {
      Toast.show("In Admin mode.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => PaymentHistoryPage(
                  user: widget.user,
                )));
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    _loadData();
    return null;
  }
}
