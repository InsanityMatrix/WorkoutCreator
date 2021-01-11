library workoutcreator.log;

import 'dart:collection';

import 'package:workoutcreator/main.dart';
import 'package:workoutcreator/globals.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

bool isNumeric(String s) {
  if(s == null) {
    return false;
  }
  return double.parse(s, (e) => null) != null;
}

//Log Configuration
void setupLog() async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  Directory lDir = Directory("$path/logs");
  bool lDirExists = await lDir.exists();
  if(!lDirExists) {
    //make log directory
    lDir.createSync();
  }
}

//Log Weight, (height?)
class PersonalLog {
  double height, weight;
  DateTime date;
  PersonalLog(this.height, this.weight);
  PersonalLog.withDate(this.height, this.weight, this.date);
  PersonalLog.onlyWeight(this.weight);

  Map<String, dynamic> toJson() => {
    'Height':height,
    'Weight':weight,
    'Date':date.toString(),
  };
  @override toString() => 'Height: $height, Weight: $weight, Date: ${date.toString()}';
  bool hasHeight() {
    if(this.height != null && this.height > 0) {
      return true;
    }
    return false;
  } 
}
//PR Logging
class PRLog {
  Exercise exercise;
  String unit;
  double weight;
  DateTime date;

  PRLog(this.exercise, this.weight, this.unit, this.date);
  Map<String, dynamic> toJson() => {
    'Exercise': exercise,
    'Weight':weight,
    'Unit': unit,
    'Date':date.toString(),
  };
  @override toString() => 'Exercise: $exercise, Weight: $weight$unit, Date: $date';
}
//LOGIC

//Personal Log
Future<void> addToPersonalLog(PersonalLog entry) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  File logFile = File("$path/logs/personalLog.json");
  List<PersonalLog> logData = [];
  if(await logFile.exists()) {
    //parse the json file
    String json = await logFile.readAsString();
    var decoded = jsonDecode(json);
    decoded.forEach((l) {
      double height = l['Height'];
      double weight = l['Weight'];
      DateTime date = DateTime.parse(l['Date']);
      PersonalLog log = PersonalLog.withDate(height, weight, date);
      logData.add(log);
    });
  } else {
    await logFile.create();
  }
  if(entry.hasHeight()) {
    //Require height (inches) and weight (pounds)
    logData.add(entry);
  }
  logFile.deleteSync();
  logFile.createSync();
  
  String encoded = jsonEncode(logData);
  logFile.writeAsString(encoded);
}

Future<void> removeFromPersonalLog(PersonalLog entry) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  File logFile = File("$path/logs/personalLog.json");
  List<PersonalLog> logData = [];
  String json = await logFile.readAsString();
  var decoded = jsonDecode(json);
  decoded.forEach((l) {
    double height = l['Height'];
    double weight = l['Weight'];
    DateTime date = DateTime.parse(l['Date']);
    PersonalLog log = PersonalLog.withDate(height, weight, date);
    logData.add(log);
  });
  int toRemove = -1;
  logData.forEach((val) {
    if(val.date == entry.date) {
      toRemove = logData.indexOf(val);
    }
  });
  if(toRemove != -1) {
    logData.removeAt(toRemove);
  }

  if(logData == []) {
    logFile.deleteSync();
  } else {
    //Save new File
    logFile.deleteSync();
    logFile.createSync();

    String encoded = jsonEncode(logData);
    logFile.writeAsString(encoded);
  }
}

Future<List<PersonalLog>> getPersonalLog() async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  File logFile = File("$path/logs/personalLog.json");
  if(await logFile.exists()) {
    List<PersonalLog> logData = [];
    String json = await logFile.readAsString();
    var decoded = jsonDecode(json);
    decoded.forEach((l) {
      double height = l['Height'];
      double weight = l['Weight'];
      DateTime date = DateTime.parse(l['Date']);
      PersonalLog log = PersonalLog.withDate(height, weight, date);
      logData.add(log);
    });
    logData.sort((a, b) => b.date.compareTo(a.date));
    return logData;
  } else {
    return [];
  }
}


//WORKOUT LOG
class WorkoutLog {
  Workout workout;
  List<double> sets;
  List<double> reps;
  List<double> weight;
  DateTime date;
  WorkoutLog(this.workout, this.sets, this.reps, this.weight, this.date);

  Map<String, dynamic> toJson() => {
    'Workout': workout,
    'Sets': sets,
    'Reps': reps,
    'Weight': weight,
    'Date': date.toString(),
  };

  @override
  String toString() {
    return "Workout: $workout, Sets: $sets, Reps: $reps, Weight: $weight, Date: $date,";
  }
}

