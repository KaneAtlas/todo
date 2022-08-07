part of todo_lib;

void openTaskPage(BuildContext context, String taskId) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => TaskScreen(taskId)));
}

class TaskCard extends ConsumerWidget {
  final String taskId;
  const TaskCard(this.taskId, {super.key});

  Widget? delete(bool isDelete, Function deleteTask) {
    if (isDelete) {
      return IconButton(
        icon: const Icon(Icons.delete_outlined),
        onPressed: () {
          deleteTask(taskId);
        },
      );
    }
    return null;
  }

  @override
  build(BuildContext context, WidgetRef ref) {
    final mainLogic = ref.watch(mainLogicProvider);
    final TaskData? taskData = mainLogic.taskTree.getTask(taskId);
    if (taskData == null) return Container();
    final isDelete = mainLogic.getSetting("delete");
    return OutlinedCard(
      child: GestureDetector(
        onTap: () {
          openTaskPage(context, taskId);
        },
        onLongPress: () {
          mainLogic.setMode("delete", true);
        },
        child: Padding(
            padding: const EdgeInsets.all(0),
            child: ListTile(
              title: Text(taskData.title),
              subtitle: Text(taskData.subtitle),
              trailing: delete(isDelete, mainLogic.deleteTask)
            )),
      ),
    );
  }
}

class TaskScreen extends StatelessWidget {
  final String taskId;
  const TaskScreen(this.taskId, {super.key});

  @override
  build(BuildContext context) {
    return ScreenFrame(
      child: TaskPageContent(taskId),
    );
  }
}

class TaskPageContent extends ConsumerWidget {
  final String taskId;
  const TaskPageContent(this.taskId, {super.key});

  List<Widget> getSubTasks(TaskData task) {
    List<Widget> subTaskList = [];
    for (String subTaskId in task.subTasks) {
      subTaskList.add(TaskCard(subTaskId));
    }
    return subTaskList;
  }

  @override
  build(BuildContext context, WidgetRef ref) {
    final mainLogic = ref.watch(mainLogicProvider);
    final TaskData? task = mainLogic.taskTree.getTask(taskId);
    if (task == null) return const TaskError();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Column(
          children: [
            //title
            displayTitle(task.title),
            //subtitle
            displaySubtitle(task.subtitle),
            //content
            const Space(50),
            displayContent(task.content),
            //child tasks
            const Space(30),
            ...getSubTasks(task),
            //add child tasks
            const Space(20),
            AddSubTask(task, mainLogic.createTask),
          ],
        ),
      ),
    );
  }
}

class AddSubTask extends StatelessWidget {
  final TaskData task;
  final Function createTask;
  const AddSubTask(this.task, this.createTask, {super.key});

  @override
  build(BuildContext context) {
    return OutlinedButton(onPressed: () {
      openAddTaskScreen(context, createTask, task.taskId, task.taskDepth);
    }, 
    child: const Text("add subtask"));
  }
}

Widget displayTitle(String value) {
  return Text(
    value,
    style: const TextStyle(
      fontSize: 30,
    ),
  );
}

Widget displaySubtitle(String value) {
  return Text(
    value,
    style: const TextStyle(fontSize: 18, color: Colors.grey),
  );
}

Widget displayContent(TaskContent value) {
  return Text(
    value.content,
    style: const TextStyle(fontSize: 15),
  );
}

class TaskError extends StatelessWidget {
  const TaskError({super.key});

  @override
  build(BuildContext context) {
    return Center(child: displayTitle("We couldn't find what you were looking for :("));
  }
}