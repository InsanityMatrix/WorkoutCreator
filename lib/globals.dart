library workoutcreator.globals;

import 'dart:math';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:workoutcreator/config.dart';
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
      saveWorkout(this);
      return;
    } else {
      Random random = new Random();
      Exercise replacement = replacements[random.nextInt(replacements.length)];
      Exercise temp = this.exercises[index];
      this.exercises[index] = replacement;
      int oIndex = this.backups.indexOf(replacement);
      this.backups[oIndex] = temp;
      saveWorkout(this);
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
  List<String> equipment;
  
  Exercise(this.name, this.primaryMuscle, this.secondaryMuscles, this.equipment);
  Map<String, dynamic> toJson() => {
    'Name':name,
    'PrimaryMuscles':primaryMuscle,
    'SecondaryMuscles':secondaryMuscles,
    'Equipment': equipment,
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
// ignore: non_constant_identifier_names
Exercise SHRUGS = new Exercise("Shrugs", TRAPEZIUS, null, ["dumbbell", "barbell"]);
// ignore: non_constant_identifier_names
Exercise FARMERS_WALK = new Exercise("Farmers Walk", TRAPEZIUS, [DELTOIDS, ABS, OBLIQUES, CALVES], ["dumbbell", "barbell"]);
// ignore: non_constant_identifier_names
Exercise BENCHPRESS = new Exercise("Benchpress", CHEST, [DELTOIDS,TRICEPS, ABS], ["barbell", "dumbbell"]);
// ignore: non_constant_identifier_names
Exercise SHOULDER_PRESS = new Exercise("Shoulder Press", DELTOIDS, [TRAPEZIUS, TRICEPS, ABS], ["barbell", "dumbbell"]);
// ignore: non_constant_identifier_names
Exercise DIPS = new Exercise("Dips", TRICEPS, [CHEST, DELTOIDS, RHOMBOIDS], ["dipbars", "calisthenics"]);
Exercise CONCENTRATION_CURLS = new Exercise("Concentration Curls", BICEPS, null, ["dumbbell"]);
Exercise BENT_OVER_BARBELL_ROW = new Exercise("Bent over barbell row", DELTOIDS, [TRAPEZIUS, LATS, RHOMBOIDS, BICEPS], ["barbell"]);
Exercise LATERAL_RAISES = new Exercise("Lateral Raises", DELTOIDS, [TRAPEZIUS], ["dumbbell"]);
Exercise PULLUPS = new Exercise("Pullups", LATS, [TRAPEZIUS, RHOMBOIDS, BICEPS], ["pullupbar", "calisthenics"]);
Exercise CHINUPS = new Exercise("Chinups", BICEPS, [LATS, DELTOIDS,], ["pullupbar", "calisthenics"]);
Exercise LAT_PULLDOWNS = new Exercise("Lat Pulldowns", LATS, [RHOMBOIDS, TRAPEZIUS], ["cable"]);
Exercise REAR_DELT_FLY = new Exercise("Rear Delt Fly", DELTOIDS, [TRAPEZIUS, RHOMBOIDS], ["flymachine", "dumbbell"]);
Exercise ARNOLD_PRESS = new Exercise("Arnold Press", DELTOIDS, [TRICEPS], ["dumbbell"]);
Exercise W_Raise = new Exercise("W-Raise", DELTOIDS, [TRAPEZIUS], ["dumbbell"]);
Exercise TRICEP_KICKBACK = new Exercise("Tricep Kickback", TRICEPS, null, ["dumbbell"]);
Exercise SKULL_CRUSHERS = new Exercise("Skullcrushers", TRICEPS, null, ["barbell","dumbbell"]);
Exercise HAMMER_CURL = new Exercise("Hammer Curls", BICEPS, null, ["dumbbell"]);
Exercise INCLINE_DUMBBELL_CURL = new Exercise("Incline Dumbbell Curl", BICEPS, null, ["dumbbell"]);
Exercise SPIDER_CURLS = new Exercise("Spider Curls", BICEPS, null, ["dumbbell"]);
Exercise CHEST_FLY = new Exercise("Chest Fly", CHEST, [DELTOIDS], ["flymachine","dumbbell"]);
Exercise PRONE_LATERAL_RAISE = new Exercise("Prone Lateral Raise", RHOMBOIDS, null, ["dumbbell"]);
Exercise BENT_OVER_DUMBELL_ROW = new Exercise("Bent Over Dumbell Row", RHOMBOIDS, [DELTOIDS, TRAPEZIUS, LATS], ["dumbbell"]);
Exercise SQUEEZE_PRESS = new Exercise("Squeeze Press", CHEST, [TRICEPS], ["dumbbell"]);
Exercise PLATE_PRESS = new Exercise("Plate Press", CHEST, [TRICEPS], ["barbell"]);
Exercise PUSHUPS = new Exercise("Pushups", CHEST, [TRICEPS], ["calisthenics"]);
//Lower Body
Exercise DEADLIFT = new Exercise("Deadlift", GLUTES, [QUADS, LATS, TRAPEZIUS], ["barbell", "dumbbell"]);
Exercise ROMANIAN_DEADLIFT = new Exercise("Romanian Deadlifts", HAMSTRINGS, [GLUTES, QUADS], ["barbell","dumbbell"]);
Exercise BACK_SQUAT = new Exercise("Back Squat", GLUTES, [HAMSTRINGS, QUADS], ["barbell"]);
Exercise FRONT_SQUAT = new Exercise("Front Squat", QUADS, [ABS, GLUTES, HAMSTRINGS], ["barbell"]);
Exercise GOBLET_SQUAT = new Exercise("Goblet Squat", QUADS, [CALVES, GLUTES, ABS, HAMSTRINGS], ["dumbbell"]);
Exercise HIP_THRUSTS = new Exercise("Hip Thrust", GLUTES, null, ["barbell"]);
Exercise BULGARIAN_SPLIT_SQUATS = new Exercise("Bulgarian Split Squats", QUADS, [GLUTES, HAMSTRINGS, CALVES], ["dumbbell", "barbell"]);
Exercise SINGLE_LEG_DEADLIFT = new Exercise("Single Leg Deadlift", GLUTES, [QUADS], ["dumbbell"]);
Exercise LUNGES = new Exercise("Dumbbell Lunges", QUADS, [GLUTES, HAMSTRINGS], ["dumbbell"]);
Exercise LATERAL_LUNGES = new Exercise("Lateral Lunge", GLUTES, [QUADS], ["dumbbell", "calisthenics"]);
//TODO: Add this equipment
Exercise LEG_CURL = new Exercise("Leg Curl", HAMSTRINGS, [CALVES], ["legmachine"]);
Exercise LEG_EXTENSIONS = new Exercise("Leg Extensions", QUADS, null, ["legmachine"]);

Exercise STANDING_CALF_RAISE = new Exercise("Standing Calf Raise", CALVES, null, ["barbell", "dumbbell","calisthenics"]);
Exercise SEATED_CALF_RAISE = new Exercise("Seated Calf Raise", CALVES, null, ["dumbbell"]);
//Core
Exercise RUSSIAN_TWISTS = new Exercise("Russian Twists", OBLIQUES, [ABS], ["calisthenics"]);
Exercise LEG_LIFTS = new Exercise("Leg Lifts", ABS, null, ["calisthenics"]);
Exercise CRUNCHES = new Exercise("Crunches", ABS, null, ["calisthenics"]);

//Calisthenics
Exercise INVERTED_ROWS = new Exercise("Inverted Rows", DELTOIDS, [LATS, RHOMBOIDS, BICEPS], ["calisthenics"]);
Exercise BW_REAR_DELT_FLY = new Exercise("Bodyweight Rear Delt Fly", DELTOIDS, [RHOMBOIDS, TRAPEZIUS], ["calisthenics"]);
Exercise PIKE_PRESS = new Exercise("Pike Press", DELTOIDS, [TRICEPS], ["calisthenics"]);
Exercise INVERTED_SHRUGS = new Exercise("Inverted Shrugs", TRAPEZIUS, [], ["calisthenics"]);
Exercise HANGING_LEG_LIFTS = new Exercise("Hanging Leg Lifts", ABS, [], ["pullupbar", "calisthenics"]);



List<Exercise> EXERCISES = [
  SHRUGS, BENCHPRESS, SHOULDER_PRESS, DIPS, CONCENTRATION_CURLS,
  FARMERS_WALK, BENT_OVER_BARBELL_ROW, LATERAL_RAISES, PULLUPS,
  CHINUPS, LAT_PULLDOWNS, DEADLIFT, REAR_DELT_FLY, ARNOLD_PRESS,
  TRICEP_KICKBACK, SKULL_CRUSHERS,HAMMER_CURL,CHEST_FLY, PUSHUPS,
  PRONE_LATERAL_RAISE, BENT_OVER_DUMBELL_ROW, BACK_SQUAT, FRONT_SQUAT,
  GOBLET_SQUAT, HIP_THRUSTS, LEG_CURL, LEG_EXTENSIONS, SQUEEZE_PRESS,
  PLATE_PRESS, RUSSIAN_TWISTS, LEG_LIFTS, CRUNCHES,STANDING_CALF_RAISE, 
  SEATED_CALF_RAISE, INVERTED_ROWS, BW_REAR_DELT_FLY, PIKE_PRESS, INVERTED_SHRUGS,
  BULGARIAN_SPLIT_SQUATS,SINGLE_LEG_DEADLIFT, LUNGES, LATERAL_LUNGES,INCLINE_DUMBBELL_CURL,SPIDER_CURLS,
  ROMANIAN_DEADLIFT, HANGING_LEG_LIFTS,
];

Workout createWorkout(String name,int epm, List<int> selectedMuscles, Config config) {
  //Exercises Per Muscle Group
  if(config == null) {
    config = Config("gym");
  }
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
  //Move all calisthenics workouts to lowPriority List unless this is a calisthenics configuration
  if(config.gymType != "park") {
    List<Exercise> toMove = [];
    highPriorityList.forEach((ex) {
      if(ex.equipment.length == 1 && ex.equipment[0] == "calisthenics") {
        toMove.add(ex);
      }
    });
    toMove.forEach((ex) {
      highPriorityList.remove(ex);
      lowPriorityList.add(ex);
    });
  }
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
    if(choices.length > epm) {
      for(int k = 0; k < epm; k++) {
        Random random = new Random();
        int randomNumber = random.nextInt(choices.length);
        finalList.add(choices[randomNumber]);
        choices.removeAt(randomNumber);
      }
    } else if(choices.length == epm) {
      for(int k = 0; k < epm; k++) {
        finalList.add(choices[0]);
        choices.removeAt(0);
      }
    } else if(choices.length < epm) {
      for(int k = 0; k < choices.length;) {
        finalList.add(choices[0]);
        choices.removeAt(0); 
      }
    }
    for(int k = 0; k < choices.length; k++) {
      backups.add(choices[k]);
    }
    if(timesPrimary < epm) {
      choices = [];
      for(int j = 0; j < lowPriorityList.length; j++) {
        if(lowPriorityList[j].isPrimaryMuscle(selectedMuscles[i])) {
          choices.add(lowPriorityList[j]);
        }
      }

      if(timesPrimary > 0) {
        for(int l = 0; l < timesPrimary; l++) {
          Random random = new Random();
          if(choices.length != 0) {
            int randomNumber = random.nextInt(choices.length);
            finalList.add(choices[randomNumber]);
            choices.removeAt(randomNumber);
          }
        }
      }
      if(timesPrimary == 0) {
        Random random = new Random();
        for(int j = 0; j < epm; j++) {
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

  //Go through config and make sure all workouts are applicable
  if(config.gymType == "homeGym") {
    //Home Gym Settings
    //Filter first through main list then backup list, using backups to replace main if needed
    List<String> _tools = config.gymTools;
    _tools.add("calisthenics");

    List<int> toRemoveF = [];
    List<int> toReplaceFi = [];
    List<Exercise> toReplaceF = [];
    List<Exercise> toRemoveB = [];
    finalList.forEach((exercise) {
      bool hasEquipment = false;
      exercise.equipment.forEach((equip){
        _tools.forEach((tool) {
          if(equip == tool) {
            hasEquipment = true;
          }
        });
        //if have equipment, move on to next, if not get new exercise
        if(!hasEquipment) {
          int i = finalList.indexOf(exercise);
          int primaryMuscle = exercise.primaryMuscle;
          bool replaced = false;
          toRemoveF.add(i);
          backups.forEach((ex) {
            if(!replaced) {
              if(ex.primaryMuscle == primaryMuscle) {
                bool added = false;
                ex.equipment.forEach((e) {
                  _tools.forEach((tool) {
                    if(!added) {
                      if(tool == e) {
                        added = true;
                        toReplaceF.add(ex);
                        toReplaceFi.add(i);
                        replaced = true;
                        toRemoveB.add(ex);
                      }
                    }
                  });
                });
              }
            }
          });
        }
      });
    });
    //I dont remember how this works at all
    for(int i = toRemoveF.length - 1; i >= 0; i--) {
      finalList.removeAt(toRemoveF[i]);
      if(toReplaceFi.contains(toRemoveF[i])) {
        int j = toReplaceFi.indexOf(toRemoveF[i]);
        finalList.insert(toReplaceFi[j], toReplaceF[j]);
      }
    }
    for(int i = toRemoveB.length - 1; i >= 0; i--) {
      backups.remove(toRemoveB[i]);
    }
    toRemoveB = [];
    //Go through backups to see if they have equipment for backup exercises
    backups.forEach((exercise) {
      bool hasEquipment = false;
      exercise.equipment.forEach((eq) {
        _tools.forEach((e) {
          if(eq == e) {
            hasEquipment = true;
          }
        });
      });
      if(!hasEquipment) {
        toRemoveB.add(exercise);
      }
    });
    for(int i = toRemoveB.length - 1; i >= 0; i--) {
      backups.remove(toRemoveB[i]);
    }
  } else if(config.gymType == "park"){
    //Calisthenics settings
    List<String> _tools = [ "calisthenics" ];
    List<int> toRemoveF = [];
    List<int> toReplaceFi = [];
    List<Exercise> toReplaceF = [];
    List<Exercise> toRemoveB = [];
    finalList.forEach((exercise) {
      bool hasEquipment = false;
      exercise.equipment.forEach((equip){
        _tools.forEach((tool) {
          if(equip == tool) {
            hasEquipment = true;
          }
        });
        //if have equipment, move on to next, if not get new exercise
        if(!hasEquipment) {
          int i = finalList.indexOf(exercise);
          int primaryMuscle = exercise.primaryMuscle;
          bool replaced = false;
          toRemoveF.add(i);
          backups.forEach((ex) {
            if(!replaced) {
              if(ex.primaryMuscle == primaryMuscle) {
                bool added = false;
                ex.equipment.forEach((e) {
                  _tools.forEach((tool) {
                    if(!added) {
                      if(tool == e) {
                        added = true;
                        toReplaceF.add(ex);
                        toReplaceFi.add(i);
                        replaced = true;
                        toRemoveB.add(ex);
                      }
                    }
                  });
                });
              }
            }
          });
        }
      });
    });
    //I dont remember how this works at all
    for(int i = toRemoveF.length - 1; i >= 0; i--) {
      finalList.removeAt(toRemoveF[i]);
      if(toReplaceFi.contains(toRemoveF[i])) {
        int j = toReplaceFi.indexOf(toRemoveF[i]);
        finalList.insert(toReplaceFi[j], toReplaceF[j]);
      }
    }
    for(int i = toRemoveB.length - 1; i >= 0; i--) {
      backups.remove(toRemoveB[i]);
    }
    toRemoveB = [];
    //Go through backups to see if they have equipment for backup exercises
    backups.forEach((exercise) {
      bool hasEquipment = false;
      exercise.equipment.forEach((eq) {
        _tools.forEach((e) {
          if(eq == e) {
            hasEquipment = true;
          }
        });
      });
      if(!hasEquipment) {
        toRemoveB.add(exercise);
      }
    });
    for(int i = toRemoveB.length - 1; i >= 0; i--) {
      backups.remove(toRemoveB[i]);
    }
  }

  //Go through and make sure that there are no repeats
  finalList.forEach((exercise) {
    if(backups.contains(exercise)) {
      backups.remove(exercise);
    }
  });
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
  bool exist = await wFile.exists();
  if(exist) {
    await wFile.delete();
  }
  File cFile = await wFile.create();
  String json = jsonEncode(workout);
  cFile.writeAsString(json);
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
    String n = f.path.split("/").last;
    if(checkWFileName(n)) {
          names.add(n.replaceAll(".json", ""));
    }
  });
  return names;
}

bool checkWFileName(String n) {
  if(
    n != "flutter_assets" &&
    !n.startsWith("res_timestamp") &&
    n != "config.json" &&
    n != "research"
  ) {
    return true;
  }
  return false;
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
    List<String> equipment = [];
    List e = i['Equipment'];
    if (e != null) {
      e.forEach((j) {
        equipment.add(j);
      });
    }
    exercises.add(new Exercise(i['Name'], i['PrimaryMuscles'], secondaryMuscles,equipment));
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
    List<String> equipment = [];
    List e = i['Equipment'];
    if (e != null) {
      e.forEach((j) {
        equipment.add(j);
      });
    }
    backups.add(new Exercise(i['Name'], i['PrimaryMuscles'], secondaryMuscles,equipment));
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
  return "";
}