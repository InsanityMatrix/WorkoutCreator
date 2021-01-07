library workoutcreator.log;

import 'package:workoutcreator/main.dart';
import 'package:workoutcreator/globals.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
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
void addToPersonalLog(PersonalLog entry) async {
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
    return logData;
  } else {
    return [];
  }
}
// PR LOG
void addToPRLog(PRLog entry) async {
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
  //TODO: Sort logs by most recent date first before saving
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
  LogHome({Key key}) : super(key: key);

  @override
  _LogHome createState() => _LogHome();
}
class _LogHome extends State<LogHome> {
  Future<List<PersonalLog>> personalLog;
  Future<List<PRLog>> prLog;
  @override
  void initState() {
    super.initState();
    personalLog = getPersonalLog();
    prLog = getPRLog();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          loadPersonalLog(context),
          loadPRLog(context),
        ],
      ),
    );
  }

  Container loadPRLog(BuildContext context) {
    double m = MediaQuery.of(context).size.width / 10;
    return Container(
      color: Theme.of(context).accentColor,
      width: MediaQuery.of(context).size.width / 10 * 8,
      margin: EdgeInsets.only(top: m/2, left: m, right: m),
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
                double rowWidth = MediaQuery.of(context).size.width * .8;
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
                          entry.exercise.name,
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
    double m = MediaQuery.of(context).size.width / 10;
    return Container(
      color: Theme.of(context).accentColor,
      width: MediaQuery.of(context).size.width / 10 * 8,
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
                double rowWidth = MediaQuery.of(context).size.width * .8;
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
                    ).then((value) {
                      setState(() {
                        personalLog = getPersonalLog();
                      });
                    });
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
          icon: Icon(Icons.home, color: Colors.white),
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
                  String heightText = heightController.text;
                  String weightText = weightController.text;

                  if(isNumeric(heightText) && isNumeric(weightText)) {
                    double height = double.parse(heightText);
                    double weight = double.parse(weightText);
                    DateTime time = selectedDate;

                    PersonalLog entry = PersonalLog.withDate(height, weight, time);
                    addToPersonalLog(entry);
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyHomePage(title: "Home", index: 2)),
                    );
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
          icon: Icon(Icons.home, color: Colors.white),
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
                    addToPRLog(entry);
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyHomePage(title: "Home", index: 2)),
                    );
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