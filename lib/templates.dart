library workoutcreator.templates;

import 'package:workoutcreator/globals.dart';

class TemplateWorkout {
  String name;
  Workout workout;
  TemplateWorkout(this.name, this.workout);
  
  Map<String, dynamic> toJson() => {
    'Name': name,
    'Workout': workout,
  };
}

//TEMPLATES
TemplateWorkout push =  new TemplateWorkout(
  "Push",
  new Workout(
    "Push",
    <Exercise>[
      BENCHPRESS,
      SHOULDER_PRESS,
      SQUEEZE_PRESS,
      LATERAL_RAISES,
      CHEST_FLY,
      TRICEP_KICKBACK,
    ],
  ),
);
TemplateWorkout pull = new TemplateWorkout(
  "Pull",
  new Workout(
    "Pull",
    <Exercise>[
      PULLUPS,
      BENT_OVER_BARBELL_ROW,
      FACE_PULLS,
      SHRUGS,
      HAMMER_CURL,
      SPIDER_CURLS,
    ],
  )
);
TemplateWorkout legs = new TemplateWorkout(
  "Legs",
  new Workout(
    "Legs",
    <Exercise>[
      BACK_SQUAT,
      FRONT_SQUAT,
      HIP_THRUSTS,
      LEG_EXTENSIONS,
      SEATED_CALF_RAISE,
    ],
  )
);
List<TemplateWorkout> templateWorkouts = [
  push, pull, legs
];
