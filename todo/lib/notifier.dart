part of todo_lib;

var uuid = const Uuid();

class TaskContent {
  String content;

  TaskContent(this.content);
}

class TaskData {
  String taskId;
  int taskDepth;
  String? parentTask;
  String title;
  String subtitle;
  TaskContent content;
  DateTime targetFinishTime;

  late DateTime creationTime;
  
  List<String> subTasks = [];
  List<String> taskListIds = [];
  bool completed = false;
  DateTime? completedTime;



  TaskData({
    required this.taskId,
    required this.parentTask,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.taskDepth,
    required this.targetFinishTime,
  }) {
    creationTime = DateTime.now();

  }

  dynamic toJson() {
    return {
      'taskId': taskId,
      'taskDepth': taskDepth,
      'parentTask': parentTask,
      'title': title,
      'subtitle': subtitle,
      'content': content.content,
      'targetFinishTime': targetFinishTime,
      'creationTime': creationTime,
      'subTasks': subTasks,
      'taskListIds': taskListIds,
      'completed': completed,
      'completedTime': completedTime
    };
  }
}

class TaskBuilder {
  String? taskId;
  int? taskDepth;
  String? parentTask;
  String? title;
  String? subtitle;
  TaskContent? content;
  DateTime? targetFinishTime;

  void setTaskId(value) {
    taskId = value;
  }

  void setTaskDepth(value) {
    taskDepth = value;
  }

  void setParentTask(value) {
    parentTask = value;
  }

  void setTitle(value) {
    title = value;
  }

  void setSubtitle(value) {
    subtitle = value;
  }

  void setContent(String? value) {
    value ??= '';
    content = TaskContent(value);
  }

  void setFinishTime(DateTime value) {
    targetFinishTime = value;
  }

  TaskData? build() {
    if (taskDepth == null) {
      print("no task depth");
      return null;
    }
    taskId ??= uuid.v4();
    title ??= '';
    subtitle ??= '';
    content ??= TaskContent('');
    targetFinishTime ??= DateTime.now();

    return TaskData(
      taskId: taskId!,
      parentTask: parentTask,
      title: title!,
      subtitle: subtitle!,
      content: content!,
      taskDepth: taskDepth!,
      targetFinishTime: targetFinishTime!
    );
  }

  TaskData from(object) {
    TaskData task = TaskData(
      taskId: object["taskId"],
      parentTask: object["parentId"],
      title: object['title'],
      subtitle: object['subtitle'],
      content: TaskContent(object['content']),
      taskDepth: object['taskDepth'],
      targetFinishTime: (object['targetFinishTime'] as Timestamp).toDate()
    );
    task.creationTime = (object['creationTime'] as Timestamp).toDate();
    task.subTasks = List.castFrom(object['subTasks'] as List);
    task.taskListIds = List.castFrom(object['taskListIds'] as List);
    task.completed = object['completed'];
    task.completedTime = object['completedTime'] == null ? null : (object['completedTime'] as Timestamp).toDate();

    return task;
  }
}


class TaskList {
  int taskListId;
  String taskListName;
  
  List<String> tasks = [];

  TaskList({
    required this.taskListId,
    required this.taskListName,
  });
}



class TaskTree {
  Map<String, TaskData> tasks = HashMap();
  Map<String, TaskList> taskLists = HashMap();
  late TaskList daily;
  late TaskList weekly;
  late TaskList monthly;

  TaskTree() {

    assembleLists();
  }

  addTask(TaskData task) {
    tasks[task.taskId] = task;
    updateLists(task);
  }

  removeTask(String taskId) {
    tasks.remove(taskId);

  }

  TaskData? getTask(String taskId) {
    if (tasks.containsKey(taskId)) {
      return tasks[taskId]!;
    }
    return null;
  }

  getTaskList(String taskListId) {}

  assembleLists() {}

  updateLists(TaskData task) {
    for (String taskListId in task.taskListIds) {
      if (taskLists.containsKey(taskListId)) {
        taskLists[taskListId]!.tasks.add(task.taskId);
      }
      else {
        //TODO create tasklist by fetching from 
      }
    }
  }

}


class MainLogic extends ChangeNotifier {
  User? user;
  String? userID;
  final db = FirebaseFirestore.instance;
  final taskTree = TaskTree();

  dynamic placeholder(String funcName, returnVal) {
    print("would be calling " + funcName);
    return returnVal;
  }

  void init() { 
  }

