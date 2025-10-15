class Session {
  static final Session instance = Session._();
  Session._();

  String? userId;

  bool get isAuthenticated => userId != null;

  void setUser(String id) => userId = id;
  void clear() => userId = null;
}
