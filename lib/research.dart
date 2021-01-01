library workoutcreator.research;

import 'package:flutter/material.dart';
import 'package:workoutcreator/main.dart';
import 'package:workoutcreator/information.dart';

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
        sectionCreator("Gaining Muscle", context),
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
      color: Colors.blue,
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
                //TODO: Navigate to a page about this topic
                if(sectionName == "Supplementation") {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SupplementsPage(),
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
          icon: Icon(Icons.home, color: Colors.white),
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
                    color: Colors.blue,
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