  Future<void> futureInit() async {
    userID = user!.uid;
    initSub();
    //final QuerySnapshot<Map<String, dynamic>> obj = await db.collection('users').doc(userID).collection('tasks').get();
    // print('this ' + obj.docs[0].id);
    // print(obj.docs[0].id == userID);
    // print('this ' + userID!);
    // print('why not');
  }

  dynamic notNull(dynamic a, dynamic b) {
    if (a==null) return b;
    return a;
  }

  //####################################
  // settings stuff

  Map<String, bool> settings = HashMap();
  bool settingsInit = false;

  void initSettings() {
    if (settingsInit) return;
    setMode("delete", false);
    setMode("onlyShowRootTasks", true);
  }

  void setMode(String key, bool value) {
    settings[key] = value;
    notifyListeners();
  }

  bool getSetting(String key) {
    if (settings.containsKey(key)) {
      return settings[key]!;
    }
    return false;
  }
   

  //####################################
  //add task stuff

  List<String> tempTaskLists = [];
  TaskBuilder? taskBuilder;
  

  void taskAddList(String list) {
    if (tempTaskLists.contains(list)) {
      return;
    }
    tempTaskLists.add(list);
    notifyListeners();
  }

  void taskRemoveList(String list) {
    if (tempTaskLists.contains(list)) {
      tempTaskLists.remove(list);
    }
    notifyListeners();
  }

  void buildTask(String key, dynamic value) {
    taskBuilder ??= TaskBuilder();
    
    switch (key) {
      case "title": {
        taskBuilder!.setTitle(value);
        break;
      }
      case "subtitle": {
        taskBuilder!.setSubtitle(value);
        break;
      }
      case "content": {
        taskBuilder!.setContent(value);
        break;
      }
      case "taskDepth": {
        taskBuilder!.setTaskDepth(value);
        break;
      }
      case "parentId": {
        taskBuilder!.setParentTask(value);
      }
    }
  }

  void createTask() {
    //TODO this function
    //create task data
    if (taskBuilder == null) {
      print("no ongoing taskbuilder");
      return;
    }
    TaskData? task = taskBuilder!.build();
    if (task == null) {
      print("failed to build task");
      return;
    }
    //upload task data
    uploadTask(task, tempTaskLists);
    //update task tree

    //clear taskbuilder
    taskBuilder = null;
  }


  //####################################
  //auth funcs

  void setUser(User? user) {
    if (user == null) return;
    this.user = user;
  }

  String getUsername() {
    if (user == null) return "Unknown User";
    String retVal = notNull(user?.displayName, user?.email);
    return retVal;
  }

  String getUserID() {
    if (user == null) return "Unknown User";
    return userID!;
  }

  String getImage() {
    return user!.photoURL!;
  }


  void logOutUser() {
    user = null;
  }


//#########################################
//DB funcs

  StreamSubscription? sub;

  Future<Map<String, dynamic>?> getCollectionByUserID(String userID) {
    final data = db.collection('users').doc(userID).get().then((value) => value.data(),);
    return data;
  }

  Future uploadTask(TaskData task, taskLists) async {
    print("uploading");
    final taskDoc = db.collection('users').doc(userID).collection('tasks').doc(task.taskId);

    await taskDoc.set(task.toJson());
    if (task.parentTask != null) {
      print('updating parent');
      final parentDoc = db.collection('users').doc(userID).collection('tasks').doc(task.parentTask);
      await parentDoc.update(
        {'subTasks': FieldValue.arrayUnion([task.taskId])}
      );
    }
    notifyListeners();
  }

  Future<void> deleteTask(String taskId) async {
    debugPrint("deleting task");
    final doc = db.collection("users").doc(userID).collection('tasks').doc(taskId);
    doc.delete();
    TaskData task = taskTree.getTask(taskId)!;
    for (String subTaskId in task.subTasks) {
      deleteTask(subTaskId);
    }
    taskTree.removeTask(taskId);
    notifyListeners();
  }

  void initSub() {
    CollectionReference ref = db.collection('users').doc(userID).collection('tasks');
    sub = ref.snapshots().listen(
      (snapshot) {
        for (var change in snapshot.docs) {
          debugPrint("changing");
          debugPrint(change.data().toString());
          taskTree.addTask(TaskBuilder().from(change.data()));
        }
      }
    );
  }
}

final mainLogicProvider = ChangeNotifierProvider<MainLogic>((ref) {
  return MainLogic();
});