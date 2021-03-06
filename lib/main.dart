import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workoutcreator/config.dart';
import 'package:workoutcreator/templates.dart';
import 'package:workoutcreator/research.dart';
import 'package:workoutcreator/information.dart';
import 'package:workoutcreator/log.dart';
import 'package:workoutcreator/globals.dart' as globals;
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());
const int _blackPrimaryValue = 0xFF000000;
const MaterialColor primaryBlack = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: Color(0xFF231330),
    100: Color(0xFF231330),
    200: Color(0xFF231330),
    300: Color(0xFF231330),
    400: Color(0xFF231330),
    500: Color(0xFF231330),
    600: Color(0xFF231330),
    700: Color(0xFF231330),
    800: Color(0xFF231330),
    900: Color(0xFF231330),
  },
);
Config mainConfig;
Color tertiaryColor = new Color(0xFF52689c);
bool downloadedFiles = false;
bool gotConfigExists = false;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  Future<bool> config;
  @override
  void initState() {
    config = configExists();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Creator',
      theme: ThemeData(
        primaryColor: new Color(0xFF1e2a45),
        primarySwatch: primaryBlack,
        accentColor: new Color(0xFF243254),
        textTheme: TextTheme(
            button: TextStyle(
              color: Colors.white,
            ),
            subtitle1: TextStyle(
              color: Colors.black,
            )),
      ),
      home: MyHomePage(title: "Home", index: 0),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.index}) : super(key: key);
  final String title;
  final int index;
  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  int _currentIndex = 0;
  Widget bodyWidget;
  @override
  void initState() {
    super.initState();
    if (!downloadedFiles) {
      setupResearch();
      downloadedFiles = true;
    }
    setupLog();
    setState(() {
      _currentIndex = widget.index;
    });
    if (!gotConfigExists) {
      gotConfigExists = true;
      configExists().then((bool data) {
        if (!data) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SetupPage(),
              ));
        } else {
          getConfig().then((Config config) {
            mainConfig = config;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex == 0) {
      bodyWidget = new WorkoutCreatorPage();
    } else if (_currentIndex == 1) {
      bodyWidget = new ResearchHomePage();
    } else if (_currentIndex == 2) {
      bodyWidget = new LogHome();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
        bottom: PreferredSize(
          child: Container(
            color: Colors.grey,
            height: 4.0,
          ),
          preferredSize: Size.fromHeight(4.0),
        ),
        //Settings
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(),
                  ),
                );
              },
              child: Icon(Icons.settings),
            ),
          )
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: bodyWidget,
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapBar,
        currentIndex: _currentIndex,
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: "Workouts",
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.science),
            label: "Research",
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "Logs",
          ),
        ],
      ),
    );
  }

  void onTapBar(int index) {
    if (index == 0) {
      setState(() {
        bodyWidget = new WorkoutCreatorPage();
        _currentIndex = 0;
      });
    } else if (index == 1) {
      setState(() {
        bodyWidget = new ResearchHomePage();
        _currentIndex = 1;
      });
    } else if (index == 2) {
      setState(() {
        bodyWidget = new LogHome(setState: true);
        _currentIndex = 2;
      });
    }
  }
}

class WorkoutCreatorPage extends StatefulWidget {
  WorkoutCreatorPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WorkoutCreatorPage createState() => _WorkoutCreatorPage();
}

