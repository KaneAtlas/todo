part of todo_lib;

class Default extends StatelessWidget {
  @override
  build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Default Page")),
        body: Column(
          children: [
            Container(
              height: 50,
              color: Colors.red,
            ),
            Container(height: 50, color: Colors.blue)
          ],
        ));
  }
}

class Root extends StatefulWidget {
  @override
  RootState createState() => RootState();
}

class RootState extends State<Root> {
  int _selectedIndex = 0;
  final PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _controller.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  void pageChanged(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.clear_all_rounded),
        actions: [Avatar(), Container(width: 10)],
      ),
      extendBodyBehindAppBar: true,
      body: PageView(
          controller: _controller,
          onPageChanged: (index) {
            pageChanged(index);
          },
          children: [
            DailyScreen(),
            WeeklyScreen(),
            MonthlyScreen(),
            CalendarScreen(),
          ],
        ),
      
      floatingActionButton:
          FloatingActionButton(onPressed: () {openAddTaskScreen(context);}, child: const Icon(Icons.add)),
      bottomNavigationBar: NavigationBar(
        destinations: const <NavigationDestination>[
          NavigationDestination(
              icon: Icon(Icons.task_alt_rounded), label: "daily"),
          NavigationDestination(
              icon: Icon(Icons.inventory_rounded), label: "weekly"),
          NavigationDestination(
              icon: Icon(Icons.spoke_outlined), label: "monthly"),
          NavigationDestination(
              icon: Icon(Icons.grid_view_outlined), label: "calendar"),
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
      ),
    );
  }
}

header(context) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(40),
    child: SizedBox(
        height: 40,
        child: Row(
          children: [
            IconButton(
                icon: const Icon(Icons.clear_all_rounded), onPressed: () {}),
            const Spacer(),
            Avatar(),
          ],
        )),
  );
}
