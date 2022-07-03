part of todo_lib;

void openAddTaskScreen(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => AddTaskScreen()));
}

class AddTaskScreen extends ConsumerWidget {
  AddTaskScreen({super.key});

  @override
  build(BuildContext context, WidgetRef ref) {
    return ScreenFrame(
      child: AddTaskContent(''),
    );
  }
}

class AddTaskContent extends ConsumerWidget {
  final String parentTaskId;

  AddTaskContent(
    this.parentTaskId,
    {super.key}
  );

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Widget> taskListChips(List<String> taskLists, Function removeList) {
    return taskLists.map<Padding>((String value) {
      return Padding(
        padding: const EdgeInsets.all(3.0),
        child: InputChip(
          label: Text(value),
          onPressed: () {},
          onDeleted: () {
            removeList(value);
          },
          avatar: const Icon(Icons.list)
        ),
      );
    }).toList();
  }

  void _handleSubmitted() {
    final form = _formKey.currentState!;
    if (!form.validate()) {
      
    } else {
      form.save();
      print("saving");
    }
  }

  String _randomPrompt(List<String> prompts) {
    return prompts[Random().nextInt(prompts.length)];
  }

  String _titlePrompts() {
    List<String> prompts = ["shopping list", "do washing", "flake on pub"];
    return _randomPrompt(prompts);
  }

  String _subtitlePrompts() {
    List<String> prompts = [
      "for petes bbq",
      "becuz im lazy",
      "this time for real"
    ];
    return _randomPrompt(prompts);
  }

  String? _validateTitle(String? value) {
    return null;
  }

  String? _validateCommon(String? value) {
    if (value == null) {
      return 'this as well';
    }
    if (value.length > 35) {
      return "bit long mate";
    }
    return null;
  }

  @override
  build(BuildContext context, WidgetRef ref) {
    final mainLogic = ref.watch(mainLogicProvider);
    final addList = mainLogic.taskAddList;
    final removeList = mainLogic.taskRemoveList;
    final taskLists = mainLogic.tempTaskLists;

    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Column(
              children: [
                const Space(60),
                const Center(child: Text("add task")),
                const Space(60),
                SizedBox(
                  height: 40,
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      icon: const Icon(Icons.add_box_outlined),
                      hintText: _titlePrompts(),
                      labelText: "title",
                    ),
                    onSaved: (value) {
                      print(value);
                    },
                    validator: _validateTitle,
                  ),
                ),
                const Space(20),
                SizedBox(
                  height: 40,
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      icon: const Icon(Icons.subtitles),
                      hintText: _subtitlePrompts(),
                      labelText: "subtitle",
                    ),
                    onSaved: (value) {
                      print(value);
                    },
                    validator: _validateTitle,
                  ),
                ),
                // fq.QuillToolbar.basic(controller: _quillController),
                // Expanded(
                //   child: fq.QuillEditor.basic(
                //     controller: _quillController,
                //     readOnly: false, // true for view only mode
                //   ),
                // ),
                const Space(20),
                SizedBox(
                  height: 60,
                  child: DropdownButtonFormField(
                    isDense: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.playlist_add),
                      labelText: "group",
                    ),
                    items: <String>["Group 1", "Group 2", "---"]
                      .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value)
                          );
                      }).toList(), 
                    onChanged: (String? newValue) {
                      print('changed');
                      print(newValue);
                      if (newValue == null) {
                        return;
                      }
                      if (newValue == "---") {
                        return;
                      }
                      addList(newValue);
                    }
                    )
                ),
                const Space(10),
                Row(children: taskListChips(taskLists, removeList)),
                const Space(20),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: "content",
                  ),
                  onSaved: (value) {
                    print(value);
                  },
                  validator: _validateTitle,
                  maxLines: 6,
                ),
                const Space(20),
                Center(
                  child: ElevatedButton(
                    child: const Text("submit"),
                    onPressed: _handleSubmitted,
                  )
                )
              ],
            )));
  }
}
