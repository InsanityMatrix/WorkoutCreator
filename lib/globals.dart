library workoutcreator.globals;

import 'dart:math';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
class Workout {
  String name;
  List<Exercise> exercises;
  List<Exercise> backups;
  Workout(this.name, this.exercises);
  Workout.withBackups(this.name, this.exercises, this.backups);
  String getName() {
    return name;
  }
  void getBackup(int index) {
    int muscle = this.exercises[index].primaryMuscle;
    List<Exercise> replacements = [];
    for(int i = 0; i < this.backups.length; i++) {
      if(this.backups[i].isPrimaryMuscle(muscle)) {
        replacements.add(this.backups[i]);
      }
    }
    if(replacements.length == 0) {
      return;
    }
    if(replacements.length == 1) {
      Exercise temp = this.exercises[index];
      this.exercises[index] = replacements[0];
      int oIndex = this.backups.indexOf(replacements[0]);
      this.backups[oIndex] = temp;
      return;
    } else {
      Random random = new Random();
      Exercise replacement = replacements[random.nextInt(replacements.length)];
      Exercise temp = this.exercises[index];
      this.exercises[index] = replacement;
      int oIndex = this.backups.indexOf(replacement);
      this.backups[oIndex] = temp;
      return;
    }
  }

  Map<String, dynamic> toJson() => {
    'Name':name,
    'Exercises':exercises,
    'Backups': backups,
  };
}

class Exercise {
  String name;
  int primaryMuscle;
  List<int> secondaryMuscles;
  
  Exercise(this.name, this.primaryMuscle, this.secondaryMuscles);
  Map<String, dynamic> toJson() => {
    'Name':name,
    'PrimaryMuscles':primaryMuscle,
    'SecondaryMuscles':secondaryMuscles,
  };

  bool isPrimaryMuscle(int pMuscle) {
    return this.primaryMuscle == pMuscle;
  }
  bool containsSecondaryMuscle(int sMuscle) {
    if(this.secondaryMuscles == null) {
      return false;
    }
    for(int i = 0; i < this.secondaryMuscles.length; i++) {
      if(this.secondaryMuscles[i] == sMuscle) {
        return true;
      }
    }
    return false;
  }
  @override
  String toString() {
    return this.name;
  }

  String subtitle() {
    String st = "Primary Muscle: " + getMuscleName(this.primaryMuscle) + "| Secondary Muscles: ";
    if(this.secondaryMuscles == null) {
      st += "none";
    } else {
      for(int i = 0; i < this.secondaryMuscles.length; i++) {
        st += getMuscleName(this.secondaryMuscles[i]);
        if (i + 1 < this.secondaryMuscles.length) {
          st += ", ";
        }
      }
    }
    return st;
  }
}


const int TRAPEZIUS = 0;
const int DELTOIDS = 1;
const int TRICEPS = 2;
const int BICEPS = 3;
const int CHEST = 4;
const int RHOMBOIDS = 5;
const int LATS = 6;
const int GLUTES = 7;
const int QUADS = 8;
const int CALVES = 9;
const int ABS = 10;
const int OBLIQUES = 11;

