import 'package:flutter/material.dart';
import 'package:workoutcreator/config.dart';
import 'package:workoutcreator/globals.dart' as globals;
import 'package:select_form_field/select_form_field.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

void main() => runApp(MyApp());
const int _blackPrimaryValue = 0xFF000000;
const MaterialColor primaryBlack = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: Color(0xFF000000),
    100: Color(0xFF000000),
    200: Color(0xFF000000),
    300: Color(0xFF000000),
    400: Color(0xFF000000),
    500: Color(_blackPrimaryValue),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);
Config mainConfig;
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Creator',
      theme: ThemeData(
        primaryColor: Colors.black,
        primarySwatch: primaryBlack,
        accentColor: new Color(0xFF424242),
        textTheme: TextTheme(
            button: TextStyle(
              color: Colors.white,
            ),
            subtitle1: TextStyle(
              color: Color(0xFFdbdbdb),
            )),
      ),
      home: MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<String>> _workouts = globals.getWorkouts();
  Future<bool> _configExists = configExists();
 
  @override
  Widget build(BuildContext context) {
    _configExists.then((bool data) {
      if(!data) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SetupPage(),
          )
        );
      } else {
        getConfig().then((Config config) {
          mainConfig = config;
        });
      }
    });
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
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body:Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FutureBuilder<List<String>>(
                    future: _workouts,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<String>> snapshot) {
                      List<Widget> children = [];
                      if (snapshot.hasData) {
                        if (snapshot.data == null) {
                          children.add(Text("No Workouts"));
                        } else if (snapshot.data.length > 0)
                          for (int i = 0; i < snapshot.data.length; i++) {
                            if (snapshot.data[i] != null) {
                              Widget addition = Card(
                                color: Theme.of(context).accentColor,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(snapshot.data[i],
                                          style: Theme.of(context)
                                              .textTheme
                                              .button),
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
                                                      WorkoutPage(
                                                          workout: data)),
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
                        else {
                          children.add(Text("No Saved Workouts"));
                        }
                      } else {
                        children.add(Text("Error"));
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: children,
                      );
                    }),
                RaisedButton(
                  child: Text("+ Create Workout"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              WorkoutBuilderPage(title: "Workout Builder")),
                    );
                  },
                ),
              ],
            ),
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
    loadMuscleList();
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
                  child: Text("Create Workout",
                      style: Theme.of(context).textTheme.button),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      String name = nameController.text;
                      List<int> muscleChoices = [];
                      for (int i = 0; i < muscleGroupButtons; i++) {
                        muscleChoices.add(selectedMuscles[i]);
                      }

                      globals.Workout workout =
                          globals.createWorkout(name, muscleChoices, mainConfig);
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

  void loadMuscleList() {
    if (selectedMuscles.length == 0) {
      selectedMuscles.add(0);
    }
    muscleList = [];
    muscleList.add(new DropdownMenuItem(
      child: new Text("Trapezius", style: Theme.of(context).textTheme.button),
      value: globals.TRAPEZIUS,
    ));
    muscleList.add(new DropdownMenuItem(
      child: new Text("Deltoids", style: Theme.of(context).textTheme.button),
      value: globals.DELTOIDS,
    ));
    muscleList.add(new DropdownMenuItem(
      child: new Text("Triceps", style: Theme.of(context).textTheme.button),
      value: globals.TRICEPS,
    ));
    muscleList.add(new DropdownMenuItem(
      child: new Text("Biceps", style: Theme.of(context).textTheme.button),
      value: globals.BICEPS,
    ));
    muscleList.add(new DropdownMenuItem(
      child: new Text("Chest", style: Theme.of(context).textTheme.button),
      value: globals.CHEST,
    ));
    muscleList.add(new DropdownMenuItem(
      child: new Text("Rhomboids", style: Theme.of(context).textTheme.button),
      value: globals.RHOMBOIDS,
    ));
    muscleList.add(new DropdownMenuItem(
      child: new Text("Lats", style: Theme.of(context).textTheme.button),
      value: globals.LATS,
    ));
    muscleList.add(new DropdownMenuItem(
      child: new Text("Glutes", style: Theme.of(context).textTheme.button),
      value: globals.GLUTES,
    ));
    muscleList.add(new DropdownMenuItem(
      child: new Text("Quads", style: Theme.of(context).textTheme.button),
      value: globals.QUADS,
    ));
    muscleList.add(new DropdownMenuItem(
      child: new Text("Hamstrings", style: Theme.of(context).textTheme.button),
      value: globals.HAMSTRINGS,
    ));
    muscleList.add(new DropdownMenuItem(
      child: new Text("Calves", style: Theme.of(context).textTheme.button),
      value: globals.CALVES,
    ));
    muscleList.add(new DropdownMenuItem(
      child: new Text("Abs", style: Theme.of(context).textTheme.button),
      value: globals.ABS,
    ));
    muscleList.add(new DropdownMenuItem(
      child: new Text("Obliques", style: Theme.of(context).textTheme.button),
      value: globals.OBLIQUES,
    ));
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
          icon: Icon(Icons.home, color: Colors.white),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MyHomePage(title: "Home")),
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
    for (int i = 0; i < widget.workout.exercises.length; i++) {
      Widget addition = Card(
        color: Theme.of(context).accentColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(widget.workout.exercises[i].name,
                  style: Theme.of(context).textTheme.button),
              subtitle: Text(widget.workout.exercises[i].subtitle(),
                  style: Theme.of(context).textTheme.subtitle1),
              trailing: IconButton(
                icon: Icon(Icons.refresh),
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    widget.workout.getBackup(i);
                  });
                },
              ),
            ),
          ],
        ),
      );
      ls.add(addition);
    }

    ls.add(IconButton(
        icon: Icon(Icons.remove_circle),
        color: Colors.white,
        onPressed: () {
          Future<bool> rm = globals.removeWorkout(widget.workout.name);
          rm.then((b) {
            if (b) {
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => MyHomePage(title: "Home")),
              );
            }
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
      'label': 'Calisthenics Park',
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
                                          builder: (context) =>
                                              MyHomePage(title: "Home")),
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
                  height: MediaQuery.of(context).size.height * .5,
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
                                        builder: (context) =>
                                            MyHomePage(title: "Home")),
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
