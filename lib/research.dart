library workoutcreator.research;

import 'package:flutter/material.dart';
import 'package:workoutcreator/main.dart';
import 'package:workoutcreator/information.dart';
import 'package:url_launcher/url_launcher.dart';

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.parse(s, (e) => null) != null;
}

class ResearchHomePage extends StatefulWidget {
  ResearchHomePage({Key key}) : super(key: key);

  @override
  _ResearchHomePage createState() => _ResearchHomePage();
}

class _ResearchHomePage extends State<ResearchHomePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        sectionCreator("Nutrition", context),
        sectionCreator("Supplementation", context),
        sectionCreator("Pre-Workouts", context),
        sectionCreator("Beginner Questions", context),
        sectionCreator("Strength Programs", context),
      ],
    );
  }

  Widget sectionCreator(String sectionName, BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double margin = (width - (width * 0.8)) / 2;
    return Container(
        alignment: Alignment.center,
        height: 50,
        color: Theme.of(context).accentColor,
        padding: EdgeInsets.all(8),
        margin:
            EdgeInsets.only(left: margin, right: margin, top: 10, bottom: 10),
        width: width * 0.8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: ((width * .8) - 16) * .8,
                child: Text(
                  sectionName,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: "Times New Roman"),
                )),
            Container(
              width: ((width * .8) - 16) * .2,
              child: IconButton(
                  icon: new Icon(Icons.arrow_right, color: Colors.white),
                  onPressed: () {
                    if (sectionName == "Supplementation") {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SupplementsPage(),
                          ));
                    } else if (sectionName == "Beginner Questions") {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BeginnerQuestions(),
                          ));
                    } else if (sectionName == "Pre-Workouts") {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PreworkoutsPage(),
                          ));
                    } else if (sectionName == "Strength Programs") {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProgramsPage(),
                          ));
                    } else if (sectionName == "Nutrition") {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NutritionPage(),
                          ));
                    }
                  }),
            )
          ],
        ));
  }
}

class SupplementsPage extends StatefulWidget {
  SupplementsPage({Key key}) : super(key: key);

  @override
  _SupplementsPage createState() => _SupplementsPage();
}

class _SupplementsPage extends State<SupplementsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Supplements", style: Theme.of(context).textTheme.button),
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
                  builder: (context) => MyHomePage(title: "Home", index: 1)),
            );
          },
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        width: MediaQuery.of(context).size.width / 10 * 8,
        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width / 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: ListView.builder(
                    itemCount: supplements.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      String supplement = supplements[index];
                      double width = MediaQuery.of(ctxt).size.width / 10 * 8;
                      return Container(
                          color: Theme.of(context).accentColor,
                          margin: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: width * .75,
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  supplement,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontFamily: "Times New Roman",
                                  ),
                                ),
                              ),
                              Container(
                                  width: width * .25,
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_right),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SupplementInfo(
                                                  supplement: supplement,
                                                )),
                                      );
                                    },
                                  )),
                            ],
                          ));
                    })),
          ],
        ),
      ),
    );
  }
}

class SupplementInfo extends StatefulWidget {
  SupplementInfo({Key key, this.supplement}) : super(key: key);

  final String supplement;
  @override
  _SupplementInfo createState() => _SupplementInfo();
}

class _SupplementInfo extends State<SupplementInfo> {
  String supplement;

