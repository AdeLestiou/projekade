import 'package:flutter/material.dart';
import 'login.dart';
import 'package:flutter_application_ade/network/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'home.dart';

class Register extends StatefulWidget{
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register>{
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _secureText = true;
  //ingat kembali pada demonstrasi api register, membutuhkan field
  //name, email, password, password_confirmation
  //tambahkan password_confirmation
  String name, email, password, password_confirmation;

  showHide(){
    setState(() {
      _secureText = !_secureText;
    });
  }

  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xff151515),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 72),
          child: Column(
            children: [
              Card(
                elevation: 4.0,
                color: Colors.white10,
                margin: EdgeInsets.only(top: 86),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Register",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 18),
                        TextFormField(
                          cursorColor: Colors.blue,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "Full Name",
                          ),
                          validator: (nameValue){
                            if(nameValue.isEmpty){
                              return 'Please enter your full name';
                            }
                            name = nameValue;
                            return null;
                          }
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          cursorColor: Colors.blue,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "Email",
                          ),
                          validator: (emailValue){
                            if(emailValue.isEmpty){
                              return 'Please enter your email';
                            }
                            email = emailValue;
                            return null;
                          }
                        ),

                          // edit text  Password Confirmation
                        SizedBox(height: 12),
                        TextFormField(
                          cursorColor: Colors.blue,
                          keyboardType: TextInputType.text,
                          obscureText: _secureText,
                          decoration: InputDecoration(
                            hintText: "Password",
                            suffixIcon: IconButton(
                              onPressed: showHide,
                              icon: Icon(_secureText
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                          ),
                          validator: (passwordValue){
                            if(passwordValue.isEmpty){
                              return 'Please enter your password';
                            }
                            password= passwordValue;
                            return null;
                          }
                        ),


                       // edit text  Password Confirmation
                        SizedBox(height: 12),
                        TextFormField(
                          cursorColor: Colors.blue,
                          keyboardType: TextInputType.text,
                          obscureText: _secureText,
                          decoration: InputDecoration(
                            hintText: "Password Confirmation",
                            suffixIcon: IconButton(
                              onPressed: showHide,
                              icon: Icon(_secureText
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                          ),
                          validator: (passwordConfirmationValue){
                            if(passwordConfirmationValue.isEmpty){
                              return 'Please enter your password';
                            }
                            password_confirmation = passwordConfirmationValue;
                            return null;
                          }
                        ),

                        SizedBox(height: 12),
                        FlatButton(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            child: Text(
                              _isLoading? 'Proccessing..' : 'Register',
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          color: Colors.blueAccent,
                          disabledColor: Colors.grey,
                          shape: new RoundedRectangleBorder(
                              borderRadius:
                              new BorderRadius.circular(20.0)),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _register();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => Login()));
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _register() async{
    setState(() {
      _isLoading = true;
    });
    // untuk memanggil register api, perlu menambahkan password_confirmation
    var data = {
      'name' : name,
      'email' : email,
      'password' : password,
      'password_confirmation' : password_confirmation
    };

    // dibawah merupakan perintah untuk memanggil api register. perlu diperhatikan bahwa terdapat json respon success
    // kita cek, jika belum ada maka tambahkan
    var res = await Network().auth(data, '/register');
    var body = json.decode(res.body);
    if(body['success']){
      /**
       * karena pada pembuatan register kita, belum di desain untuk  mendapatkan token, maka perintah berikut bisa
       * kita hapus
       */
      // SharedPreferences localStorage = await SharedPreferences.getInstance();
      // localStorage.setString('token', json.encode(body['token']));
      // localStorage.setString('user', json.encode(body['user']));
      /**
       * skenario dari program ini adalah setelah register, akan menuju home (dengan mendapatkan token tentunya)
       * kita sesuaikan dengan api yang sudah kita buat, bahwa token akan diterima ketika kita melakukan login
       * oleh karena itu, setelah register, kita bisa arahkan menuju halaman login
       */
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Login()
          ),
      );
    }else{
      // ini digunakan jika terdapat kosong pada field atau hasil pengecekan atau validasi dari api menyatakan tidak sukses
      // lanjut home.dart
      if(body['message']['name'] != null){
        _showMsg(body['message']['name'][0].toString());
      }
      else if(body['message']['email'] != null){
        _showMsg(body['message']['email'][0].toString());
      }
      else if(body['message']['password'] != null){
        _showMsg(body['message']['password'][0].toString());
      }
    }

    setState(() {
      _isLoading = false;
    });
  }
}
