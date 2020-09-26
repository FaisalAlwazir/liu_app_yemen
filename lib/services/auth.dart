import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

const String loginUrl = 'http://umsyn.liu.edu.lb/login.php';

enum AuthStatus {
  /// loading page
  Undefined,

  /// login page
  LoggedOut,

  /// home page
  LoggedIn,
}

abstract class BaseAuth {
  final storage = FlutterSecureStorage();

  Future<AuthStatus> get status;

  Future<AuthStatus> _checkStatus();

  Future<bool> logIn(String id, String password);

  /// checking if a cookie is still valid
  Future<bool> _cookieLogIn(String cookie);

  void logOut(String id, String password);
}

class Auth extends BaseAuth {
  @override
  // TODO: implement status
  Future<AuthStatus> get status async {
    var status = await storage.read(key: "status");
    return AuthStatus.values.firstWhere(
            (element) => element.toString() == status,
            orElse: null) ??
        AuthStatus.Undefined;
  }

  @override
  Future<bool> logIn(String id, String password) async {
    var page = await http.post(loginUrl, body: {'USER': id, 'PASS': password});

    String redirectLocation = page.headers['location'];

    switch (redirectLocation) {

      /// The server redirects to http://www.liuyemen.com if the info isnt right
      case 'http://www.liuyemen.com':
        storage.write(key: "status", value: AuthStatus.LoggedOut.toString());
        return false;

      /// This means that the server sucessfuly validated the given info
      case 'student/studentLoginPage.php':
        storage.write(key: "id", value: id);
        storage.write(key: "pass", value: password);
        return true;
    }
    return false;
  }

  @override
  void logOut(String id, String password) {
    storage.write(key: "status", value: AuthStatus.LoggedOut.toString());
  }

  @override
  Future<bool> _cookieLogIn(String cookie) async {
    if (cookie == null) {
      return false;
    }
    try {
      int statusCode = await http.get(homeUrl,
          headers: {'Cookie': cookie}).then((value) => value.statusCode);
      switch (statusCode) {
        case (200):
          return true;
        case (302):
          return false;
      }
    } catch (e) {
      throw ('Connection error');
    }
    return false;
  }

  @override
  Future<AuthStatus> _checkStatus() {
    // TODO: implement checkStatus
    throw UnimplementedError();
  }
}

const String homeUrl = 'http://umsyn.liu.edu.lb/student/myClasses/';
