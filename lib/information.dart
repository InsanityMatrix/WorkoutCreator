library workoutcreator.information;

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

String url = "http://142.93.112.148/file/";
List<String> sections = [
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
    //Download Questions
    getQuestionsFile().then((val) {
      File qFile = File('$path/research/Questions.txt');
      qFile.writeAsString(val);
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
    //Questions File
    File qFile = File('$path/research/Questions.txt');
    bool exists = await qFile.exists();
    if(!exists) {
      getQuestionsFile().then((val){
        qFile.writeAsString(val);
      });
    }
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
Future<String> getQuestionsFile() async {
  String urlP = url + 'Questions';
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
    print(q);
    String question = q['Question'];
    print("question: " + question);
    String answer = q['Answer'];
    print("answer: " + answer);
    Question que = Question(question, answer);
    print("question: " + que.toString());
    questions.add(que);
  });

  return questions;
}