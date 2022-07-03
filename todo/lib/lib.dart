library todo_lib;



import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:flutter_quill/flutter_quill.dart' as fq;


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
//add tasks screen
part 'add_task.dart';



//re usable components
part "components.dart";
part "functions.dart";


fq.QuillController _quillController = fq.QuillController.basic();