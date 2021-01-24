library workoutcreator.information;

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

String url = "http://142.93.112.148/file/";
List<String> sections = [
  "Nutrition",
  "Supplementation",
  "Pre-Workouts",
  "Beginner Questions",
  "Strength Programs",
];

void setupResearch() async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  Directory rDir = Directory("$path/research");
  bool rDirExists = await rDir.exists();
  if (!rDirExists) {
    //Make Dir and start making files
    rDir.createSync();

    //Start With Supplements
    supplements.forEach((supp) {
      getSupplementFile(supp).then((val) {
        File sFile = File('$path/research/$supp.txt');
        sFile.writeAsString(val);
      });
    });
    //Download Questions
    getQuestionsFile().then((val) {
      File qFile = File('$path/research/Questions.txt');
      qFile.writeAsString(val);
    });
    //Download StrengthPrograms
    getStrengthProgramsFile().then((val) {
      File spFile = File('$path/research/StrengthPrograms.txt');
      spFile.writeAsString(val);
    });

    getNutritionFile().then((val) {
      File nFile = File('$path/research/Nutrition.txt');
      nFile.writeAsString(val);
    });
  } else {
    //Make Sure every file exists & download updates
    //Start With Supplements
    supplements.forEach((supp) {
      File sFile = File('$path/research/$supp.txt');

      //if file does not exist, download it
      getSupplementFile(supp).then((val) {
        sFile.writeAsString(val);
      });
    });
    //Questions File
    File qFile = File('$path/research/Questions.txt');
    getQuestionsFile().then((val) {
      qFile.writeAsString(val);
    });
    //StrengthPrograms File
    File spFile = File('$path/research/StrengthPrograms.txt');
    getStrengthProgramsFile().then((val) {
      spFile.writeAsString(val);
    });

    //Nutrition File
    File nFile = File('$path/research/Nutrition.txt');
    getNutritionFile().then((val) {
      nFile.writeAsString(val);
    });
  }
}

List<String> supplements = [
  "Creatine",
  "Ashwagandha",
  "L-Citrulline",
  "L-Carnitine",
  "Glycerol",
  "Beta-Alanine",
  "Caffiene",
  "Theacrine",
];
Future<String> getNutritionFile() async {
  String urlP = url + "Nutrition";
  var response = await http.get(urlP);
  return response.body;
}

Future<String> getSupplementFile(String supplement) async {
  String urlP = url + supplement;
  var response = await http.get(urlP);
  return response.body;
}

Future<String> getQuestionsFile() async {
  String urlP = url + 'Questions';
  var response = await http.get(urlP);
  return response.body;
}

Future<String> getStrengthProgramsFile() async {
  String urlP = url + 'StrengthPrograms';
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

class Question {
  String question, answer;
  Question(this.question, this.answer);

  Map<String, String> toJson() => {
        'Question': question,
        'Answer': answer,
      };
}

Future<List<Question>> getQuestions() async {
  List<Question> questions = [];
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  File qFile = File('$path/research/Questions.txt');
  String json = await qFile.readAsString();
  var decoded = jsonDecode(json);
  //print(decoded);
  decoded.forEach((q) {
    String question = q['Question'];
    String answer = q['Answer'];
    Question que = Question(question, answer);
    questions.add(que);
  });

  return questions;
}

class NutritionInfo {
  String title, content;
  NutritionInfo(this.title, this.content);

  Map<String, String> toJson() => {
        'Title': title,
        'Content': content,
      };
}

Future<List<NutritionInfo>> getNutritionInfo() async {
  List<NutritionInfo> info = [];
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  File nFile = File('$path/research/Nutrition.txt');
  String json = await nFile.readAsString();
  var decoded = jsonDecode(json);
  decoded.forEach((n) {
    String title = n['Title'];
    String content = n['Content'];
    NutritionInfo i = NutritionInfo(title, content);
    info.add(i);
  });
  return info;
}

class StrengthProgram {
  String name, link, difficulty;
  StrengthProgram(this.name, this.link, this.difficulty);

  Map<String, String> toJson() => {
        'Name': name,
        'Link': link,
        'Difficulty': difficulty,
      };
}

Future<List<StrengthProgram>> getStrengthPrograms() async {
  List<StrengthProgram> programs = [];
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  File qFile = File('$path/research/StrengthPrograms.txt');
  String json = await qFile.readAsString();
  var decoded = jsonDecode(json);
  //print(decoded);
  decoded.forEach((q) {
    String name = q['Name'];
    String link = q['Link'];
    String difficulty = q['Difficulty'];

    StrengthProgram p = StrengthProgram(name, link, difficulty);
    programs.add(p);
  });

  return programs;
}
