part of todo_lib;

class DailyScreen extends ConsumerWidget {
  @override
  build(context, ref) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return OutlinedCard(
            child:
                SizedBox(width: 200, child: Text("Daily" + index.toString())));
      },
      itemCount: 20,
    );
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
            .orderBy('index'),
        itemBuilder: (context, snapshot) {
          Object? task = snapshot.data();
          return Text(task.toString());
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
