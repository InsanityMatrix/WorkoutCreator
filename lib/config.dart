library workoutcreator.config;

import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class Config {
  String gymType;
  List<String> gymTools;
  //Possible Tools:
  //barbell, dumbbell, pullupbar, cable, dipbars, flymachine

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
  File cFile = File('$path/$cName');
  String json = jsonEncode(config);
  cFile.writeAsString(json);
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