Future<List<WorkoutLog>> getWorkoutLog() async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  File logFile = File('$path/logs/workoutLog.json');
  if(await logFile.exists()) {
    List<WorkoutLog> logData = [];
    String json = await logFile.readAsString();
    var decoded = jsonDecode(json);
    decoded.forEach((l) {
      dynamic w = l['Workout'];
      dynamic s = l['Sets'];
      dynamic r = l['Reps'];
      dynamic we = l['Weight'];
      //Parse Workout
      Workout workout;
      List<Exercise> exercises = [];
      List ex = w['Exercises'];
      ex.forEach((i) {
        List<int> secondaryMuscles = [];
        List scm = i['SecondaryMuscles'];
        if (scm != null) {
          scm.forEach((j){
            secondaryMuscles.add(j);
          });
        }
        List<String> equipment = [];
        List e = i['Equipment'];
        if(e != null) {
          e.forEach((j) {
            equipment.add(j);
          });
        }
        exercises.add(new Exercise(i['Name'], i['PrimaryMuscles'], secondaryMuscles, equipment));
      });
      workout = new Workout(w['Name'], exercises);
      //Parse Sets
      List<double> sets = [];
      s.forEach((k) {
        sets.add(k);
      });
      //Parse Reps
      List<double> reps = [];
      r.forEach((k) {
        reps.add(k);
      });

      //Parse Weight
      List<double> weights = [];
      we.forEach((k) {
        weights.add(k);
      });

      DateTime date = DateTime.parse(l['Date']);
      WorkoutLog log = WorkoutLog(workout, sets, reps, weights, date);
      logData.add(log);
    });
    logData.sort((a, b) => b.date.compareTo(a.date));
    return logData;
  } else {
    return [];
  }
}
Future<void> addToWorkoutLog(WorkoutLog entry) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  File logFile= File("$path/logs/workoutLog.json");
  List<WorkoutLog> logData = [];
  if(await logFile.exists()) {
    logData = await getWorkoutLog();
  } else {
    await logFile.create();
  }
  logData.add(entry);
  logFile.deleteSync();
  print(logData);
  String encoded = jsonEncode(logData);
  logFile.writeAsString(encoded);
}
Future<void> removeFromWorkoutLog(WorkoutLog entry) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  File logFile = File("$path/logs/workoutLog.json");
  List<WorkoutLog> logData = await getWorkoutLog();
  int toRemove = -1;
  logData.forEach((val) {
    if(val.toString() == entry.toString()) {
      toRemove = logData.indexOf(val);
    }
  });
  if(toRemove != -1) {
    logData.removeAt(toRemove);
  }
  if(logData == []) {
    logFile.deleteSync();
  } else {
    logFile.deleteSync();
    logFile.createSync();

    String encoded = jsonEncode(logData);
    logFile.writeAsString(encoded);
  }
}
// PR LOG
Future<void> addToPRLog(PRLog entry) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  File logFile = File("$path/logs/prLog.json");
  List<PRLog> logData = [];
  if(await logFile.exists()) {
    //parse the json file
    logData = await getPRLog();
  } else {
    await logFile.create();
  }
  logData.add(entry);
  logFile.deleteSync();
  logFile.createSync();
  
  String encoded = jsonEncode(logData);
  logFile.writeAsString(encoded);
}
Future<List<PRLog>> getPRLog() async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  File logFile = File("$path/logs/prLog.json");
  if(await logFile.exists()) {
    List<PRLog> logData = [];
    String json = await logFile.readAsString();
    var decoded = jsonDecode(json);
    decoded.forEach((l) {
      dynamic i = l['Exercise'];
      Exercise exercise;
      List<int> secondaryMuscles = [];
      List scm = i['SecondaryMuscles'];
      if(scm != null) {
        scm.forEach((j) {
          secondaryMuscles.add(j);
        });
      }
      List<String> equipment = [];
      List e = i['Equipment'];
      if (e != null) {
        e.forEach((j) {
          equipment.add(j);
        });
      }
      exercise = new Exercise(i['Name'], i['PrimaryMuscles'], secondaryMuscles,equipment);
      double weight = l['Weight'];
      String unit = l['Unit'];
      DateTime date = DateTime.parse(l['Date']);
      PRLog log = PRLog(exercise, weight, unit, date);
      logData.add(log);
    });
    logData.sort((a, b) => b.date.compareTo(a.date));
    //Sort logData most recent date first
    return logData;
  } else {
    return [];
  }
}
Future<void> removeFromPRLog(PRLog entry) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  File logFile = File("$path/logs/prLog.json");
  List<PRLog> logData = await getPRLog();
  int toRemove = -1;
  logData.forEach((val) {
    if(val.toString() == entry.toString()) {
      toRemove = logData.indexOf(val);
    }
  });
  if(toRemove != -1) {
    logData.removeAt(toRemove);
  }
  if(logData == []) {
    logFile.deleteSync();
  } else {
    //Save new File
    logFile.deleteSync();
    logFile.createSync();

    String encoded = jsonEncode(logData);
    logFile.writeAsString(encoded);
  }
}
//GO: Views
class LogHome extends StatefulWidget {
  LogHome({Key key, this.setState}) : super(key: key);

