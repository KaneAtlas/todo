part of todo_lib;


void openTaskListDrawer(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => const TaskListDrawer()));
}

class TaskListDrawer extends Drawer {
   const TaskListDrawer({super.key});

  @override
  build(BuildContext context) {
    return Drawer(
      child: TaskListDrawerContent()
    );
  }
}

class TaskListDrawerContent extends ConsumerWidget {

  @override
  build(BuildContext context, WidgetRef ref) {
    final mainLogic = ref.watch(mainLogicProvider);
    final userID = mainLogic.getUserID();

    return FirestoreListView(
      query: mainLogic.db
        .collection('users')
        .doc(userID)
        .collection('task_lists')
        .orderBy('index'),
      itemBuilder: (context, snapshot) {
        final Map? taskList = snapshot.data() as Map;
        if (taskList == null) return Container();
        return ListTile(
          title: Text(taskList['taskListName']),
        );
      }
      );
  }
}