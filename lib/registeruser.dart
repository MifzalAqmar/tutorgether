import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'loginpage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'loginpage.dart';

String pathAsset = 'assets/images/profilep.png';
File _image;
String urlUpload =
    "https://tutorgether.000webhostapp.com/TutorGether/php/registration.php";

final TextEditingController _namecontroller = TextEditingController();
final TextEditingController _emcontroller = TextEditingController();
final TextEditingController _passcontroller = TextEditingController();
final TextEditingController _phcontroller = TextEditingController();
GlobalKey<FormState> _key = new GlobalKey();
bool _isChecked = false;
String _email, _password, _phone, _name;

void main() => runApp(RegisterUser());

class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
  const RegisterUser({Key key, File image}) : super(key: key);
}

class _RegisterUserState extends State<RegisterUser> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('New User Registration'),
          backgroundColor: Colors.blueGrey,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: RegisterWidget(),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    _image = null;
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
    return Future.value(false);
  }
}

class RegisterWidget extends StatefulWidget {
  @override
  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _key,
        child: Column(
          children: <Widget>[
            GestureDetector(
                onTap: _choose,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: _image == null
                            ? AssetImage(pathAsset)
                            : FileImage(_image),
                        fit: BoxFit.fill,
                      )),
                )),
            Text('Tap on the image to set up your profile picture'),
            TextFormField(
              controller: _namecontroller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Name',
                icon: Icon(Icons.person),
              ),
              validator: _validateName,
            ),
            TextFormField(
              controller: _emcontroller,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                icon: Icon(Icons.email),
              ),
              validator: _isEmailValid,
            ),
            TextFormField(
              controller: _passcontroller,
              decoration: InputDecoration(
                  labelText: 'Password', icon: Icon(Icons.lock)),
              validator: _validatePassword,
              obscureText: true,
            ),
            TextFormField(
              controller: _phcontroller,
              keyboardType: TextInputType.phone,
              decoration:
                  InputDecoration(labelText: 'Phone', icon: Icon(Icons.phone)),
              validator: _phoneValidator,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Checkbox(
                  value: _isChecked,
                  onChanged: (bool value) {
                    _onChange(value);
                  },
                ),
                Text(
                  "By submitting this form, I hereby agree to TutorGether's ",
                  style: TextStyle(fontSize: 16),
                ),
                GestureDetector(
                    onTap: _showTerms,
                    child: Text(
                      'EULA',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ))
              ],
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              minWidth: 300,
              height: 50,
              child: Text('Register'),
              color: Colors.black,
              textColor: Colors.white,
              elevation: 15,
              onPressed: _onRegister,
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
                onTap: _onBackPress,
                child:
                    Text('Already Registered?', style: TextStyle(fontSize: 15))),
          ],
        ));
  }

  void _choose() async {
    _image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {});
    //file = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  void _onRegister() {
    print(_image.toString());
    uploadData();
  }

  void _onBackPress() {
    _image = null;
    print('onBackpress from RegisterUser');
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }

  void uploadData() {
    _name = _namecontroller.text;
    _email = _emcontroller.text;
    _password = _passcontroller.text;
    _phone = _phcontroller.text;

    if(_isChecked==false){
      Toast.show("Please accept EULA", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            "Register Account?",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: new Container(
            height: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Do you wish to continue with registration?")
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
                child: new Text("Yes"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _registerUser();
                }),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
                return;
              },
            ),
          ],
        );
      },
    );
  }

  void _registerUser() {
    if (_key.currentState.validate()) {
      http.post(urlUpload, body: {
        "name": _name,
        "email": _email,
        "password": _password,
        "phone": _phone,
      }).then((res) {
        if (res.body == "failed") {
          Toast.show("Registration failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        } else {
          Navigator.pop(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage()));
          Toast.show("Registration success", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
      });
    }
  }

  String _validateName(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Name is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Name must be a-z and A-Z";
    }
    return null;
  }

  String _isEmailValid(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  String _validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Password is Required";
    } else if (value.length != 8 && value.length < 8) {
      return "Password length must be 8 characters or more";
    } else if (!regExp.hasMatch(value)) {
      return "Password must be in combination of 1 lowercase, \n1 uppercase and 1 number";
    }
    return null;
  }

  String _phoneValidator(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Phone Number is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Phone Number must be in digit";
    } else if (value.length != 10 && value.length != 11) {
      return "Phone Number must be 10 - 11 digits";
    }
    return null;
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
    });
  }

  void _showTerms() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: new Text("End User License Agreement (EULA)"),
              content: new Container(
                  height: 600,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: RichText(
                            softWrap: true,
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                                text:
                                    "This End-User License Agreement is a legal agreement between you and TutorGether™. This EULA agreement governs your acquisition and use of our software (TUTORGETHER) directly from TutorGether™ or indirectly through a TutorGether™ authorized reseller or distributor (a Reseller).Please read this EULA agreement carefully before completing the installation process and using the TUTORGETHER software. It provides a license to use the TUTORGETHER software and contains warranty information and liability disclaimers. If you register for a free trial of the TUTORGETHER software, this EULA agreement will also govern that trial. By clicking accept or installing and/or using the TUTORGETHER software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement. If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement. This EULA agreement shall apply only to the Software supplied by TutorGether™ herewith regardless of whether other software is referred to or described herein. The terms also apply to any TutorGether™ updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply. TutorGether™ shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of TutorGether™. TutorGether™ reserves the right to grant licences to use the Software to third parties.")),
                      )
                    ],
                  )));
        });
  }
}
