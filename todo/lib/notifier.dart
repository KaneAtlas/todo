part of todo_lib;

class Goal {}


class MainLogic extends ChangeNotifier {
  User? user;

  dynamic notNull(dynamic a, dynamic b) {
    if (a==null) return b;
    return a;
  }

  void setUser(User? user) {
    if (user == null) return;
    this.user = user;
  }

  String getUsername() {
    if (user == null) return "Unknown User";
    String retVal = notNull(user?.displayName, user?.email);
    return retVal;
  }

  String getImage() {
    return user!.photoURL!;
  }











  void logOutUser() {
    user = null;
  }


}

final mainLogicProvider = ChangeNotifierProvider<MainLogic>((ref) {
  return MainLogic();
});