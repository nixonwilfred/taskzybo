class UserData {
  static final UserData _instance = UserData._internal();
  factory UserData() => _instance;

  String name = '';
  String phone = '';

  UserData._internal();
}
