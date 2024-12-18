class SessionManager {
  static String? authToken;
  static String? username;
  static String? email;

  static bool isLoggedIn() {
    return authToken != null;
  }

  static void startSession(String token, String user, String mail) {
    authToken = token;
    username = user;
    email = mail;
  }

  static void clearSession() {
    authToken = null;
    username = null;
    email = null;
  }
}
