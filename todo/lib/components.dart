part of todo_lib;

class OutlinedCard extends StatelessWidget {
  final Widget child;

  const OutlinedCard({required this.child, super.key});

  @override
  build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Center(
        child: Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: child,
            ),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            )),
      ),
    );
  }
}

class Space extends StatelessWidget {
  final double space;

  const Space(this.space, {super.key});

  @override
  build(BuildContext context) {
    return SizedBox(height: space);
  }
}


class HSpace extends StatelessWidget {
  final double space;

  const HSpace(this.space, {super.key});

  @override
  build(BuildContext context) {
    return SizedBox(width: space);
  }
}
class BackButton extends StatelessWidget {
  const BackButton({super.key});

  @override
  build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.keyboard_arrow_left, size: 30),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}

PreferredSizeWidget backBar(BuildContext context) {
  return AppBar(
    leading: const BackButton(),
    backgroundColor: Colors.transparent,
    actions: const [StopDelete()]
  );
}

fq.QuillToolbar myQuillToolbar(BuildContext context) {
  return fq.QuillToolbar.basic(
    controller: _quillController,
    toolbarSectionSpacing: 2,
    showClearFormat: false,
    showAlignmentButtons: false,
    showLeftAlignment: false,
    showRightAlignment: false,
    showCenterAlignment: false,
    showJustifyAlignment: false,
    showHeaderStyle: false,
    showQuote: false,
    showUndo: false,
    showRedo: false,
    showImageButton: false,
    showVideoButton: false,
    showCameraButton: false,
    showDirection: false,
  );
}

class ScreenFrame extends StatelessWidget {
  final Widget child;

  const ScreenFrame({required this.child, super.key});

  @override
  build(BuildContext context) {
    return Scaffold(appBar: backBar(context), body: child);
  }
}

class StopDelete extends ConsumerWidget {
  const StopDelete({super.key});
  @override
  build(BuildContext context, WidgetRef ref) {
    final mainLogic = ref.watch(mainLogicProvider);
    final bool isDelete = mainLogic.getSetting("delete");
    return isDelete ? IconButton(
      icon: const Icon(Icons.close),
      onPressed: () {
        mainLogic.setMode("delete", false);
      }
    ) : Container();
  }
}