class _WorkoutCreatorPage extends State<WorkoutCreatorPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double rowWidth = MediaQuery.of(context).size.width * .8;
    double m = MediaQuery.of(context).size.width * .1;
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<List<String>>(
                future: globals.getWorkouts(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<String>> snapshot) {
                  List<Widget> children = [];

                  if (snapshot.hasData) {
                    if (snapshot.data == null) {
                      children.add(Text("No Workouts"));
                    } else if (snapshot.data.length > 0) {
                      for (int i = 0; i < snapshot.data.length; i++) {
                        if (snapshot.data[i] != null) {
                          Widget addition = Card(
                            color: tertiaryColor,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  title: Text(snapshot.data[i],
                                      style:
                                          Theme.of(context).textTheme.button),
                                  trailing: IconButton(
                                    icon: Icon(Icons.arrow_right),
                                    onPressed: () {
                                      String fileName =
                                          snapshot.data[i] + ".json";
                                      Future<globals.Workout> workout =
                                          globals.getWorkout(fileName);
                                      workout.then((data) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  WorkoutPage(workout: data)),
                                        );
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                          children.add(addition);
                        }
                      }
                    } else {
                      children.add(
                        Container(
                          alignment: Alignment.center,
                          width: rowWidth,
                          margin: EdgeInsets.only(
                              left: m, right: m, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                            color: tertiaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          height: 40,
                          child: Text(
                            "No Saved Workouts",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: "Times New Roman",
                            ),
                          ),
                        ),
                      );
                    }
                  } else {
                    children.add(Text("Error"));
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children,
                  );
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: rowWidth,
                  height: 40,
                  margin: EdgeInsets.only(left: m, right: m, bottom: 15),
                  child: SizedBox.expand(
                    child: RaisedButton(
                      color: Theme.of(context).accentColor,
                      child: Text(
                        "+ Create Workout",
                        style: TextStyle(
                          fontFamily: "Times New Roman",
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WorkoutCreation()),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: rowWidth,
              margin: EdgeInsets.only(left: m, right: m, top: 0, bottom: 0),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  margin: EdgeInsets.all(0),
                  width: rowWidth,
                  height: 40,
                  child: SizedBox.expand(
                    child: FlatButton(
                        color: Theme.of(context).accentColor,
                        child: Icon(Icons.refresh, color: Colors.white),
                        onPressed: () {
                          setState(() {});
                        }),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkoutCreation extends StatefulWidget {
  WorkoutCreation({Key key}) : super(key: key);

  @override
  _WorkoutCreation createState() => _WorkoutCreation();
}

class _WorkoutCreation extends State<WorkoutCreation> {
  List<Widget> getTemplateWorkouts(BuildContext context) {
    double rowWidth = MediaQuery.of(context).size.width * 9;
    List<Container> rows = [];
    templateWorkouts.forEach((workout) {
      Container newRow = Container(
          decoration: BoxDecoration(
            color: tertiaryColor,
            border: Border(
              bottom: BorderSide(color: Colors.grey[700]),
            ),
          ),
          width: rowWidth,
          height: 50,
          child: SizedBox.expand(
            child: FlatButton(
              color: tertiaryColor,
              child: Text(
                workout.name,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Times New Roman",
                ),
              ),
              onPressed: () async {
                globals.saveWorkout(workout.workout);
                http.get("http://142.93.112.148/stats/createworkout");
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          WorkoutPage(workout: workout.workout)),
                );
              },
            ),
          ));
      rows.add(newRow);
    });
    return rows;
  }

  List<Widget> getCelebrityWorkouts(BuildContext context) {
    double rowWidth = MediaQuery.of(context).size.width * 9;
    List<Container> rows = [];
    celebrityWorkouts.forEach((workout) {
      Container newRow = Container(
          decoration: BoxDecoration(
            color: tertiaryColor,
            border: Border(
              bottom: BorderSide(color: Colors.grey[700]),
            ),
          ),
          width: rowWidth,
          height: 50,
          child: SizedBox.expand(
            child: FlatButton(
              color: tertiaryColor,
              child: Text(
                workout.name,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Times New Roman",
                ),
              ),
              onPressed: () async {
                globals.saveWorkout(workout.workout);
                http.get("http://142.93.112.148/stats/createworkout");
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          WorkoutPage(workout: workout.workout)),
                );
              },
            ),
          ));
      rows.add(newRow);
    });
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    double m = MediaQuery.of(context).size.width / 20;
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Workout Creation", style: Theme.of(context).textTheme.button),
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
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
                color: Theme.of(context).accentColor,
                width: MediaQuery.of(context).size.width / 10 * 9,
                margin: EdgeInsets.only(top: m * 2, left: m, right: m),
                child: ExpansionTile(
                  backgroundColor: Theme.of(context).accentColor,
                  title: Text(
                    "Templates",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Times New Roman",
                    ),
                  ),
                  children: getTemplateWorkouts(context),
                )),
            Container(
                color: Theme.of(context).accentColor,
                width: MediaQuery.of(context).size.width / 10 * 9,
                margin: EdgeInsets.only(top: 20, left: m, right: m),
                child: ExpansionTile(
                  backgroundColor: Theme.of(context).accentColor,
                  title: Text(
                    "Celebrity Workouts",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Times New Roman",
                    ),
                  ),
                  children: getCelebrityWorkouts(context),
                )),
            Container(height: 20),
            Container(
              color: Theme.of(context).accentColor,
              width: MediaQuery.of(context).size.width / 10 * 9,
              margin: EdgeInsets.only(left: m, right: m),
              height: 50,
              child: SizedBox.expand(
                child: FlatButton(
                    color: Theme.of(context).accentColor,
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Add your own workout",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Times New Roman",
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomWorkoutBuilder()),
                      );
                    }),
              ),
            ),
            Container(height: 20),
            Container(
              color: Theme.of(context).accentColor,
              width: MediaQuery.of(context).size.width / 10 * 9,
              margin: EdgeInsets.only(left: m, right: m),
              height: 50,
              child: SizedBox.expand(
                child: FlatButton(
                    color: Theme.of(context).accentColor,
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Generate Custom Workout",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Times New Roman",
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                WorkoutBuilderPage(title: "Workout Builder")),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkoutBuilderPage extends StatefulWidget {
  WorkoutBuilderPage({Key key, this.title}) : super(key: key);
  //The title passed in from the home page
  final String title;
  @override
  _WorkoutBuilderPageState createState() => _WorkoutBuilderPageState();
}

class _WorkoutBuilderPageState extends State<WorkoutBuilderPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final epmController = TextEditingController(text: '2');
  List<DropdownMenuItem<int>> muscleList = [];
  List<int> selectedMuscles = [];
  int muscleGroupButtons = 1;
  Widget getMGBColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: getMGBWidgets(),
    );
  }

  List<Widget> getMGBWidgets() {
    List<Widget> widgets = [];
    for (int i = 0; i < muscleGroupButtons; i++) {
      widgets.add(getMuscleGroupButton(i));
    }
    return widgets;
  }

  Widget getMuscleGroupButton(int index) {
    if (selectedMuscles.length == index) {
      selectedMuscles.add(0);
    }
    return DropdownButton(
        dropdownColor: Theme.of(context).accentColor,
        focusColor: Color(0xFF525252),
        items: muscleList,
        hint: new Text('Select Muscle (Group)',
            style: Theme.of(context).textTheme.button),
        value: selectedMuscles[index],
        onChanged: (value) {
          setState(() {
            selectedMuscles[index] = value;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    loadMuscleList(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: Theme.of(context).textTheme.button),
        bottom: PreferredSize(
          child: Container(
            color: Colors.grey,
            height: 4.0,
          ),
          preferredSize: Size.fromHeight(4.0),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 84,
            child: ListView(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        autocorrect: true,
                        style: Theme.of(context).textTheme.button,
                        cursorColor: Colors.white,
                        validator: (value) {
                          if (value.isEmpty) {
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
                      Container(
                        alignment: Alignment(0, 0),
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: TextField(
                          decoration: new InputDecoration(
                              labelText: "Exercises Per Muscle Group",
                              labelStyle: TextStyle(color: Colors.white)),
                          keyboardType: TextInputType.number,
                          onChanged: (val) {
                            if (val == "") {
                              return;
                            }
                            int value = int.parse(val);
                            if (value > 0) {
                              FocusScope.of(context).unfocus();
                            }
                          },
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: epmController,
                          style: Theme.of(context).textTheme.button,
                          cursorColor: Colors.white,
                        ),
                      ),
                      getMGBColumn(),
                      RaisedButton(
                        color: Theme.of(context).accentColor,
                        focusColor: Color(0xFF525252),
                        child: Text("Add Another Muscle (group)",
                            style: Theme.of(context).textTheme.button),
                        onPressed: () {
                          setState(() {
                            muscleGroupButtons += 1;
                          });
                        },
                      ),
                      RaisedButton(
                        color: Theme.of(context).accentColor,
                        focusColor: Color(0xFF525252),
                        child: Text("Remove Last Muscle (group)",
                            style: Theme.of(context).textTheme.button),
                        onPressed: () {
                          setState(() {
                            muscleGroupButtons -= 1;
                            List<int> newSM = [];
                            for (int i = 0;
                                i < selectedMuscles.length - 1;
                                i++) {
                              newSM.add(selectedMuscles[i]);
                            }
                            selectedMuscles = newSM;
                          });
                        },
                      ),
                      RaisedButton(
                        color: Theme.of(context).accentColor,
                        focusColor: Color(0xFF525252),
                        child: Text("Create Workout",
                            style: Theme.of(context).textTheme.button),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            String name = nameController.text;
                            String epmString = epmController.text;
                            int epm = int.parse(epmString);
                            if (epm == 0) {
                              epm = 1;
                            }
                            List<int> muscleChoices = [];
                            for (int i = 0; i < muscleGroupButtons; i++) {
                              muscleChoices.add(selectedMuscles[i]);
                            }

                            globals.Workout workout = globals.createWorkout(
                                name, epm, muscleChoices, mainConfig);
                            http.get(
                                "http://142.93.112.148/stats/createworkout");
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      WorkoutPage(workout: workout)),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void loadMuscleList(BuildContext context) {
    if (selectedMuscles.length == 0) {
      selectedMuscles.add(0);
    }
    muscleList = [];
    muscleList.add(getMenuItem(context, "Trapezius", globals.TRAPEZIUS));
    muscleList.add(getMenuItem(context, "Deltoids", globals.DELTOIDS));
    muscleList.add(getMenuItem(context, "Triceps", globals.TRICEPS));
    muscleList.add(getMenuItem(context, "Biceps", globals.BICEPS));
    muscleList.add(getMenuItem(context, "Chest", globals.CHEST));
    muscleList.add(getMenuItem(context, "Rhomboids", globals.RHOMBOIDS));
    muscleList.add(getMenuItem(context, "Lats", globals.LATS));
    muscleList.add(getMenuItem(context, "Glutes", globals.GLUTES));
    muscleList.add(getMenuItem(context, "Quads", globals.QUADS));
    muscleList.add(getMenuItem(context, "Hamstrings", globals.HAMSTRINGS));
    muscleList.add(getMenuItem(context, "Calves", globals.CALVES));
    muscleList.add(getMenuItem(context, "Abs", globals.ABS));
    muscleList.add(getMenuItem(context, "Obliques", globals.OBLIQUES));
  }

  Map<String, String> licenseMap = {
    "Rhomboids":
        "By Anatomography licensed under Attribution-Share Alike 2.1 Japan",
    "Trapezius":
        "By Anatomography licensed under Attribution-Share Alike 2.1 Japan",
    "Deltoids":
        "By Anatomography licensed under Attribution-Share Alike 2.1 Japan",
    "Triceps":
        "By Anatomography licensed under Attribution-Share Alike 2.1 Japan",
    "Biceps":
        "By Anatomography licensed under Attribution-Share Alike 2.1 Japan",
    "Lats": "By Anatomography licensed under Attribution-Share Alike 2.1 Japan",
    "Chest": "By Tarawneh licensed under Attribution-Share Alike 3.0 Unported",
    "Glutes":
        "By Anvandare Chrizz licensed under Attribution-Share Alike 3.0 Unported",
    "Quads":
        "By he.wikipedia licensed under Attribution-Share Alike 3.0 Unported",
    "Hamstrings":
        "By BruceBlaus licensed under Attribution-Share Alike 4.0 International",
    "Calves": "By welcomeimages licensed under Attribution 4.0 International",
  };
  DropdownMenuItem<int> getMenuItem(
      BuildContext context, String muscleName, int muscle) {
    Widget child1;
    if (muscleName == "Abs" || muscleName == "Obliques") {
      child1 = Container();
    } else if (muscleName == "Rhomboids") {
      child1 = FlatButton(
          padding: EdgeInsets.all(0),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: Icon(
            Icons.info_outline,
            color: Colors.white,
          ),
          color: Colors.transparent,
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (ctxt) {
                return Dialog(
                    child: Container(
                  width: 280,
                  height: 300,
                  child: Column(
                    children: [
                      Container(
                        width: 280,
                        height: 260,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: ExactAssetImage(
                              'assets/muscles/' + muscleName + '.gif'),
                          fit: BoxFit.cover,
                        )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FlatButton(
                              child: Icon(Icons.close, color: Colors.black),
                              color: Colors.transparent,
                              onPressed: () {
                                Navigator.pop(ctxt);
                              },
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 280,
                        height: 40,
                        color: tertiaryColor,
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.white),
                            Text(licenseMap[muscleName],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                ));
              },
            );
          });
    } else {
      child1 = FlatButton(
          padding: EdgeInsets.all(0),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: Icon(
            Icons.info_outline,
            color: Colors.white,
          ),
          color: Colors.transparent,
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (ctxt) {
                return Dialog(
                    child: Container(
                  width: 280,
                  height: 300,
                  child: Column(
                    children: [
                      Container(
                        width: 280,
                        height: 260,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: ExactAssetImage(
                              'assets/muscles/' + muscleName + '.png'),
                          fit: BoxFit.cover,
                        )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FlatButton(
                              child: Icon(Icons.close, color: Colors.black),
                              color: Colors.transparent,
                              onPressed: () {
                                Navigator.pop(ctxt);
                              },
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 280,
                        height: 40,
                        color: tertiaryColor,
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.white),
                            Text(licenseMap[muscleName],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 7,
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                ));
              },
            );
          });
    }
    return DropdownMenuItem(
      child: new Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 6,
              child: child1,
            ),
            Text(muscleName, style: Theme.of(context).textTheme.button),
          ],
        ),
      ),
      value: muscle,
    );
  }
}

class CustomWorkoutBuilder extends StatefulWidget {
  CustomWorkoutBuilder({Key key}) : super(key: key);

  @override
  _CustomWorkoutBuilder createState() => _CustomWorkoutBuilder();
}

class _CustomWorkoutBuilder extends State<CustomWorkoutBuilder> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  List<globals.Exercise> selectedItems = [];
  List<DropdownMenuItem> items = [];
  int exerciseButtons = 1;

  Widget getExerciseColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: getExerciseWidgets(context),
    );
  }

  List<Widget> getExerciseWidgets(BuildContext context) {
    List<Widget> widgets = [];
    for (int i = 0; i < exerciseButtons; i++) {
      widgets.add(getExerciseButton(i));
    }
    return widgets;
  }

  Widget getExerciseButton(int index) {
    if (selectedItems.length == index) {
      selectedItems.add(globals.SHRUGS);
    }
    return Container(
      //width: MediaQuery.of(context).size.width * .8,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SearchableDropdown(
        items: items,
        value: selectedItems[index],
        menuBackgroundColor: Colors.white,
        hint: "Select one",
        isCaseSensitiveSearch: false,
        searchHint: new Text(
          "Select one",
          style: TextStyle(color: Colors.black),
        ),
        style: TextStyle(color: Colors.black, fontFamily: "Times New Roman"),
        onChanged: (val) {
          setState(() {
            selectedItems[index] = val;
          });
        },
        isExpanded: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    loadExerciseList(context);
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Add your workout', style: Theme.of(context).textTheme.button),
        bottom: PreferredSize(
          child: Container(
            color: Colors.grey,
            height: 4.0,
          ),
          preferredSize: Size.fromHeight(4.0),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  autocorrect: true,
                  style: Theme.of(context).textTheme.button,
                  cursorColor: Colors.white,
                  validator: (value) {
                    if (value.isEmpty) {
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
                getExerciseColumn(context),
                RaisedButton(
                  color: Theme.of(context).accentColor,
                  focusColor: Color(0xFF525252),
                  child: Text("Add Another Exercise",
                      style: Theme.of(context).textTheme.button),
                  onPressed: () {
                    setState(() {
                      exerciseButtons += 1;
                    });
                  },
                ),
                RaisedButton(
                  color: Theme.of(context).accentColor,
                  focusColor: Color(0xFF525252),
                  child: Text("Remove Last Exercise",
                      style: Theme.of(context).textTheme.button),
                  onPressed: () {
                    setState(() {
                      exerciseButtons -= 1;
                      List<globals.Exercise> newSM = [];
                      for (int i = 0; i < selectedItems.length - 1; i++) {
                        newSM.add(selectedItems[i]);
                      }
                      selectedItems = newSM;
                    });
                  },
                ),
                RaisedButton(
                  color: Theme.of(context).accentColor,
                  focusColor: Color(0xFF525252),
                  child: Text("Create Workout",
                      style: Theme.of(context).textTheme.button),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      String name = nameController.text;
                      globals.Workout workout =
                          globals.Workout(name, selectedItems);
                      await globals.saveWorkout(workout);
                      http.get("http://142.93.112.148/stats/createworkout");
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                WorkoutPage(workout: workout)),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void loadExerciseList(BuildContext context) {
    if (items.length > 2) {
      return;
    }
    globals.EXERCISES.forEach((exercise) {
      items.add(DropdownMenuItem(
        child: new Text(
          exercise.name,
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Times New Roman",
          ),
        ),
        value: exercise,
      ));
    });
  }
}

class WorkoutPage extends StatefulWidget {
  WorkoutPage({Key key, this.workout}) : super(key: key);
  //The title passed in from the home page
  final globals.Workout workout;
  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  globals.Workout workout;

  @override
  void initState() {
    super.initState();
    workout = widget.workout;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.getName(),
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
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: buildExerciseList(),
          ),
        ),
      ),
    );
  }

  List<Widget> buildExerciseList() {
    List<Widget> ls = [];
    for (int i = 0; i < workout.exercises.length; i++) {
      Widget addition = Card(
        color: tertiaryColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(workout.exercises[i].name,
                  style: Theme.of(context).textTheme.button),
              subtitle: Text(workout.exercises[i].subtitle(),
                  style: Theme.of(context).textTheme.button),
              trailing: IconButton(
                icon: Icon(Icons.refresh),
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    workout.getBackup(i);
                  });
                },
              ),
            ),
          ],
        ),
      );
      Dismissible dis = Dismissible(
        key: Key(workout.exercises[i].name),
        background: Container(color: Colors.red),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                backgroundColor: Theme.of(ctx).accentColor,
                title: Text(
                  'Are you sure?',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                content: Text(
                  'Do you want to remove this exercise?',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    color: tertiaryColor,
                    child: Text(
                      'No',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                    },
                  ),
                  FlatButton(
                    color: tertiaryColor,
                    child: Text(
                      'Yes',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop(true);
                    },
                  ),
                ]),
          );
        },
        onDismissed: (direction) {
          setState(() {
            workout.removeExercise(i);
          });
        },
        child: addition,
      );
      ls.add(dis);
    }

    ls.add(IconButton(
        icon: Icon(Icons.remove_circle),
        color: Colors.white,
        onPressed: () {
          Widget yesButton = FlatButton(
            child: Text("Yes"),
            onPressed: () {
              Future<bool> rm = globals.removeWorkout(widget.workout.name);
              rm.then((b) {
                if (b) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MyHomePage(title: "Home", index: 0)),
                  );
                }
              });
            },
          );
          Widget noButton = FlatButton(
            child: Text("No"),
            onPressed: () {
              Navigator.pop(context);
            },
          );

          AlertDialog alert = AlertDialog(
            title: Text("Remove this workout?"),
            content: Text("Are you sure you want to remove this workout?"),
            actions: <Widget>[
              noButton,
              yesButton,
            ],
          );
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return alert;
              });
        }));
    return ls;
  }
}

