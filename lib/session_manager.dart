class SessionManager {
  static String? authToken;
  static String? username;
  static String? userid;
  static String? email;
  static String? icon;

  static bool isLoggedIn() {
    return authToken != null;
  }

  static void startSession(String token,String uid, String user, String mail, String ico) {
    authToken = token;
    username = user;
    userid = uid;
    email = mail;
    icon = ico;
  }

  static void clearSession() {
    authToken = null;
    username = null;
    userid = null;
    email = null;
    icon = null;
  }
}
