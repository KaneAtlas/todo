part of todo_lib;


class TaskContent {}

class TaskData {
  int taskId;
  int taskDepth;
  int? parentTask;
  String title;
  String subtitle;
  TaskContent content;
  DateTime targetFinishTime;

  late DateTime creationTime;
  
  List<TaskData> subTasks = [];
  List<int> taskListIds = [];
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
}

class TaskList {
  int taskListId;
  String taskListName;
  
  List<int> tasks = [];

  TaskList({
    required this.taskListId,
    required this.taskListName,
  });
}



class TaskTree {
  List<TaskData> tasks = [];
  List<TaskList> taskLists = [];
  late TaskList daily;
  late TaskList weekly;
  late TaskList monthly;

  TaskTree() {

    assembleLists();
  }

  addTask(TaskData task) {
    tasks.add(task);
    updateLists(task);
  }

  getTask(int taskId) {}

  getTaskList(int taskListId) {}

  assembleLists() {}

  updateLists(TaskData task) {}

}


class MainLogic extends ChangeNotifier {
  User? user;
  String? userID;
  final db = FirebaseFirestore.instance;

  void init() { 
  }

  Future<void> futureInit() async {
    userID = user!.uid;
    final QuerySnapshot<Map<String, dynamic>> obj = await db.collection('users').doc(userID).collection('tasks').get();
    print('this ' + obj.docs[0].id);
    print(obj.docs[0].id == userID);
    print('this ' + userID!);
    print('why not');
  }

  dynamic notNull(dynamic a, dynamic b) {
    if (a==null) return b;
    return a;
  }

  //####################################
  //add task stuff

  List<String> tempTaskLists = [];

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

  void createTask() {
    //TODO this function
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

  Future<Map<String, dynamic>?> getCollectionByUserID(String userID) {
    final data = db.collection('users').doc(userID).get().then((value) => value.data(),);
    return data;
  }



}

final mainLogicProvider = ChangeNotifierProvider<MainLogic>((ref) {
  return MainLogic();
});