part of todo_lib;

class AuthGate extends ConsumerWidget {
  final Widget callbackWidget;

  const AuthGate(this.callbackWidget, {super.key});

  @override
  build(BuildContext context, WidgetRef ref) {
    final mainLogic = ref.read(mainLogicProvider);
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SignInScreen(providerConfigs: [
            GoogleProviderConfiguration(clientId: "860383243174-n6rsok8pn07c5a9emeq3vrf29ffm96h5.apps.googleusercontent.com")
          ]);
        } else {
          mainLogic.setUser(snapshot.data);
          return FutureBuilder(
            future: mainLogic.futureInit(),
            builder: (context, _) {
              return callbackWidget;
            }
            
            );
        }
      },
    );
  }
}