  @override
  void initState() {
    super.initState();
    supplement = widget.supplement;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Supplements", style: Theme.of(context).textTheme.button),
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
              MaterialPageRoute(builder: (context) => SupplementsPage()),
            );
          },
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(15.0),
          children: [
            //Need the Supplement Name First
            Container(
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    supplement,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Times New Roman",
                    ),
                  )
                ],
              ),
            ),
            Container(
              color: Colors.grey[200],
              padding: EdgeInsets.all(10),
              child: FutureBuilder<String>(
                  future: getSupplementInfo(supplement),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    Text info;
                    if (snapshot.hasData) {
                      if (snapshot.data == null) {
                        info = Text("Something Went Wrong");
                      } else {
                        info = Text(
                          snapshot.data,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Times New Roman",
                            fontSize: 12,
                          ),
                        );
                      }
                    } else {
                      info = Text("Something Went Wrong");
                    }
                    return info;
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class BeginnerQuestions extends StatefulWidget {
  BeginnerQuestions({Key key}) : super(key: key);

  @override
  _BeginnerQuestions createState() => _BeginnerQuestions();
}

class _BeginnerQuestions extends State<BeginnerQuestions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Beginner Questions",
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
                    builder: (context) => MyHomePage(title: "Home", index: 1)),
              );
            },
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: FutureBuilder(
            future: getQuestions(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Question>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == null) {
                  return Text("Something Went Wrong",
                      style: TextStyle(color: Colors.white));
                } else {
                  //Success
                  List<Question> questions = snapshot.data;
                  return ListView.builder(
                      itemCount: questions.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        Question question = questions[index];
                        double m = MediaQuery.of(ctxt).size.width / 10;
                        return Container(
                          color: Theme.of(context).accentColor,
                          width: MediaQuery.of(ctxt).size.width / 10 * 8,
                          margin:
                              EdgeInsets.only(top: m / 2, left: m, right: m),
                          child: ExpansionTile(
                            backgroundColor: Theme.of(context).accentColor,
                            title: buildTitle(ctxt, question.question),
                            trailing: SizedBox(width: 0),
                            children: <Widget>[
                              Container(
                                color: Colors.white,
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  question.answer,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: "Times New Roman",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                }
              } else {
                return Text("Something Went Wrong",
                    style: TextStyle(color: Colors.white));
              }
            }));
  }

  Row buildTitle(BuildContext context, String question) {
    double width = MediaQuery.of(context).size.width / 10 * 8 * .8 * .95;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width * .8,
          child: Text(
            question,
            overflow: TextOverflow.visible,
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Times New Roman",
              fontSize: 15,
            ),
          ),
        ),
        Container(
          width: width * .2,
          child: Icon(
            Icons.menu,
            color: Colors.white,
            size: 15,
          ),
        ),
      ],
    );
  }
}

class PreworkoutsPage extends StatefulWidget {
  PreworkoutsPage({Key key}) : super(key: key);

  @override
  _PreworkoutsPage createState() => _PreworkoutsPage();
}

class _PreworkoutsPage extends State<PreworkoutsPage> {
  //Will be constructed a lot like the Beginner Questions Page
  //Use expandable cards
  @override
  Widget build(BuildContext context) {
    double m = MediaQuery.of(context).size.width / 10;
    return Scaffold(
      appBar: AppBar(
        title: Text("Pre-Workouts", style: Theme.of(context).textTheme.button),
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
                  builder: (context) => MyHomePage(title: "Home", index: 1)),
            );
          },
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: ListView(
        children: <Widget>[
          Container(
            color: Theme.of(context).accentColor,
            width: MediaQuery.of(context).size.width * .8,
            margin: EdgeInsets.only(top: m / 2, left: m, right: m),
            child: ExpansionTile(
                backgroundColor: Theme.of(context).accentColor,
                title: buildTitle(context, "What to look for?"),
                trailing: SizedBox(),
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "In Pre-Workouts, typically companies will use filler supplements to make their formula look more full, or just to make you feel something. " +
                          "Some of these filler ingredients may be low doses of Beta-Alanine, or Citrulline Malate. (L-)Citrulline is a desired ingredients in preworkouts, however when companies write Citrulline Malate they are mixing it with Malic Acid, making the dosage of citrulline on the label \'incorrect\' and saving the company money.  A lot of pre-workouts will have low doses of good supplements, which doesn't effectively give the most efficient results, look for a Pre-workout with good dosing for good results.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: "Times New Roman",
                      ),
                    ),
                  )
                ]),
          ),
          Container(
            color: Theme.of(context).accentColor,
            width: MediaQuery.of(context).size.width * .8,
            margin: EdgeInsets.only(top: m / 2, left: m, right: m),
            child: ExpansionTile(
                backgroundColor: Theme.of(context).accentColor,
                title: buildTitle(context, "Recommended Pre-Workouts"),
                trailing: SizedBox(),
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Gorilla Mode: Gorilla Mode is a pump and energy focused pre-workout that has no filler ingredients and good doses of supplements, so you don\'t need to buy many additional supplements.\n" +
                          "Crack Preworkout: This high stim preworkout is a decent pre-workout that has lots of caffiene and a decent amount of other supplements, however it does contain Beta-Alanine at not the most potent dose, so it will make your skin crawl.\n",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: "Times New Roman",
                      ),
                    ),
                  )
                ]),
          ),
        ],
      ),
    );
  }

  Row buildTitle(BuildContext context, String title) {
    double width = MediaQuery.of(context).size.width / 10 * 8 * .8 * .95;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width * .8,
          child: Text(
            title,
            overflow: TextOverflow.visible,
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Times New Roman",
              fontSize: 15,
            ),
          ),
        ),
        Container(
          width: width * .2,
          child: Icon(
            Icons.menu,
            color: Colors.white,
            size: 15,
          ),
        ),
      ],
    );
  }
}

