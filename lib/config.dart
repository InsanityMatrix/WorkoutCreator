library workoutcreator.config;
import 'package:flutter/material.dart';
import 'package:workoutcreator/main.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:launch_review/launch_review.dart';
import 'dart:convert';

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
  configExists().then((exists){
    if(exists) {
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
  if(t != null) {
    t.forEach((i){
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
  if(exists) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings",
            style: Theme.of(context).textTheme.button),
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
            margin: EdgeInsets.all(MediaQuery.of(context).size.width * .05),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(color: Colors.red),
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                //Setup New Config
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SetupPage(),
                  )
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Icon(Icons.note, size: 20.00, color: Colors.white),
                    margin: EdgeInsets.only(right: 10),
                  ),
                  Text("Change Equipment", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * .9,
            margin: EdgeInsets.all(MediaQuery.of(context).size.width * .05),
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
                }
              )
            )
          )
        ],
      ),
    );
  }
}