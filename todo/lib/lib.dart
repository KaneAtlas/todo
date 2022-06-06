library todo_lib;



import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';


//backend logic
part 'notifier.dart';
//auth
part 'auth_gate.dart';
//main routing
part 'layout.dart';
//daily, weekly, monthly
part 'time_screens.dart';
//calendar
part 'calendar.dart';
//profile
part 'profile.dart';



//re usable components
part "components.dart";