library workoutcreator.information;

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

String url = "http://142.93.112.148/file/";
List<String> sections = [
  "Supplementation",
  "Pre-Workouts",
  "Gaining Muscle",
  "Strength Programs",
];

void setupResearch() async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  Directory rDir = Directory("$path/research");
  bool rDirExists = await rDir.exists();
  if(!rDirExists) {
    //Make Dir and start making files
    rDir.createSync();

    //Start With Supplements
    supplements.forEach((supp) {
      getSupplementFile(supp).then((val) {
        File sFile = File('$path/research/$supp.txt');
        sFile.writeAsString(val);
      });
    });

  } else {
    //Make Sure every file exists
    
    //Start With Supplements
    supplements.forEach((supp){
      File sFile = File('$path/research/$supp.txt');
      bool exists = sFile.existsSync();

      if(!exists) {
        //if file does not exist, download it
        getSupplementFile(supp).then((val) {
          sFile.writeAsString(val);
        });
      }
    });
  }
}

List<String> supplements = [
  "Creatine", "L-Citrulline", "Glycerol", "Beta-Alanine",
  "Caffiene"
];

Future<String> getSupplementFile(String supplement) async {
  String urlP = url + supplement;
  var response = await http.get(urlP);
  return response.body;
}

Future<String> getSupplementInfo(String supplement) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  File sFile = File("$path/research/$supplement.txt");
  String data = await sFile.readAsString();
  return data;
}