class SetupPage extends StatefulWidget {
  SetupPage({Key key}) : super(key: key);
  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  var _formIndex = 0;
  final _gymTypeFocusNode = FocusNode();
  final _gymToolsFocusNode = FocusNode();
  List<String> _gymTools;
  String gymType = '';
  GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

  TextEditingController _typeController;
  final List<Map<String, dynamic>> _gyms = [
    {
      'value': 'Gym',
      'label': 'Gym',
      'icon': Icon(Icons.fitness_center),
      'textStyle': TextStyle(color: Colors.black),
    },
    {
      'value': 'homeGym',
      'label': 'Home Gym',
      'icon': Icon(Icons.home),
      'textStyle': TextStyle(color: Colors.black),
    },
    {
      'value': 'park',
      'label': 'Calisthenics',
      'icon': Icon(Icons.park),
      'textStyle': TextStyle(color: Colors.black),
    }
  ];
  final List<Map<String, dynamic>> _tools = [
    {
      "display": "Barbell",
      "value": "barbell",
    },
    {"display": "Dumbbells/Kettlebells", "value": "dumbbell"},
    {
      "display": "Pullup-Bar",
      "value": "pullupbar",
    },
    {
      "display": "Cable Machine",
      "value": "cable",
    },
    {
      "display": "Dip Bars",
      "value": "dipbars",
    },
    {
      "display": "Fly Machine",
      "value": "flymachine",
    },
    {
      "display": "Leg Curl/Extension machine",
      "value": "legmachine",
    }
  ];

