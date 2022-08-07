part of todo_lib;

class DailyScreen extends ConsumerWidget {
  @override
  build(context, ref) {
    return Container();
  }
}

class WeeklyScreen extends ConsumerWidget {
  @override
  build(context, ref) {
    final mainLogic = ref.watch(mainLogicProvider);
    final userID = mainLogic.getUserID();

    return FirestoreListView(
        query: mainLogic.db
            .collection('users')
            .doc(userID)
            .collection('tasks')
            .where('taskDepth', isEqualTo: 0)
            .orderBy('targetFinishTime'),
        itemBuilder: (context, snapshot) {
          String taskId = TaskBuilder().from(snapshot.data()).taskId;
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: TaskCard(taskId),
          );
        });
  }
}

class MonthlyScreen extends ConsumerWidget {
  @override
  build(context, ref) {
    return Row(
      children: const [
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: myQuillToolbar(context),
        // ),
        
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: fq.QuillEditor.basic(
        //       controller: _quillController,
        //       readOnly: false, // true for view only mode
          
        //   ),
        // ),
      ],
    );
  }
}

class CalendarScreen extends ConsumerWidget {
  @override
  build(context, ref) {
    return const Text("Calendar");
  }
}
