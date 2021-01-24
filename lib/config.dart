library workoutcreator.config;

import 'package:flutter/material.dart';
import 'package:workoutcreator/main.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:launch_review/launch_review.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class Config {
  String gymType;
  List<String> gymTools;
  //Possible Tools:
  //barbell, dumbbell, pullupbar, cable, dipbars, flymachine, calisthenics

  Config(this.gymType);
  Config.withTools(this.gymType, this.gymTools);

  Map<String, dynamic> toJson() => {
        'gymType': gymType,
        'gymTools': gymTools,
      };
}

void saveConfig(Config config) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  final cName = "config.json";
  configExists().then((exists) {
    if (exists) {
      File cFile = File('$path/$cName');
      cFile.deleteSync();
      cFile.create();
      String json = jsonEncode(config);
      cFile.writeAsString(json);
    } else {
      File cFile = File("$path/$cName");
      String json = jsonEncode(config);
      cFile.writeAsString(json);
    }
  });
}

Future<Config> getConfig() async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  File cFile = File('$path/config.json');
  String json = await cFile.readAsString();
  var decoded = jsonDecode(json);
  String gymType = decoded['gymType'];
  List<String> gymTools = [];
  List t = decoded['gymTools'];
  if (t != null) {
    t.forEach((i) {
      gymTools.add(i);
    });
  }
  Config cfig = Config.withTools(gymType, gymTools);
  return cfig;
}

Future<bool> configExists() async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  File cFile = File('$path/config.json');
  bool exists = await cFile.exists();
  if (exists) {
    return true;
  }
  return false;
}

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    double mVert = MediaQuery.of(context).size.width * .02;
    double mHor = MediaQuery.of(context).size.width * .05;
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings", style: Theme.of(context).textTheme.button),
        bottom: PreferredSize(
          child: Container(
            color: Colors.grey,
            height: 4.0,
          ),
          preferredSize: Size.fromHeight(4.0),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MyHomePage(title: "Home", index: 0)),
            );
          },
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * .9,
            margin: EdgeInsets.only(
                left: mHor, right: mHor, top: mVert, bottom: mVert),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(10),
              color: tertiaryColor,
              onPressed: () {
                //Setup New Config
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SetupPage(),
                    ));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Icon(Icons.note, size: 20.00, color: Colors.white),
                    margin: EdgeInsets.only(right: 10),
                  ),
                  Text("Change Equipment",
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width * .9,
              margin: EdgeInsets.only(
                  left: mHor, right: mHor, top: mVert * 1.5, bottom: mVert),
              color: tertiaryColor,
              height: 50,
              child: SizedBox.expand(
                  child: FlatButton(
                      color: tertiaryColor,
                      child: Text(
                        "About",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Times New Roman",
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AboutPage()));
                      }))),
          Container(
              width: MediaQuery.of(context).size.width * .9,
              margin: EdgeInsets.only(
                  left: mHor, right: mHor, top: mVert, bottom: mVert),
              color: tertiaryColor,
              height: 50,
              child: SizedBox.expand(
                  child: FlatButton(
                      color: tertiaryColor,
                      child: Text(
                        "Leave a Review!",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Times New Roman",
                        ),
                      ),
                      onPressed: () {
                        LaunchReview.launch(
                          androidAppId: "com.dvpie.workoutcreator",
                          iOSAppId: "com.dvpie.workoutcreator",
                        );
                      }))),
          Container(
              width: MediaQuery.of(context).size.width * .9,
              margin: EdgeInsets.only(
                  left: mHor, right: mHor, top: mVert, bottom: mVert),
              color: tertiaryColor,
              height: 50,
              child: SizedBox.expand(
                  child: FlatButton(
                color: tertiaryColor,
                child: Text(
                  "Support the Creator!",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Times New Roman",
                  ),
                ),
                onPressed: () async {
                  String url = "http://gymbrain.site/donate";
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              )))
        ],
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double itemWidth = MediaQuery.of(context).size.width * .8;
    return Scaffold(
        appBar: AppBar(
          title: Text("About", style: Theme.of(context).textTheme.button),
          bottom: PreferredSize(
            child: Container(
              color: Colors.grey,
              height: 4.0,
            ),
            preferredSize: Size.fromHeight(4.0),
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(height: 50),
            Container(
                width: itemWidth,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    Container(
                        alignment: Alignment.center,
                        width: itemWidth - 30,
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey, width: 2)),
                        ),
                        height: 80,
                        child: Column(children: [
                          Text(
                            "Gym Brain",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Times New Roman",
                              fontSize: 25,
                            ),
                          ),
                          Text(
                            "Workout Creator",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Times New Roman",
                              fontSize: 18,
                            ),
                          ),
                        ])),
                    Container(
                        width: itemWidth - 30,
                        padding: EdgeInsets.all(10.0),
                        alignment: Alignment.center,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Creator:",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontFamily: "Times New Roman",
                                      ),
                                    ),
                                    Text(
                                      "David Piedra",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                        fontFamily: "Times New Roman",
                                      ),
                                    ),
                                  ]),
                              //Add other things
                              Container(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Version:",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: "Times New Roman",
                                    ),
                                  ),
                                  Text(
                                    "2.2",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                      fontFamily: "Times New Roman",
                                    ),
                                  ),
                                ],
                              )
                            ])),
                  ],
                )),
          ],
        ));
  }
}