  @override
  void initState() {
    super.initState();
    //Initial Values
    _typeController = TextEditingController(text: 'Gym');
  }

  @override
  void dispose() {
    _gymTypeFocusNode.dispose();
    _gymToolsFocusNode.dispose();
    super.dispose();
  }

  void switchInputFields(int newIndex) {
    setState(() {
      _formIndex = newIndex;
    });
    newIndex == 0
        ? FocusScope.of(context).requestFocus(_gymTypeFocusNode)
        : FocusScope.of(context).requestFocus(_gymToolsFocusNode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      appBar: new AppBar(
        title: Text("Setup", style: Theme.of(context).textTheme.button),
        bottom: PreferredSize(
          child: Container(
            color: Colors.grey,
            height: 4.0,
          ),
          preferredSize: Size.fromHeight(4.0),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: IndexedStack(
              index: _formIndex,
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  color: Theme.of(context).accentColor,
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: MediaQuery.of(context).size.height * .5,
                  child: Card(
                    child: Form(
                      key: _formKey1,
                      child: Column(
                        children: <Widget>[
                          SelectFormField(
                              controller: _typeController,
                              icon: Icon(Icons.fitness_center),
                              labelText: 'Gym Type',
                              style: TextStyle(color: Colors.black),
                              changeIcon: true,
                              dialogTitle: 'Pick your gym type',
                              items: _gyms,
                              onChanged: (val) => setState(() => gymType = val),
                              validator: (val) {
                                setState(() {
                                  gymType = val;
                                });
                                if (gymType == '') {
                                  return "Choose A Gym Type";
                                }
                                return null;
                              }),
                          RaisedButton(
                              child: Text('Submit'),
                              onPressed: () {
                                final loForm = _formKey1.currentState;
                                if (loForm.validate()) {
                                  loForm.save();
                                  if (gymType == 'homeGym') {
                                    switchInputFields(1);
                                  } else {
                                    //Save Form Data Here in CONFIG FILE
                                    Config cfig = Config(gymType);
                                    saveConfig(cfig);
                                    mainConfig = cfig;
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyHomePage(
                                              title: "Home", index: 0)),
                                    );
                                  }
                                }
                              })
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  //Gym Tools
                  //Only show if They choose home gym in the past question
                  padding: const EdgeInsets.all(10.0),
                  color: Theme.of(context).accentColor,
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: MediaQuery.of(context).size.height * .7,
                  child: Card(
                    child: Form(
                        key: _formKey2,
                        child: Column(
                          children: <Widget>[
                            MultiSelectFormField(
                                autovalidate: false,
                                title: Text("My Equipment"),
                                dataSource: _tools,
                                validator: (value) {
                                  if (value == null || value.length == 0) {
                                    return "Please select your equipment";
                                  }
                                  return null;
                                },
                                textField: 'display',
                                valueField: 'value',
                                okButtonLabel: 'CONFIRM',
                                cancelButtonLabel: 'CANCEL',
                                dialogTextStyle: TextStyle(color: Colors.black),
                                hintWidget: Text(
                                    "Please select any equipment you have"),
                                initialValue: _gymTools,
                                onSaved: (value) {
                                  if (value == null) return;
                                  setState(() {
                                    List v = value;
                                    _gymTools = v.cast<String>().toList();
                                  });
                                }),
                            RaisedButton(
                              child: Text("DONE"),
                              onPressed: () {
                                final loForm = _formKey2.currentState;
                                if (loForm.validate()) {
                                  loForm.save();
                                  Config cfig =
                                      Config.withTools(gymType, _gymTools);
                                  saveConfig(cfig);
                                  mainConfig = cfig;
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyHomePage(
                                            title: "Home", index: 0)),
                                  );
                                }
                              },
                            ),
                          ],
                        )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
