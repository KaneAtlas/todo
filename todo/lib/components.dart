part of todo_lib;


class OutlinedCard extends StatelessWidget {
  final Widget child;

  const OutlinedCard(
    {required this.child, super.key}
  );

  @override
  build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: child,
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          )
        ),
        ),
    );
  }
}