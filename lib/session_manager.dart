class SessionManager {
  static String? authToken;
  static String? username;
  static String? email;
  static String? age;
  static String? gender;
  static String? phone;

  static bool isLoggedIn() {
    return authToken != null;
  }

  static void startSession(String token, String user, String mail, String ageuser, String genderuser, String phnum, response) {
    authToken = token;
    username = user;
    email = mail;
    age = ageuser;
    gender = genderuser;
    phone = phnum;
  }

  static void clearSession() {
    authToken = null;
    username = null;
    email = null;
    age = null;
    gender = null;
    phone = null;
  }
}
