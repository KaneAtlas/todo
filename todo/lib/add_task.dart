part of todo_lib;

void openAddTaskScreen(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => AddTaskScreen()));
}

class AddTaskScreen extends ConsumerWidget {
  @override
  build(BuildContext context, WidgetRef ref) {
    return ScreenFrame(
      child: AddTaskContent(),
    );
  }
}

class AddTaskContent extends ConsumerWidget {
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
    return Form(
        child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Column(
              children: [
                const Space(60),
                const Center(child: Text("add task")),
                const Space(60),
                TextFormField(
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
                const Space(20),
                TextFormField(
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
                // fq.QuillToolbar.basic(controller: _quillController),
                // Expanded(
                //   child: fq.QuillEditor.basic(
                //     controller: _quillController,
                //     readOnly: false, // true for view only mode
                //   ),
                // ),
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
              ],
            )));
  }
}