//NEW MUSCLES
const int HAMSTRINGS = 12;
//DECLARE EXERCISES
//TODO: ADD MORE EXERCISES
//Upper Body Exercises
Exercise SHRUGS = new Exercise("Shrugs", TRAPEZIUS, null);
Exercise FARMERS_WALK = new Exercise("Farmers Walk", TRAPEZIUS, [DELTOIDS, ABS, OBLIQUES, CALVES]);
Exercise BENCHPRESS = new Exercise("Benchpress", CHEST, [DELTOIDS,TRICEPS, ABS]);
Exercise SHOULDER_PRESS = new Exercise("Shoulder Press", DELTOIDS, [TRAPEZIUS, TRICEPS, ABS]);
Exercise DIPS = new Exercise("Dips", TRICEPS, [CHEST, DELTOIDS, RHOMBOIDS]);
Exercise CONCENTRATION_CURLS = new Exercise("Concentration Curls", BICEPS, null);
Exercise BENT_OVER_BARBELL_ROW = new Exercise("Bent over barbell row", DELTOIDS, [TRAPEZIUS, LATS, RHOMBOIDS, BICEPS]);
Exercise LATERAL_RAISES = new Exercise("Lateral Raises", DELTOIDS, [TRAPEZIUS]);
Exercise PULLUPS = new Exercise("Pullups", LATS, [TRAPEZIUS, RHOMBOIDS, BICEPS]);
Exercise CHINUPS = new Exercise("Chinups", BICEPS, [LATS, DELTOIDS,]);
Exercise LAT_PULLDOWNS = new Exercise("Lat Pulldowns", LATS, [RHOMBOIDS, TRAPEZIUS]);
Exercise REAR_DELT_FLY = new Exercise("Rear Delt Fly", DELTOIDS, [TRAPEZIUS, RHOMBOIDS]);
Exercise ARNOLD_PRESS = new Exercise("Arnold Press", DELTOIDS, [TRICEPS]);
Exercise W_Raise = new Exercise("W-Raise", DELTOIDS, [TRAPEZIUS]);
Exercise TRICEP_KICKBACK = new Exercise("Tricep Kickback", TRICEPS, null);
Exercise SKULL_CRUSHERS = new Exercise("Skullcrushers", TRICEPS, null);
Exercise HAMMER_CURL = new Exercise("Hammer Curls", BICEPS, null);
Exercise CHEST_FLY = new Exercise("Chest Fly", CHEST, [DELTOIDS]);
Exercise PEC_DECK = new Exercise("Pec Deck", CHEST, null);
Exercise PRONE_LATERAL_RAISE = new Exercise("Prone Lateral Raise", RHOMBOIDS, null);
Exercise BENT_OVER_DUMBELL_ROW = new Exercise("Bent Over Dumbell Row", RHOMBOIDS, [DELTOIDS, TRAPEZIUS, LATS]);
Exercise SQUEEZE_PRESS = new Exercise("Squeeze Press", CHEST, [TRICEPS]);
Exercise PLATE_PRESS = new Exercise("Plate Press", CHEST, [TRICEPS]);
//Lower Body
Exercise DEADLIFT = new Exercise("Deadlift", GLUTES, [QUADS, LATS, TRAPEZIUS]);
Exercise BACK_SQUAT = new Exercise("Back Squat", GLUTES, [HAMSTRINGS, QUADS]);
Exercise FRONT_SQUAT = new Exercise("Front Squat", QUADS, [ABS, GLUTES, HAMSTRINGS]);
Exercise GOBLET_SQUAT = new Exercise("Goblet Squat", QUADS, [CALVES, GLUTES, ABS, HAMSTRINGS]);
Exercise HIP_THRUSTS = new Exercise("Hip Thrust", GLUTES, null);
Exercise LEG_CURL = new Exercise("Leg Curl", HAMSTRINGS, [CALVES]);
Exercise LEG_EXTENSIONS = new Exercise("Leg Extensions", QUADS, null);
Exercise STANDING_CALF_RAISE = new Exercise("Standing Calf Raise", CALVES, null);
Exercise SEATED_CALF_RAISE = new Exercise("Seated Calf Raise", CALVES, null);
//Core
Exercise RUSSIAN_TWISTS = new Exercise("Russian Twists", OBLIQUES, [ABS]);
Exercise LEG_LIFTS = new Exercise("Leg Lifts", ABS, null);
Exercise CRUNCHES = new Exercise("Crunches", ABS, null);




List<Exercise> EXERCISES = [
  SHRUGS, BENCHPRESS, SHOULDER_PRESS, DIPS, CONCENTRATION_CURLS,
  FARMERS_WALK, BENT_OVER_BARBELL_ROW, LATERAL_RAISES, PULLUPS,
  CHINUPS, LAT_PULLDOWNS, DEADLIFT, REAR_DELT_FLY, ARNOLD_PRESS,
  TRICEP_KICKBACK, SKULL_CRUSHERS,HAMMER_CURL,CHEST_FLY,PEC_DECK,
  PRONE_LATERAL_RAISE, BENT_OVER_DUMBELL_ROW, BACK_SQUAT, FRONT_SQUAT,
  GOBLET_SQUAT, HIP_THRUSTS, LEG_CURL, LEG_EXTENSIONS, SQUEEZE_PRESS,
  PLATE_PRESS, RUSSIAN_TWISTS, LEG_LIFTS, CRUNCHES,STANDING_CALF_RAISE, 
  SEATED_CALF_RAISE,

];