  bool setState;
  @override
  _LogHome createState() => _LogHome();
}
class _LogHome extends State<LogHome> {
  Future<List<PersonalLog>> personalLog;
  Future<List<PRLog>> prLog;
  Future<List<WorkoutLog>> workoutLog;
  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }
    (context as Element).visitChildren(rebuild);
  }
  @override
  void initState() {
    super.initState();
    personalLog = getPersonalLog();
    prLog = getPRLog();
    workoutLog = getWorkoutLog();
    if(widget.setState != null) {
      setState((){
        prLog = getPRLog();
        personalLog = getPersonalLog();
        workoutLog = getWorkoutLog();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    rebuildAllChildren(context);
    return Container(
      child: ListView(
        children: <Widget>[
          loadPersonalLog(context),
          loadPRLog(context),
          loadWorkoutLog(context),
        ],
      ),
    );
  }

  Container loadPRLog(BuildContext context) {
    double m = MediaQuery.of(context).size.width / 20;
    return Container(
      color: Theme.of(context).accentColor,
      width: MediaQuery.of(context).size.width / 10 * 9,
      margin: EdgeInsets.only(top: m, left: m, right: m),
      child: FutureBuilder<List<PRLog>>(
        future: prLog,
        builder: (BuildContext ctxt, AsyncSnapshot<List<PRLog>> snapshot) {
          if(snapshot.hasData) {
            if(snapshot.data == null) {
              return Text("Something Went Wrong", style: TextStyle(color: Colors.white));
            } else {
              List<PRLog> log = snapshot.data;
              List<Container> rows = [];
              log.forEach((entry) {
                double rowWidth = MediaQuery.of(context).size.width * .9;
                Container newRow = Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[700]),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: rowWidth * .3,
                        alignment: Alignment.center,
                        child: Text(
                          entry.exercise.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Times New Roman",
                          ),
                        ),
                      ),
                      Container(
                        width: rowWidth * .2,
                        alignment: Alignment.center,
                        child: Text(
                          entry.weight.toString() + entry.unit,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Times New Roman",
                          ),
                        ),
                      ),
                      Container(
                        width: rowWidth * .3,
                        alignment: Alignment.center,
                        child: Text(
                          entry.date.month.toString() + "/" + entry.date.day.toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Times New Roman",
                          ),
                        ),
                      ),
                      Container(
                        width: rowWidth * .2,
                        alignment: Alignment.center,
                        child: IconButton(
                          icon: Icon(
                            Icons.remove_circle,
                            color: Colors.black,
                          ),
                          color: Colors.white,
                          onPressed: () async {
                            await removeFromPRLog(entry);
                            setState((){
                              prLog = getPRLog();
                            });
                          }
                        ),
                      ),
                    ],
                  ),
                );
                rows.add(newRow);
              });
              return ExpansionTile(
                backgroundColor: Theme.of(context).accentColor,
                leading: FlatButton.icon(
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: Text(
                    "",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Times New Roman",
                    ),
                  ),
                  color: Theme.of(context).accentColor,
                  onPressed: (){
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PRLogEntry()),
                    ).then((value) {
                      setState(() {
                        prLog = getPRLog();
                      });
                    });
                  },
                ),
                title: Text(
                  "PR Log",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Times New Roman",
                  ),
                ),
                children: rows,
              );
            }
          } else {
            return Text("Loading");
          }
        },
      ),
    );
  }

  
  Container loadPersonalLog(BuildContext context) {
    double m = MediaQuery.of(context).size.width / 20;
    return Container(
      color: Theme.of(context).accentColor,
      width: MediaQuery.of(context).size.width / 10 * 9,
      margin: EdgeInsets.only(top: m/2, left: m, right: m),
      child: FutureBuilder<List<PersonalLog>>(
        future: personalLog,
        builder: (BuildContext ctxt, AsyncSnapshot<List<PersonalLog>> snapshot) {
          if(snapshot.hasData) {
            if(snapshot.data == null) {
              return Text("Something Went Wrong", style: TextStyle(color: Colors.white));
            } else {
              List<PersonalLog> log = snapshot.data;
              List<Container> rows = [];
              log.forEach((entry) {
                int ft = (entry.height / 12).truncate();
                int inches = (entry.height % 12).truncate();
                String height = ft.toString() + "\'" + inches.toString() + "\"";
                double rowWidth = MediaQuery.of(context).size.width * .9;
                Container newRow = Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[700]),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: rowWidth * .2,
                        alignment: Alignment.center,
                        child: Text(
                          height,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Times New Roman",
                          ),
                        ),
                      ),
                      Container(
                        width: rowWidth * .3,
                        alignment: Alignment.center,
                        child: Text(
                          entry.weight.toString() + " lbs",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Times New Roman",
                          ),
                        ),
                      ),
                      Container(
                        width: rowWidth * .3,
                        alignment: Alignment.center,
                        child: Text(
                          entry.date.month.toString() + "/" + entry.date.day.toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Times New Roman",
                          ),
                        ),
                      ),
                      Container(
                        width: rowWidth * .2,
                        alignment: Alignment.center,
                        child: IconButton(
                          icon: Icon(
                            Icons.remove_circle,
                            color: Colors.black,
                          ),
                          color: Colors.white,
                          onPressed: () async {
                            await removeFromPersonalLog(entry);
                            setState((){
                              personalLog = getPersonalLog();
                            });
                          }
                        ),
                      ),
                    ],
                  ),
                );
                rows.add(newRow);
              });
              return ExpansionTile(
                backgroundColor: Theme.of(context).accentColor,
                leading: FlatButton.icon(
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: Text(
                    "",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Times New Roman",
                    ),
                  ),
                  color: Theme.of(context).accentColor,
                  onPressed: (){
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BodyLogEntry()),
                    );
                  },
                ),
                title: Text(
                  "Body Log",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Times New Roman",
                  ),
                ),
                children: rows,
              );
            }
          } else {
            return Text("Loading");
          }
        },
      ),
    );
  }

  Container loadWorkoutLog(BuildContext context) {
    double m = MediaQuery.of(context).size.width / 20;
    return Container(
      color: Theme.of(context).accentColor,
      width: MediaQuery.of(context).size.width / 10 * 9,
      margin: EdgeInsets.only(top: m, left: m, right: m),
      child: FutureBuilder<List<WorkoutLog>>(
        future: workoutLog,
        builder: (BuildContext ctxt, AsyncSnapshot<List<WorkoutLog>> snapshot) {
          if(snapshot.hasData) {
            if(snapshot.data == null) {
              return Text("Something Went Wrong", style: TextStyle(color: Colors.white));
            } else {
              List<WorkoutLog> log = snapshot.data;
              List<Container> rows = [];
              log.forEach((entry) {
                String workoutName = entry.workout.name;
                double rowWidth = MediaQuery.of(context).size.width * .9;
                Container newRow = Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[700]),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: rowWidth * .8,
                        height: 30,
                        child: SizedBox.expand(
                          child: FlatButton(
                            child: Row(
                              children: [
                                Container(
                                  width: .5,
                                  height: 30,
                                  child: SizedBox.expand(
                                    child: Icon(Icons.arrow_right, color: Colors.black, size: 15),
                                  )
                                ),

                                Container(
                                  width: rowWidth * .35,
                                  alignment: Alignment.center,
                                  child: Text(
                                    workoutName,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Times New Roman",
                                    ),
                                  ),
                                ),
                                Container(
                                  width: rowWidth * .3,
                                  alignment: Alignment.center,
                                  child: Text(
                                    entry.date.month.toString() + "/" + entry.date.day.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Times New Roman",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            color: Colors.white,
                            onPressed: () {
                              Navigator.of(context).popUntil((route) => route.isFirst);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WorkoutEntry(entry: entry)),
                              );
                            }
                          )
                        )
                      ),
                      
                      Container(
                        width: rowWidth * .2,
                        height: 30,
                        alignment: Alignment.center,
                        child: IconButton(
                          icon: Icon(
                            Icons.remove_circle,
                            color: Colors.black,
                          ),
                          color: Colors.white,
                          onPressed: () async {
                            await removeFromWorkoutLog(entry);
                            setState((){
                              workoutLog = getWorkoutLog();
                            });
                          }
                        ),
                      ),
                    ],
                  ),
                );
                rows.add(newRow);
              });
              return ExpansionTile(
                backgroundColor: Theme.of(context).accentColor,
                leading: FlatButton.icon(
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: Text(
                    "",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Times New Roman",
                    ),
                  ),
                  color: Theme.of(context).accentColor,
                  onPressed: (){
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WorkoutLoggerSetup()),
                    );
                  },
                ),
                title: Text(
                  "Workout Log",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Times New Roman",
                  ),
                ),
                children: rows,
              );
            }
          } else {
            return Text("Loading");
          }
        },
      ),
    );
  }
}

