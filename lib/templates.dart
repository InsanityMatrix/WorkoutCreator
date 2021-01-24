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
TemplateWorkout push = new TemplateWorkout(
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
    ));
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
    ));
TemplateWorkout calUpperBody = new TemplateWorkout(
  "Calisthenics Upper Body",
  new Workout(
    "Calisthenics Upper Body",
    <Exercise>[
      PULLUPS,
      DECLINE_PUSHUPS,
      PIKE_PRESS,
      CLOSE_GRIP_CHINUPS,
      DIPS,
      BW_REAR_DELT_FLY,
    ],
  ),
);
List<TemplateWorkout> templateWorkouts = [push, pull, legs, calUpperBody];

//CELEBRITY
TemplateWorkout creed1 = new TemplateWorkout(
  "Michael B. Jordan\'s Creed 1",
  new Workout(
    "Michael B. Jordan\'s Creed 1",
    <Exercise>[
      INCLINE_DUMBBELL_PRESS,
      CHEST_FLY,
      PUSHUPS,
      TRICEP_KICKBACK,
      TRICEP_PUSHDOWNS,
      DIPS,
    ],
  ),
);
TemplateWorkout creed2 = new TemplateWorkout(
  "Michael B. Jordan\'s Creed 2",
  new Workout(
    "Michael B. Jordan\'s Creed 2",
    <Exercise>[
      BENT_OVER_DUMBELL_ROW,
      LAT_PULLDOWNS,
      DUMBBELL_CURL,
      BARBELL_CURL,
      HAMMER_CURL,
    ],
  ),
);
TemplateWorkout creed3 = new TemplateWorkout(
    "Michael B. Jordan\'s Creed 3",
    new Workout(
      "Michael B. Jordan\'s Creed 3",
      <Exercise>[
        LUNGES,
        LEG_CURL,
        ROMANIAN_DEADLIFT,
        BACK_SQUAT,
        CRUNCHES,
        LEG_LIFTS,
        REVERSE_CRUNCH,
      ],
    ));

TemplateWorkout keanuReeves = new TemplateWorkout(
  "Keanu Reeves",
  new Workout(
    "Keanu Reeves",
    <Exercise>[
      LUNGES,
      SHOULDER_PRESS,
      BENT_OVER_DUMBELL_ROW,
      BACK_SQUAT,
      PLANK,
      LATERAL_LUNGES,
    ],
  ),
);
List<TemplateWorkout> celebrityWorkouts = [
  creed1,
  creed2,
  creed3,
  keanuReeves,
];