class ProgramsPage extends StatefulWidget {
  ProgramsPage({Key key}) : super(key: key);

  @override
  _ProgramsPage createState() => _ProgramsPage();
}

class _ProgramsPage extends State<ProgramsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Strength Programs",
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
                    builder: (context) => MyHomePage(title: "Home", index: 1)),
              );
            },
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: FutureBuilder(
            future: getStrengthPrograms(),
            builder: (BuildContext context,
                AsyncSnapshot<List<StrengthProgram>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == null) {
                  return Text("Something Went Wrong",
                      style: TextStyle(color: Colors.white));
                } else {
                  //Success
                  List<StrengthProgram> programs = snapshot.data;
                  return ListView.builder(
                      itemCount: programs.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        StrengthProgram program = programs[index];
                        double m = MediaQuery.of(ctxt).size.width / 10;
                        return Container(
                          color: Theme.of(context).accentColor,
                          width: MediaQuery.of(ctxt).size.width / 10 * 8,
                          margin:
                              EdgeInsets.only(top: m / 2, left: m, right: m),
                          child: FlatButton(
                            color: Theme.of(context).accentColor,
                            child: Text(
                              program.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Times New Roman",
                                fontSize: 25,
                              ),
                            ),
                            onPressed: () async {
                              if (await canLaunch(program.link)) {
                                await launch(program.link);
                              } else {
                                String link = program.link;
                                throw 'Could not launch $link';
                              }
                            },
                          ),
                        );
                      });
                }
              } else {
                return Text("Something Went Wrong",
                    style: TextStyle(color: Colors.white));
              }
            }));
  }
}

class NutritionPage extends StatefulWidget {
  NutritionPage({Key key}) : super(key: key);

  @override
  _NutritionPage createState() => _NutritionPage();
}

class _NutritionPage extends State<NutritionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Nutrition", style: Theme.of(context).textTheme.button),
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
                    builder: (context) => MyHomePage(title: "Home", index: 1)),
              );
            },
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: FutureBuilder(
            future: getNutritionInfo(),
            builder: (BuildContext context,
                AsyncSnapshot<List<NutritionInfo>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == null) {
                  return Text("Something Went Wrong",
                      style: TextStyle(color: Colors.white));
                } else {
                  //Success
                  List<NutritionInfo> questions = snapshot.data;
                  return ListView.builder(
                      itemCount: questions.length + 1,
                      itemBuilder: (BuildContext ctxt, int index) {
                        double m = MediaQuery.of(ctxt).size.width / 10;
                        if (index == 0) {
                          return Container(
                            color: Theme.of(context).accentColor,
                            width: MediaQuery.of(ctxt).size.width / 10 * 8,
                            margin:
                                EdgeInsets.only(top: m / 2, left: m, right: m),
                            height: 50,
                            child: SizedBox.expand(
                              child: FlatButton(
                                color: Theme.of(context).accentColor,
                                child: Text(
                                  "Calorie Calculator",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Times New Roman",
                                    fontSize: 15,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CalorieCalculator()),
                                  );
                                },
                              ),
                            ),
                          );
                        } else {
                          index -= 1;
                        }
                        NutritionInfo question = questions[index];

                        return Container(
                          color: Theme.of(context).accentColor,
                          width: MediaQuery.of(ctxt).size.width / 10 * 8,
                          margin:
                              EdgeInsets.only(top: m / 2, left: m, right: m),
                          child: ExpansionTile(
                            backgroundColor: Theme.of(context).accentColor,
                            title: buildTitle(ctxt, question.title),
                            trailing: SizedBox(width: 0),
                            children: <Widget>[
                              Container(
                                color: Colors.white,
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  question.content,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: "Times New Roman",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                }
              } else {
                return Text("Something Went Wrong",
                    style: TextStyle(color: Colors.white));
              }
            }));
  }

  Row buildTitle(BuildContext context, String question) {
    double width = MediaQuery.of(context).size.width / 10 * 8 * .8 * .95;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width * .8,
          child: Text(
            question,
            overflow: TextOverflow.visible,
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Times New Roman",
              fontSize: 15,
            ),
          ),
        ),
        Container(
          width: width * .2,
          child: Icon(
            Icons.menu,
            color: Colors.white,
            size: 15,
          ),
        ),
      ],
    );
  }
}