class BodyLogEntry extends StatefulWidget {
  BodyLogEntry({Key key}) : super(key: key);

  @override
  _BodyLogEntry createState() => _BodyLogEntry();
}
class _BodyLogEntry extends State<BodyLogEntry> {
  //KEYS AND CONTROLLERS
  final _formKey = GlobalKey<FormState>();
  final weightController = TextEditingController();
  final heightController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101)
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Body Log Entry",
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
                  builder: (context) => MyHomePage(title: "Home", index: 2)),
            );
          },
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Title
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              padding: EdgeInsets.all(15),
              color: Theme.of(context).accentColor,
              child: Text(
                "Create Body Log Entry",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: "Times New Roman",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            //Form Creation
            //Height:
            Container(
              width: MediaQuery.of(context).size.width * .8,
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * .1),
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * .8 * .75,
                    child: TextFormField(
                      style: Theme.of(context).textTheme.button,
                      cursorColor: Colors.white,
                      validator: (value) {
                        if(value.isEmpty) {
                          return 'You need to enter a height!';
                        } else if (!isNumeric(value)) {
                          return 'Height is not a number';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Height',
                        labelStyle: TextStyle(color: Color(0xFFdbdbdb)),
                        contentPadding: EdgeInsets.all(20.0),
                      ),
                      controller: heightController,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .8 * .25,
                    child: Text(
                      "inches",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Times New Roman",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //Weight:
            Container(
              width: MediaQuery.of(context).size.width * .8,
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * .1),
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * .8 * .75,
                    child: TextFormField(
                      style: Theme.of(context).textTheme.button,
                      cursorColor: Colors.white,
                      validator: (value) {
                        if(value.isEmpty) {
                          return 'You need to enter a weight!';
                        } else if (!isNumeric(value)) {
                          return 'Weight is not a number';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Weight',
                        labelStyle: TextStyle(color: Color(0xFFdbdbdb)),
                        contentPadding: EdgeInsets.all(20.0),
                      ),
                      controller: weightController,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .8 * .25,
                    child: Text(
                      "pounds",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Times New Roman",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //DATE
            Container(
              width: MediaQuery.of(context).size.width * .8,
              alignment: Alignment.center,
              child: FlatButton(
                minWidth: MediaQuery.of(context).size.width * .7,
                color: Theme.of(context).accentColor,
                child: Text(
                  "${selectedDate.toLocal()}".split(' ')[0],
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Times New Roman",
                  ),
                ),
                onPressed: () => _selectDate(context),
              ),
            ),
            //Create Button
            Container(
              width: MediaQuery.of(context).size.width * .8,
              alignment: Alignment.center,
              child: FlatButton(
                minWidth: MediaQuery.of(context).size.width * .7,
                child: Text(
                  "Log Entry",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Times New Roman",
                    fontSize: 25,
                  ),
                ),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  if(!_formKey.currentState.validate()) {
                    return;
                  }
                  String heightText = heightController.text;
                  String weightText = weightController.text;

                  if(isNumeric(heightText) && isNumeric(weightText)) {
                    double height = double.parse(heightText);
                    double weight = double.parse(weightText);
                    DateTime time = selectedDate;

                    PersonalLog entry = PersonalLog.withDate(height, weight, time);
                    addToPersonalLog(entry).then((_){
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyHomePage(title: "Home", index: 2)),
                      );
                    });
                  }
                  return;
                }
              ),
            ),
          ],
        )
      ),
    );
  }
}
class PRLogEntry extends StatefulWidget {
  PRLogEntry({Key key}) : super(key: key);

