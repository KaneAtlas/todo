part of todo_lib;

class Avatar extends ConsumerWidget {
  @override
  build(BuildContext context, WidgetRef ref) {
    final User? user = ref.watch(mainLogicProvider).user;
    return IconButton(
      icon: CircleAvatar(
        radius: 40,
        backgroundImage: NetworkImage(user!.photoURL!),
      ),
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ProfileScreen()));
      },
    );
  }
}

class ProfileScreen extends ConsumerWidget {
  String _greet(String username) {
    return "Hello, " + username;
  }

  @override
  build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.keyboard_arrow_left),
              onPressed: () {
                Navigator.of(context).pop();
              })),
      body: Center(
        child: Column(
          children: [
            ProfileSettings(),
            ProfileStats(),
          ],
        ),
      ),
    );
  }
}

class ProfileSettings extends ConsumerWidget {
  @override
  build(BuildContext context, WidgetRef ref) {
    final mainLogic = ref.read(mainLogicProvider);
    return SizedBox(
      height: 170,
      child: OutlinedCard(
          child: Column(
        children: [
          CircleAvatar(
              radius: 30, backgroundImage: NetworkImage(mainLogic.getImage())),
          const Spacer(),
          Row(
            children: [const Spacer(), MySignOutButton()],
          )
        ],
      )),
    );
  }
}

class ProfileStats extends ConsumerWidget {
  @override
  build(BuildContext context, WidgetRef ref) {
    return const OutlinedCard(child: SizedBox(
      height: 200,
      width: 200,
    ));
  }
}

class MySignOutButton extends ConsumerWidget {
  @override
  build(BuildContext context, WidgetRef ref) {
    final mainLogic = ref.read(mainLogicProvider);
    return ElevatedButton(
        child: const Text("sign out"),
        onPressed: () {
          FlutterFireUIAuth.signOut(context: context);
          mainLogic.logOutUser();
          Navigator.of(context).pop();
        });
  }
}
