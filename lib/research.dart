library workoutcreator.research;

import 'package:flutter/material.dart';
import 'package:workoutcreator/main.dart';
import 'package:workoutcreator/information.dart';
import 'package:url_launcher/url_launcher.dart';

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
        sectionCreator("Supplementation", context),
        sectionCreator("Pre-Workouts", context),
        sectionCreator("Beginner Questions", context),
        sectionCreator("Strength Programs", context),
      ],
    );
  }


  Widget sectionCreator(String sectionName, BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double margin = (width - ( width * 0.8)) / 2;
    return Container(
      alignment: Alignment.center,
      height: 50,
      color: Theme.of(context).accentColor,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(left: margin, right: margin, top: 10, bottom: 10),
      width: width * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: ((width * .8) - 16) * .8,
            child: Text(
              sectionName,
              style: TextStyle( color: Colors.white, fontSize: 20, fontFamily: "Times New Roman"),
            )
          ),
          Container(
            width: ((width * .8) - 16) * .2,
            child: IconButton(
              icon: new Icon(
                Icons.arrow_right,
                color: Colors.white
              ),
              onPressed: () {
                if(sectionName == "Supplementation") {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SupplementsPage(),
                    )
                  );
                } else if (sectionName == "Beginner Questions") {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BeginnerQuestions(),
                    )
                  );
                } else if (sectionName == "Pre-Workouts") {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PreworkoutsPage(),
                    )
                  );
                } else if (sectionName == "Strength Programs") {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProgramsPage(),
                    )
                  );
                }
              }
            ),
          )
        ],
      )
    );
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
        title: Text("Supplements",
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
                  double width = MediaQuery.of(ctxt).size.width /10 * 8;
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
                                   builder: (context) => SupplementInfo(supplement: supplement,)),
                              );
                            },
                          )
                        ),
                      ],
                    )
                  );
                }
              )
            ),
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
        title: Text("Supplements",
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
                  builder: (context) => SupplementsPage()),
            );
          },
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body:Center(
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
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  Text info;
                  if(snapshot.hasData) {
                    if(snapshot.data == null) {
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
                }
              ),
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
        builder: (BuildContext context, AsyncSnapshot<List<Question>> snapshot) {
          if(snapshot.hasData) {
            if(snapshot.data == null) {
              return Text("Something Went Wrong", style: TextStyle(color: Colors.white));
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
                    margin: EdgeInsets.only(top: m / 2, left: m, right: m),
                      child: ExpansionTile(
                        backgroundColor: Theme.of(context).accentColor,
                        title: buildTitle(ctxt, question.question),
                        trailing: SizedBox( width: 0),
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
                }
              );
            }
          } else {
            return Text("Something Went Wrong", style: TextStyle(color: Colors.white));
          }

        }
      )
    );
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
        title: Text("Pre-Workouts",
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
      body: ListView(
        children: <Widget>[
          Container(
            color: Theme.of(context).accentColor,
            width: MediaQuery.of(context).size.width * .8,
            margin: EdgeInsets.only(top: m /2, left: m, right: m),
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
              ]
            ),
          ),
          Container(
            color: Theme.of(context).accentColor,
            width: MediaQuery.of(context).size.width * .8,
            margin: EdgeInsets.only(top: m /2, left: m, right: m),
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
              ]
            ),
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
        builder: (BuildContext context, AsyncSnapshot<List<StrengthProgram>> snapshot) {
          if(snapshot.hasData) {
            if(snapshot.data == null) {
              return Text("Something Went Wrong", style: TextStyle(color: Colors.white));
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
                    margin: EdgeInsets.only(top: m / 2, left: m, right: m),
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
                        if(await canLaunch(program.link)) {
                          await launch(program.link);
                        } else {
                          String link = program.link;
                          throw 'Could not launch $link';
                        }
                      },
                    ),
                  );
                }
              );
            }
          } else {
            return Text("Something Went Wrong", style: TextStyle(color: Colors.white));
          }

        }
      )
    );
  }
}