  @override
  _PRLogEntry createState() => _PRLogEntry();
}
class _PRLogEntry extends State<PRLogEntry> {
  //KEYS AND CONTROLLERS
  final _formKey = GlobalKey<FormState>();
  final weightController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  List<DropdownMenuItem<Exercise>> exercises = [
    new DropdownMenuItem(
      child: new Text("Benchpress", style: TextStyle(color: Colors.white)),
      value: BENCHPRESS,
    ),
    new DropdownMenuItem(
      child: new Text("Shoulder Press", style: TextStyle(color: Colors.white)),
      value: SHOULDER_PRESS,
    ),
    new DropdownMenuItem(
      child: new Text("Back Squat", style: TextStyle(color: Colors.white)),
      value: BACK_SQUAT,
    ),
    new DropdownMenuItem(
      child: new Text("Deadlift", style: TextStyle(color: Colors.white)),
      value: DEADLIFT,
    ),
  ];
  List<DropdownMenuItem<String>> units = [
    new DropdownMenuItem(
      child: new Text("Pounds", style: TextStyle(color: Colors.white)),
      value: "lbs",
    ),
    new DropdownMenuItem(
      child: new Text("Kilograms", style: TextStyle(color: Colors.white)),
      value: "kg",
    ),
  ];
  String unit = "lbs";
  Exercise exercise = BENCHPRESS;
  Widget getExerciseButton() {
    return DropdownButton(
      dropdownColor: Theme.of(context).accentColor,
      focusColor: Color(0xFF525252),
      items: exercises,
      hint: new Text(
        'Select Exercise',
        style: TextStyle(color: Colors.white),
      ),
      value: exercise,
      onChanged: (value) {
        setState(() {
          exercise = value;
        });
      }
    );
  }
  Widget getUnitButton(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .8 * .4,
      child: DropdownButton(
        dropdownColor: Theme.of(context).accentColor,
        focusColor: Color(0xFF525252),
        items: units,
        hint: new Text(
          'Select Units',
          style: TextStyle(color: Colors.white),
        ),
        value: unit,
        onChanged: (value) {
          setState(() {
            unit = value;
          });
        }
      ),
    );
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101)
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PR Entry",
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
                  builder: (context) => MyHomePage(title: "Home", index: 2)),
            );
          },
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Title
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              padding: EdgeInsets.all(15),
              color: Theme.of(context).accentColor,
              child: Text(
                "Create PR Entry",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: "Times New Roman",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            //Form Creation
            //Exercise:
            Container(
              width: MediaQuery.of(context).size.width * .8,
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * .1),
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * .8,
                    alignment: Alignment.center,
                    child: getExerciseButton(),
                  ),
                ],
              ),
            ),
            //Weight:
            Container(
              width: MediaQuery.of(context).size.width * .8,
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * .005),
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * .8 * .60,
                    child: TextFormField(
                      style: Theme.of(context).textTheme.button,
                      cursorColor: Colors.white,
                      validator: (value) {
                        if(value.isEmpty) {
                          return 'You need to enter a weight!';
                        } else if (!isNumeric(value)) {
                          return 'Weight is not a number';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Weight',
                        labelStyle: TextStyle(color: Color(0xFFdbdbdb)),
                        contentPadding: EdgeInsets.all(20.0),
                      ),
                      controller: weightController,
                    ),
                  ),
                  getUnitButton(context),
                ],
              ),
            ),
            //DATE
            Container(
              width: MediaQuery.of(context).size.width * .8,
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * .1),
              alignment: Alignment.center,
              child: FlatButton(
                minWidth: MediaQuery.of(context).size.width * .7,
                color: Theme.of(context).accentColor,
                child: Text(
                  "${selectedDate.toLocal()}".split(' ')[0],
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Times New Roman",
                  ),
                ),
                onPressed: () => _selectDate(context),
              ),
            ),
            //Create Button
            Container(
              width: MediaQuery.of(context).size.width * .8,
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * .1),
              alignment: Alignment.center,
              child: FlatButton(
                minWidth: MediaQuery.of(context).size.width * .7,
                child: Text(
                  "Log Entry",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Times New Roman",
                    fontSize: 25,
                  ),
                ),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  if(!_formKey.currentState.validate()) {
                    return;
                  }
                  String weightText = weightController.text;

                  if(isNumeric(weightText)) {
                    double weight = double.parse(weightText);
                    DateTime time = selectedDate;

                    PRLog entry = PRLog(exercise, weight, unit,time);
                    addToPRLog(entry).then((_){
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyHomePage(title: "Home", index: 2)),
                      );
                    });
                    
                  }
                  return;
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkoutLoggerSetup extends StatefulWidget {
  WorkoutLoggerSetup({Key key}) : super(key: key);

  @override
  _WorkoutLoggerSetup createState() => _WorkoutLoggerSetup();
}
class _WorkoutLoggerSetup extends State<WorkoutLoggerSetup> {

