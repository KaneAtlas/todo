part of todo_lib;

class TaskListDrawer extends Drawer {
  const TaskListDrawer({super.key});

  @override
  build(BuildContext context) {
    return const Drawer(child: TaskListDrawerContent());
  }
}

class TaskListDrawerContent extends ConsumerWidget {
  const TaskListDrawerContent({super.key});

  @override
  build(BuildContext context, WidgetRef ref) {
    final mainLogic = ref.watch(mainLogicProvider);
    final userID = mainLogic.getUserID();

    return Column(
      children: [
        const Space(40),
        Row(children: [
          const HSpace(20),
          displaySubtitle("task_master"),
          const Spacer(),
          const EditTaskLists(),
          const HSpace(10)
        ]),
        const Space(60),
        Expanded(
          child: FirestoreListView(
              query: mainLogic.db
                  .collection('users')
                  .doc(userID)
                  .collection('task_lists')
                  .orderBy('index'),
              itemBuilder: (context, snapshot) {
                final Map? taskList = snapshot.data() as Map;
                if (taskList == null) return Container();
                return TaskListTile(
                  title: taskList['taskListName'],
                );
              }),
        ),
        const Center(child: AddTaskList())
      ],
    );
  }
}

class TaskListTile extends ConsumerWidget {
  const TaskListTile({required this.title, super.key});
  final String title;

  @override
  build(BuildContext context, WidgetRef ref) {
    final mainLogic = ref.watch(mainLogicProvider);
    final isEdit = mainLogic.getSetting("editTaskLists");
    return ListTile(
      title: Text(title),
      leading: isEdit ? const Icon(Icons.drag_handle_outlined, size: 20, color: Colors.grey) : null,
      trailing: isEdit ? const Icon(Icons.delete_outline, size: 20) : null,
    );
  }
}

class EditTaskLists extends ConsumerWidget {
  const EditTaskLists({super.key});

  @override
  build(BuildContext context, WidgetRef ref) {
    final mainLogic = ref.watch(mainLogicProvider);
    final isEdit = mainLogic.getSetting("editTaskLists");
    return IconButton(
      icon: isEdit ? const Icon(Icons.close) : const Icon(Icons.edit),
      onPressed: () {
        if (isEdit) {
          mainLogic.setMode("editTaskLists", false);
        } else {
          mainLogic.setMode("editTaskLists", true);
        }
      },
    );
  }
}

class AddTaskList extends ConsumerWidget {
  const AddTaskList({super.key});

  @override
  build(BuildContext context, WidgetRef ref) {
    final mainLogic = ref.watch(mainLogicProvider);
    final isEdit = mainLogic.getSetting("editTaskLists");
    return isEdit ? OutlinedButton(onPressed: () {}, child: const Text('add_task_list')) : Container();
  }
}