class CalorieCalculator extends StatefulWidget {
  CalorieCalculator({Key key}) : super(key: key);

  @override
  _CalorieCalculator createState() => _CalorieCalculator();
}

class _CalorieCalculator extends State<CalorieCalculator> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  String unitH = "in";
  String unitW = "lbs";
  String sex = "Male";
  int activity = 0;
  //UNIT DROPDOWN METHODS
  List<DropdownMenuItem<String>> unitsW = [
    new DropdownMenuItem(
      child: new Text("Pounds", style: TextStyle(color: Colors.white)),
      value: "lbs",
    ),
    new DropdownMenuItem(
      child: new Text("Kilograms", style: TextStyle(color: Colors.white)),
      value: "kgs",
    ),
  ];
  List<DropdownMenuItem<String>> unitsH = [
    new DropdownMenuItem(
      child: new Text("inches", style: TextStyle(color: Colors.white)),
      value: "in",
    ),
    new DropdownMenuItem(
      child: new Text("cm", style: TextStyle(color: Colors.white)),
      value: "cm",
    ),
  ];

  Widget getUnitButton(BuildContext context, String u) {
    List<DropdownMenuItem<String>> items;
    if (u == "height") {
      items = unitsH;
    } else {
      items = unitsW;
    }
    return Container(
      width: MediaQuery.of(context).size.width * .8 * .4,
      child: DropdownButton(
          dropdownColor: Theme.of(context).accentColor,
          focusColor: Color(0xFF525252),
          items: items,
          hint: new Text(
            'Select Units',
            style: TextStyle(color: Colors.white),
          ),
          value: u == "height" ? unitH : unitW,
          onChanged: (value) {
            setState(() {
              if (u == "height") {
                unitH = value;
              } else {
                unitW = value;
              }
            });
          }),
    );
  }

  String dailyCalories = "";
  @override
  Widget build(BuildContext context) {
    double rowWidth = MediaQuery.of(context).size.width * .8;
    double m = MediaQuery.of(context).size.width * .1;
    return Scaffold(
      appBar: AppBar(
        title: Text("Calorie Calculator",
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
              MaterialPageRoute(builder: (context) => NutritionPage()),
            );
          },
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //Age
                Container(
                  width: rowWidth,
                  margin: EdgeInsets.only(left: m, right: m, top: m / 2),
                  child: TextFormField(
                    style: Theme.of(context).textTheme.button,
                    cursorColor: Colors.white,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Need age';
                      } else if (!isNumeric(value)) {
                        return 'Age needs to be a number';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Age',
                      labelStyle: TextStyle(color: Color(0xFFdbdbdb)),
                      contentPadding: EdgeInsets.all(20.0),
                    ),
                    controller: ageController,
                  ),
                ),
                //Sex
                Container(
                  color: Colors.white,
                  width: rowWidth + 20,
                  margin:
                      EdgeInsets.only(left: m - 10, right: m - 10, top: m / 2),
                  child: Row(
                    children: [
                      Container(
                        width: (rowWidth + 20) / 2,
                        child: ListTile(
                          title: const Text('Male'),
                          leading: Radio(
                            value: "Male",
                            groupValue: sex,
                            onChanged: (String value) {
                              setState(() {
                                sex = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Container(
                        width: (rowWidth + 20) / 2,
                        child: ListTile(
                          title: const Text('Female'),
                          leading: Radio(
                            value: "Female",
                            groupValue: sex,
                            onChanged: (String value) {
                              setState(() {
                                sex = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //Height
                Container(
                  width: rowWidth,
                  margin: EdgeInsets.only(
                    left: m,
                    right: m,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .8 * .6,
                        child: TextFormField(
                          style: Theme.of(context).textTheme.button,
                          cursorColor: Colors.white,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'You need to enter a height!';
                            } else if (!isNumeric(value)) {
                              return 'Height is not a number';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Height',
                            labelStyle: TextStyle(color: Color(0xFFdbdbdb)),
                          ),
                          controller: heightController,
                        ),
                      ),
                      getUnitButton(context, "height"),
                    ],
                  ),
                ),
                //Weight
                Container(
                  width: rowWidth,
                  margin: EdgeInsets.only(
                    left: m,
                    right: m,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .8 * .6,
                        child: TextFormField(
                          style: Theme.of(context).textTheme.button,
                          cursorColor: Colors.white,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'You need to enter a weight!';
                            } else if (!isNumeric(value)) {
                              return 'Weight is not a number';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Weight',
                            labelStyle: TextStyle(color: Color(0xFFdbdbdb)),
                          ),
                          controller: weightController,
                        ),
                      ),
                      getUnitButton(context, "weight"),
                    ],
                  ),
                ),
                //Activity
                Container(
                  color: Colors.white,
                  width: rowWidth + 25,
                  margin: EdgeInsets.only(
                      left: m - 12.5, right: m - 12.5, top: m / 2),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: (rowWidth + 25) / 2,
                            child: ListTile(
                              title: const Text('Inactive',
                                  style: TextStyle(fontSize: 12)),
                              leading: Radio(
                                value: 0,
                                groupValue: activity,
                                onChanged: (int value) {
                                  setState(() {
                                    activity = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          Container(
                            width: (rowWidth + 25) / 2,
                            child: ListTile(
                              title: const Text('Light Activity',
                                  style: TextStyle(fontSize: 12)),
                              leading: Radio(
                                value: 1,
                                groupValue: activity,
                                onChanged: (int value) {
                                  setState(() {
                                    activity = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: (rowWidth + 25) / 2,
                            child: ListTile(
                              title: const Text('Medium Activity',
                                  style: TextStyle(fontSize: 12)),
                              leading: Radio(
                                value: 2,
                                groupValue: activity,
                                onChanged: (int value) {
                                  setState(() {
                                    activity = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          Container(
                            width: (rowWidth + 25) / 2,
                            child: ListTile(
                              title: const Text('Very Active',
                                  style: TextStyle(fontSize: 12)),
                              leading: Radio(
                                value: 3,
                                groupValue: activity,
                                onChanged: (int value) {
                                  setState(() {
                                    activity = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                //Calculate Button
                Container(height: 20),
                Container(
                  width: rowWidth,
                  height: 50,
                  child: SizedBox.expand(
                    child: FlatButton(
                      color: tertiaryColor,
                      child: Text(
                        "Calculate",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Times New Roman",
                        ),
                      ),
                      onPressed: () {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }
                        double height = double.parse(heightController.text);
                        double weight = double.parse(weightController.text);
                        double age = double.parse(ageController.text);
                        double mp;
                        switch (activity) {
                          case 0:
                            mp = 1.2;
                            break;
                          case 1:
                            mp = 1.35;
                            break;
                          case 2:
                            mp = 1.5;
                            break;
                          case 3:
                            mp = 1.7;
                            break;
                        }
                        if (unitH == "in") {
                          height = height * 2.54;
                        }
                        if (unitW == "lbs") {
                          weight = weight / 2.205;
                        }
                        if (sex == "Male") {
                          double bmr = 88.362 +
                              (13.397 * weight) +
                              (4.799 * height) -
                              (5.677 * age);
                          double cal = bmr * mp;
                          int temp = cal.truncate();
                          setState(() {
                            dailyCalories = "$temp Calories";
                          });
                        } else {
                          double bmr = 447.593 +
                              (9.247 * weight) +
                              (3.098 * height) -
                              (4.330 * age);
                          double cal = bmr * mp;
                          int temp = cal.truncate();
                          setState(() {
                            dailyCalories = "$temp Calories";
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(dailyCalories,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Times New Roman",
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ))
            ],
          )
        ],
      ),
    );
  }
}