  @override
  Widget build(BuildContext context) {
    double m = MediaQuery.of(context).size.width / 20;
    return Scaffold(
      appBar: AppBar(
        title: Text("Workout Logging", style: Theme.of(context).textTheme.button),
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
                  builder: (context) => MyHomePage(title: "Home", index: 2)),
            );
          },
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        child: ListView(
          children: <Widget>[
            FutureBuilder<List<String>>(
              future: getWorkouts(),
              builder:(BuildContext ctxt, AsyncSnapshot<List<String>> snapshot) {
                if(snapshot.hasData) {
                  if(snapshot.data == null) {
                    return Container();
                  } else {
                    return Container(
                      color: Theme.of(context).accentColor,
                      width: MediaQuery.of(context).size.width / 10 * 9,
                      margin: EdgeInsets.only(top: m*2, left: m, right: m),
                      child: ExpansionTile(
                        backgroundColor: Theme.of(context).accentColor,
                        title: Text(
                          "Your Workouts",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Times New Roman",
                          ),
                        ),
                        children: getYourWorkouts(context, snapshot.data),
                      )
                    );
                  }
                } else {
                  return Text("Something Went Wrong");
                }
              }
            ),
            Container(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * .9,
              height: 50,
              margin: EdgeInsets.only(left: m, right: m),
              child: SizedBox.expand(
                child: FlatButton(
                  child: Text(
                    "Log Custom Workout",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Times New Roman",
                    ),
                  ),
                  color: tertiaryColor,
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WorkoutLogger(workout: null)),
                    );
                  }
                ),
              ),
            ),
          ]
        )
      ),
    );
  }

  List<Widget> getYourWorkouts(BuildContext context, List<String> workouts) {
    double rowWidth = MediaQuery.of(context).size.width * .9;
    List<Container> rows = [];
    workouts.forEach((workout) {
      Container newRow = Container(
        decoration: BoxDecoration(
          color: tertiaryColor,
          border: Border(
            bottom: BorderSide(color: Colors.grey[700]),
          ),
        ),
        width: rowWidth,
        height: 50,
        child: Row(
          children:[
            Container(
              width: rowWidth * .75,
              alignment: Alignment.center,
              child: Text(
                workout,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Times New Roman",
                ),
              ),
            ),
            Container(
              width: rowWidth * .25,
              child: SizedBox.expand(
                child: FlatButton(
                  child: Icon(Icons.add, color: Colors.white),
                  color: tertiaryColor,
                  onPressed: () async{
                    Workout w = await getWorkout(workout + ".json");
                    w.name = workout;
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WorkoutLogger(workout: w)),
                    );
                  }
                )
              )
            )
          ]
        ),
      );
      rows.add(newRow);
    });

    return rows;
  }
}

class WorkoutLogger extends StatefulWidget {
  final Workout workout;
  WorkoutLogger({Key key, this.workout}) : super(key: key);

  @override
  _WorkoutLogger createState() => _WorkoutLogger();
}

