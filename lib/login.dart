import 'package:abc_2_1/apiservice.dart';
import 'package:abc_2_1/navigationbar.dart';
import 'package:connection_status_bar/connection_status_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return LoginW();
        } else if (constraints.maxWidth > 900 && constraints.maxWidth < 1200) {
          return Login();
        } else {
          return Login();
        }
      },
    );
  }
}

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _password = false;
  TabController? _tabController;
  late SharedPreferences prefs;
  Map<String, dynamic> data = {};
  ApiService apiService = ApiService();
  bool loginLoeader = false;
  final loginForm = GlobalKey<FormState>();

  TextEditingController sitename = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 768) {
        return Scaffold(
          body: Stack(
            children: [
              ListView(
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      child: Container(child: Image.asset('assets/logo.png'))),
                  Container(
                    margin: EdgeInsets.only(
                        top: 20, left: 20, right: 20, bottom: 10),
                    child: TextFormField(
                      controller: sitename,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Site Name',
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 10, left: 20, right: 20, bottom: 10),
                    child: TextFormField(
                      controller: password,
                      obscureText: !this._password,
                      style: TextStyle(
                        fontFamily: "Century Gothic",
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'Password',
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() => this._password = !this._password);
                          },
                          child: Icon(
                            _password ? Icons.visibility : Icons.visibility_off,
                            // Icons.remove_red_eye,
                            // size: 22,
                            color: this._password
                                ? Color.fromRGBO(55, 91, 70, 1)
                                : Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    margin: EdgeInsets.only(
                        top: 40, left: 20, right: 20, bottom: 10),
                    child: ElevatedButton(
                      onPressed: loginLoeader
                          ? null
                          : () async {
                              var error = 0;
                              if (error == 0 && sitename.text.isEmpty) {
                                ToastMsg(
                                  'sitename is required, Please enter sitename',
                                  15,
                                  Colors.red,
                                );
                                error = 1;
                              } else if (error == 0 && password.text.isEmpty) {
                                ToastMsg(
                                  'Password is required, Please enter password',
                                  15,
                                  Colors.red,
                                );
                                error = 1;
                              } else {
                                setState(() {
                                  loginLoeader = true;
                                });
                                var data = Map<String, dynamic>();
                                data['sitename'] = sitename.text;
                                data['password'] = password.text;
                                print(data);
                                var login = await apiService
                                    .postCallWithOutToken('users/login', data);
                                setState(() {
                                  loginLoeader = false;
                                });
                                if (login['success'] == 0) {
                                  ToastMsg(
                                    login['message'],
                                    15,
                                    Colors.red,
                                  );
                                } else {
                                  await prefs.setInt(
                                      'user_id', login['data']['id']);
                                  await prefs.setString(
                                      'sitename', login['data']['sitename']);
                                  await prefs.setInt(
                                      'type', login['data']['type']);
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Navigationbar()),
                                      (route) => false);
                                }
                              }
                            },
                      child: Text("Log in"),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      'Contact us ...',
                      style: TextStyle(
                          fontFamily: "Century Gothic", color: Colors.green),
                    ),
                  ),
                ],
              ),
              ConnectionStatusBars()
            ],
          ),
        );
      } else {
        return Scaffold(
          body: Stack(
            children: [
              ListView(
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      child: Container(child: Image.asset('assets/logo.png'))),
                  Container(
                    margin: EdgeInsets.only(
                        top: 20, left: 20, right: 20, bottom: 10),
                    child: TextFormField(
                      controller: sitename,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Site Name',
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 10, left: 20, right: 20, bottom: 10),
                    child: TextFormField(
                      controller: password,
                      obscureText: !this._password,
                      style: TextStyle(
                        fontFamily: "Century Gothic",
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'Password',
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() => this._password = !this._password);
                          },
                          child: Icon(
                            _password ? Icons.visibility : Icons.visibility_off,
                            // Icons.remove_red_eye,
                            // size: 22,
                            color: this._password
                                ? Color.fromRGBO(55, 91, 70, 1)
                                : Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    margin: EdgeInsets.only(
                        top: 40, left: 20, right: 20, bottom: 10),
                    child: ElevatedButton(
                      onPressed: loginLoeader
                          ? null
                          : () async {
                              var error = 0;
                              if (error == 0 && sitename.text.isEmpty) {
                                ToastMsg(
                                  'sitename is required, Please enter sitename',
                                  15,
                                  Colors.red,
                                );
                                error = 1;
                              } else if (error == 0 && password.text.isEmpty) {
                                ToastMsg(
                                  'Password is required, Please enter password',
                                  15,
                                  Colors.red,
                                );
                                error = 1;
                              } else {
                                setState(() {
                                  loginLoeader = true;
                                });
                                var data = Map<String, dynamic>();
                                data['sitename'] = sitename.text;
                                data['password'] = password.text;
                                print(data);
                                var login = await apiService
                                    .postCallWithOutToken('users/login', data);
                                setState(() {
                                  loginLoeader = false;
                                });
                                if (login['success'] == 0) {
                                  ToastMsg(
                                    login['message'],
                                    15,
                                    Colors.red,
                                  );
                                } else {
                                  await prefs.setInt(
                                      'user_id', login['data']['id']);
                                  await prefs.setString(
                                      'sitename', login['data']['sitename']);
                                  await prefs.setInt(
                                      'type', login['data']['type']);
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Navigationbar()),
                                      (route) => false);
                                }
                              }
                            },
                      child: Text("Log in"),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      'Contact us ...',
                      style: TextStyle(
                          fontFamily: "Century Gothic", color: Colors.green),
                    ),
                  ),
                ],
              ),
              ConnectionStatusBars()
            ],
          ),
        );
      }
    });
  }

  void ToastMsg(String msg, double fontsize, Color color) {
    ScaffoldMessenger.of(this.context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text("$msg"),
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}

class ConnectionStatusBars extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConnectionStatusBar(
      height: 300,
      color: Colors.white,
      title: Text(
        "Internet Connection is Not Found, Please Check Your Internet",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}

class LoginW extends StatefulWidget {
  LoginW({Key? key}) : super(key: key);

  @override
  State<LoginW> createState() => _LoginWState();
}

class _LoginWState extends State<LoginW> {
  bool _password = false;
  TabController? _tabController;
  late SharedPreferences prefs;
  Map<String, dynamic> data = {};
  ApiService apiService = ApiService();
  bool loginLoeader = false;
  final loginForm = GlobalKey<FormState>();

  TextEditingController sitename = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: Container(
              child: Image.asset('assets/logo.png'),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
            child: TextFormField(
              controller: sitename,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Site Name',
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
            child: TextFormField(
              controller: password,
              obscureText: !this._password,
              style: TextStyle(
                fontFamily: "Century Gothic",
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'Password',
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() => this._password = !this._password);
                  },
                  child: Icon(
                    _password ? Icons.visibility : Icons.visibility_off,
                    // Icons.remove_red_eye,
                    // size: 22,
                    color: this._password
                        ? Color.fromRGBO(55, 91, 70, 1)
                        : Colors.grey[700],
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 50,
            margin: EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 10),
            child: ElevatedButton(
              onPressed: loginLoeader
                  ? null
                  : () async {
                      var error = 0;
                      if (error == 0 && sitename.text.isEmpty) {
                        ToastMsg(
                          'sitename is required, Please enter sitename',
                          15,
                          Colors.red,
                        );
                        error = 1;
                      } else if (error == 0 && password.text.isEmpty) {
                        ToastMsg(
                          'Password is required, Please enter password',
                          15,
                          Colors.red,
                        );
                        error = 1;
                      } else {
                        setState(() {
                          loginLoeader = true;
                        });
                        var data = Map<String, dynamic>();
                        data['sitename'] = sitename.text;
                        data['password'] = password.text;
                        print(data);
                        var login = await apiService.postCallWithOutToken(
                            'users/login', data);
                        setState(() {
                          loginLoeader = false;
                        });
                        if (login['success'] == 0) {
                          ToastMsg(
                            login['message'],
                            15,
                            Colors.red,
                          );
                        } else {
                          await prefs.setInt('user_id', login['data']['id']);
                          await prefs.setString(
                              'sitename', login['data']['sitename']);
                          await prefs.setInt('type', login['data']['type']);

                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Navigationbar()),
                              (route) => false);
                        }
                      }
                    },
              child: Text("Log in"),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              'Contact us ...',
              style:
                  TextStyle(fontFamily: "Century Gothic", color: Colors.green),
            ),
          )
        ],
      ),
    );
  }

  void ToastMsg(String msg, double fontsize, Color color) {
    ScaffoldMessenger.of(this.context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text("$msg"),
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