Workout createWorkout(String name, List<int> selectedMuscles) {
  List<Exercise> finalList = [];
  List<Exercise> lowPriorityList = [];
  List<Exercise> highPriorityList = [];
  List<Exercise> backups = [];
  for(int i = 0; i < selectedMuscles.length; i++) {
    for(int j = 0; j < EXERCISES.length; j++) {
      if(EXERCISES[j].isPrimaryMuscle(selectedMuscles[i])) {
        lowPriorityList.add(EXERCISES[j]);
      }
    }
  }
  print("Low Priority " + lowPriorityList.toString());
  for(int i = 0; i < selectedMuscles.length; i++) {
    for(int j = 0; j < lowPriorityList.length; j++) {
      if(lowPriorityList[j].containsSecondaryMuscle(selectedMuscles[i])) {
        highPriorityList.add(lowPriorityList[j]);
        lowPriorityList.remove(lowPriorityList[j]);
        j--;
      }
    }
  }
  //Remove duplicates from list
  highPriorityList = highPriorityList.toSet().toList();
  print("New Low Priority " + lowPriorityList.toString());
  print("High Priority " + highPriorityList.toString());
  //Check if there are two exercises with a selected muscle as primary for every single muscle selected
  for(int i = 0; i < selectedMuscles.length; i++) {
    List<Exercise> choices = [];
    int timesPrimary = 0;
    for(int j = 0; j < highPriorityList.length; j++) {
      if(highPriorityList[j].isPrimaryMuscle(selectedMuscles[i])) {
        choices.add(highPriorityList[j]);
        timesPrimary++;
      }
    }
    //If this case is true, timesPrimary will be less than 2
    if(choices.length > 2) {
      for(int k = 0; k < 2; k++) {
        Random random = new Random();
        int randomNumber = random.nextInt(choices.length);
        finalList.add(choices[randomNumber]);
        choices.removeAt(randomNumber);
      }
    } else if(choices.length == 2) {
      for(int k = 0; k < 2; k++) {
        finalList.add(choices[0]);
        choices.removeAt(0);
      }
    } else if(choices.length == 1) {
      finalList.add(choices[0]);
      choices.removeAt(0);
    }
    for(int k = 0; k < choices.length; k++) {
      backups.add(choices[k]);
    }
    if(timesPrimary < 2) {
      choices = [];
      for(int j = 0; j < lowPriorityList.length; j++) {
        if(lowPriorityList[j].isPrimaryMuscle(selectedMuscles[i])) {
          choices.add(lowPriorityList[j]);
        }
      }

      if(timesPrimary == 1) {
        Random random = new Random();
        if(choices.length != 0) {
          int randomNumber = random.nextInt(choices.length);
          finalList.add(choices[randomNumber]);
          choices.removeAt(randomNumber);
        }
      }
      if(timesPrimary == 0) {
        Random random = new Random();
        for(int j = 0; j < 2; j++) {
          if(choices.length > 0) {
            int randomNumber = random.nextInt(choices.length);
            finalList.add(choices[randomNumber]);
            choices.removeAt(randomNumber);
          }
        }
      }
      for(int k = 0; k < choices.length; k++) {
         backups.add(choices[k]);
      }
    } else {
      choices = [];
      for(int j = 0; j < lowPriorityList.length; j++) {
        if(lowPriorityList[j].isPrimaryMuscle(selectedMuscles[i])) {
          backups.add(lowPriorityList[j]);
        }
      }
    }
  }
  print("Final List: " + finalList.toString());
  Workout workout = new Workout.withBackups(name, finalList,backups);
  saveWorkout(workout);
  return workout;
}
void saveWorkout(Workout workout) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  final wName = workout.getName() + ".json";
  File wFile = File('$path/$wName');
  String json = jsonEncode(workout);
  print(json);
  wFile.writeAsString(json);
}
Future<bool> removeWorkout(String name) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  String fileName = name + ".json";
  File wFile = File('$path/$fileName');
  wFile.delete();
  return true;
}
Future<List<String>> getWorkouts() async {
  final directory = await getApplicationDocumentsDirectory();
  List<String> names = [];
  directory.list(recursive: false).forEach((f) {
    print("Path: " + f.path);
    String n = f.path.split("/").last;
    if(n != "flutter_assets" && !n.startsWith("res_timestamp")) {
          names.add(n.replaceAll(".json", ""));
    }
  });
  print(names.toString());
  return names;
}

Future<Workout> getWorkout(String filename) async {
  Workout workout;
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  File wFile = File('$path/$filename');
  String json = await wFile.readAsString();
  var decoded = jsonDecode(json);
  List<Exercise> exercises = [];
  List ex = decoded['Exercises'];
  ex.forEach((i){
    List<int> secondaryMuscles = [];
    List scm = i['SecondaryMuscles'];
    if (scm != null) {
      scm.forEach((j){
        secondaryMuscles.add(j);
      });
    }
    exercises.add(new Exercise(i['Name'], i['PrimaryMuscles'], secondaryMuscles));
  });
  List<Exercise> backups = [];
  List bc = decoded['Backups'];
  bc.forEach((i){
    List<int> secondaryMuscles = [];
    List scm = i['SecondaryMuscles'];
    if (scm != null) {
      scm.forEach((j){
        secondaryMuscles.add(j);
      });
    }
    backups.add(new Exercise(i['Name'], i['PrimaryMuscles'], secondaryMuscles));
  });
  workout = Workout.withBackups(decoded['Name'],exercises,backups);
  return workout;
}
String getMuscleName(int muscle) {
  switch(muscle) {
    case TRAPEZIUS:
      return "Trapezius";
      break;
    case DELTOIDS:
      return "Deltoids";
      break;
    case TRICEPS:
      return "Triceps";
      break;
    case BICEPS:
      return "Biceps";
      break;
    case CHEST:
      return "Chest";
      break;
    case RHOMBOIDS:
      return "Rhomboids";
      break;
    case LATS:
      return "Lats";
      break;
    case GLUTES:
      return "Glutes";
      break;
    case QUADS:
      return "Quads";
      break;
    case CALVES:
      return "Calves";
      break;
    case ABS:
      return "Abs";
      break;
    case OBLIQUES:
      return "Obliques";
      break;
    case HAMSTRINGS:
      return "Hamstrings";
      break;
  } 
}