class _WorkoutLogger extends State<WorkoutLogger> {
    //KEYS AND CONTROLLERS
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = new TextEditingController();
  List<TextEditingController> weightControllers = [];
  List<TextEditingController> setControllers = [];
  List<TextEditingController> repControllers = [];
  List<Exercise> exercises = [];
  List<DropdownMenuItem<Exercise>> exerciseList = [];
  int exerciseButtons = 1;
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101)
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    if(widget.workout != null) {
      widget.workout.exercises.forEach((exercise) {
        EXERCISES.forEach((value) {
          if(exercise.toString() == value.toString()) {
            exercises.add(value);
          }
        });
        setControllers.add(TextEditingController());
        repControllers.add(TextEditingController());
        weightControllers.add(TextEditingController());
      });
      exerciseButtons = widget.workout.exercises.length;
    }
  }
  @override
  Widget build(BuildContext context) {
    loadExerciseList();
    return Scaffold(
      appBar: AppBar(
        title: Text("Workout Logging", style: Theme.of(context).textTheme.button),
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
                  builder: (context) => MyHomePage(title: "Home", index: 2)),
            );
          },
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Form(
        key: _formKey,
        child: ListView(
          children: buildLogger(context),
        ),
      ),
    );
  }

  List<Widget> buildLogger(BuildContext context) {
    double m = MediaQuery.of(context).size.width / 20;
    double rowWidth = MediaQuery.of(context).size.width * .9;
    List<Widget> widgets = [];
    
    String name = "";
    if(widget.workout != null) {
      name = widget.workout.name;
      nameController.text = name;
    } else if(exercises.length == 0) {
      exercises.add(EXERCISES[0]);
    }
    Widget nameWidget = Container(
      width: rowWidth,
      margin: EdgeInsets.only(top: m * 2, left: m, right: m), 
      child: TextFormField(
        autocorrect: true,
        style: Theme.of(context).textTheme.button,
        cursorColor: Colors.white,
        validator: (value) {
          if(value.isEmpty) {
            return 'You need to enter a workout name';
          }
          return null;
        },
        decoration: const InputDecoration(
          labelText: 'Workout Name',
          labelStyle: TextStyle(color: Color(0xFFdbdbdb)),
          contentPadding: EdgeInsets.all(20.0),
        ),
        controller: nameController,
      ),
    );
    //DateTime Picker
    Widget dateWidget = Container(
      width: rowWidth,
      margin: EdgeInsets.only(left: m, right: m, top: m * 2),
      alignment: Alignment.center,
      child: FlatButton(
        minWidth: rowWidth,
        color: Theme.of(context).accentColor,
        child: Text(
          "${selectedDate.toLocal()}".split(' ')[0],
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Times New Roman",
          ),
        ),
        onPressed: () => _selectDate(context),
      ),
    );
    widgets.add(nameWidget);
    widgets.add(dateWidget);
    //For Each Exercise added
    for(int i = 0; i < exerciseButtons; i++) {
      if(setControllers.length == i) {
        setControllers.add(TextEditingController());
        repControllers.add(TextEditingController());
        weightControllers.add(TextEditingController());
      }
      Container nRow = new Container(
        width: rowWidth,
        margin: EdgeInsets.only(top: m * 2, left: m, right: m),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(
            bottom: BorderSide(color: Colors.grey[700]),
          ),
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                getExerciseButton(i),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: rowWidth / 3,
                  child: TextFormField(
                    controller: setControllers[i],
                    style: Theme.of(context).textTheme.button,
                    cursorColor: Colors.white,
                    decoration: const InputDecoration(
                      labelText: 'Sets',
                      labelStyle: TextStyle(color: Color(0xFFdbdbdb)),
                    ),
                    validator: (value) {
                      if(!isNumeric(value)) {
                        return 'This value needs to be a number!';
                      } else if(value.isEmpty) {
                        return 'You need to enter sets!';
                      }
                      return null;
                    }
                  ),
                ),
                Container(
                  width: rowWidth / 3,
                  child: TextFormField(
                    controller: repControllers[i],
                    style: Theme.of(context).textTheme.button,
                    cursorColor: Colors.white,
                    decoration: const InputDecoration(
                      labelText: 'Reps',
                      labelStyle: TextStyle(color: Color(0xFFdbdbdb)),
                    ),
                    validator: (value) {
                      if(!isNumeric(value)) {
                        return 'This value needs to be a number!';
                      } else if(value.isEmpty) {
                        return 'You need to enter reps!';
                      }
                      return null;
                    }
                  ),
                ),
                Container(
                  width: rowWidth / 3,
                  child: TextFormField(
                    controller: weightControllers[i],
                    style: Theme.of(context).textTheme.button,
                    cursorColor: Colors.white,
                    decoration: const InputDecoration(
                      labelText: 'Weight',
                      labelStyle: TextStyle(color: Color(0xFFdbdbdb)),
                    ),
                    validator: (value) {
                      if(!isNumeric(value)) {
                        return 'This value needs to be a number!';
                      } else if(value.isEmpty) {
                        return 'You need to enter weight!';
                      }
                      return null;
                    }
                  ),
                ),
              ]
            )
          ],
        ),
      );
      widgets.add(nRow);
    }
    //Add Exercise Button
    Container buttons = new Container(
      width: rowWidth,
      margin: EdgeInsets.only(top: m * 2, left: m, right: m),
      height: 50,
      child: Row(
        children: [
          Container(
            width: rowWidth / 2,
            child: SizedBox.expand(
              child: FlatButton(
                color: tertiaryColor,
                child: Text(
                  "Add Exercise",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Times New Roman",
                  ),
                ),
                onPressed: () {
                  setState((){
                    exerciseButtons += 1;
                    exercises.add(EXERCISES[0]);
                    setControllers.add(TextEditingController());
                    repControllers.add(TextEditingController());
                    weightControllers.add(TextEditingController());
                  });
                }
              ),
            ),
          ),
          Container(
            width: rowWidth / 2,
            child: SizedBox.expand(
              child: FlatButton(
                color: tertiaryColor,
                child: Text(
                  "Remove Exercise",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Times New Roman",
                  ),
                ),
                onPressed: () {
                  setState((){
                    exerciseButtons -= 1;
                    exercises.removeLast();
                    setControllers.removeLast();
                    repControllers.removeLast();
                    weightControllers.removeLast();
                  });
                }
              ),
            ),
          ),
        ]
      )
    );
    widgets.add(buttons);

    //LOG BUTTON
    Container logButton = Container(
      width: rowWidth,
      height: 50,
      margin: EdgeInsets.only(top: 0, left: m, right: m),
      child: SizedBox.expand(
        child: FlatButton(
          child: Text(
            "Log Workout",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Times New Roman",
            ),
          ),
          color: tertiaryColor,
          onPressed: () {
            if(_formKey.currentState.validate()) {
              //Create Workout
              Workout workout;
              String name = nameController.text;
              workout = Workout(name, exercises);
              //Get Sets, reps, and date
              List<double> sets = [];
              List<double> reps = [];
              List<double> weights = [];
              setControllers.forEach((controller){
                sets.add(double.parse(controller.text));
              });
              repControllers.forEach((controller){
                reps.add(double.parse(controller.text));
              });
              weightControllers.forEach((controller){
                weights.add(double.parse(controller.text));
              });

              WorkoutLog newLog = WorkoutLog(workout, sets, reps, weights, selectedDate);
              addToWorkoutLog(newLog).then((_){
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(title: "Home", index: 2)),
                );
              });
            }
          }
        ),
      ),
    );
    widgets.add(logButton);
    return widgets;
  }

  Widget getExerciseButton(int index) {
    if(exercises.length == index) {
      exercises.add(EXERCISES[0]);
    }
    return DropdownButton(
      dropdownColor: Theme.of(context).accentColor,
      focusColor: Color(0xFF525252),
      items: exerciseList,
      hint: new Text('Select Exercise',
        style: Theme.of(context).textTheme.button
      ),
      value: exercises[index],
      onChanged: (value) {
        setState((){
          exercises[index] = value;
        });
      }
    );
  }

  void loadExerciseList() {
    if(exercises.length == 0) {
      exercises.add(EXERCISES[0]);
      setControllers.add(TextEditingController());
      repControllers.add(TextEditingController());
      weightControllers.add(TextEditingController());
    }
    if(exerciseList.length > 2) {
      return;
    }
    EXERCISES.forEach((exercise) {
      exerciseList.add(DropdownMenuItem(
        child: new Text(
          exercise.name,
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Times New Roman",
          ),
        ),
        value: exercise,
      ));
    });
  }
}
//TODO: Make Workout Log Entry Viewing Page
class WorkoutEntry extends StatefulWidget {
  final WorkoutLog entry;
  WorkoutEntry({Key key, @required this.entry}) : super(key: key);

  @override
  _WorkoutEntry createState() => _WorkoutEntry();
}
class _WorkoutEntry extends State<WorkoutEntry> {
  @override
  Widget build(BuildContext context) {
    double rowWidth = MediaQuery.of(context).size.width * .9;
    double m = MediaQuery.of(context).size.width / 20;
    DateTime date = widget.entry.date;
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    return Scaffold(
      appBar: AppBar(
        title: Text("Workout Entry", style: Theme.of(context).textTheme.button),
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
                  builder: (context) => MyHomePage(title: "Home", index: 2)),
            );
          },
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: ListView(
        children: [
          Container(
            width: rowWidth,
            margin: EdgeInsets.only(top: m * 2, left: m, right: m),
            height: 35,
            color: tertiaryColor,
            alignment: Alignment.center,
            child: Text(
              widget.entry.workout.name,
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Times New Roman",
                fontSize: 25,
              ),
            ),
          ),
          Container(
            width: rowWidth,
            margin: EdgeInsets.only(top: 0, left: m, right: m),
            height: 20,
            color: tertiaryColor,
            alignment: Alignment.center,
            child: Text(
              formattedDate,
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Times New Roman",
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - (m * 2) - 55,
            child: ListView.builder(
              itemCount: widget.entry.workout.exercises.length,
              itemBuilder: (BuildContext ctxt, int index) {
                double topm = index == 0 ? m : 0;
                Exercise exercise = widget.entry.workout.exercises[index];
                double sets = widget.entry.sets[index];
                double reps = widget.entry.reps[index];
                double weight = widget.entry.weight[index];
                return Container(
                  width: rowWidth,
                  margin: EdgeInsets.only(top: topm, left: m, right: m),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 3, color: Theme.of(ctxt).primaryColor, style: BorderStyle.solid),
                    ),
                    color: tertiaryColor,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: rowWidth,
                            height: 20,
                            alignment: Alignment.center,
                            child: Text(
                              exercise.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Times New Roman",
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: rowWidth / 3,
                            height: 15,
                            alignment: Alignment.center,
                            child:Text(
                              "Sets",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Times New Roman",
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Container(
                            width: rowWidth / 3,
                            height: 15,
                            alignment: Alignment.center,
                            child:Text(
                              "Reps",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Times New Roman",
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Container(
                            width: rowWidth / 3,
                            height: 15,
                            alignment: Alignment.center,
                            child:Text(
                              "Weight",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Times New Roman",
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: rowWidth / 3,
                            height: 15,
                            alignment: Alignment.center,
                            child:Text(
                              sets.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Times New Roman",
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Container(
                            width: rowWidth / 3,
                            height: 15,
                            alignment: Alignment.center,
                            child:Text(
                              reps.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Times New Roman",
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Container(
                            width: rowWidth / 3,
                            height: 15,
                            alignment: Alignment.center,
                            child:Text(
                              weight.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Times New Roman",
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}