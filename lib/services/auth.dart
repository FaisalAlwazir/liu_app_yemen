import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

enum AuthStatus {
  Undefined,
  ConnectionError,
  LoggedOut,
  LoggedIn,
}

abstract class BaseAuth {
  final storage = FlutterSecureStorage();

  AuthStatus status = AuthStatus.Undefined;

  Future<AuthStatus> checkStatus();

  Future<bool> logIn(String id, String password);

  /// checking if a cookie is still valid
  Future<bool> _cookieLogIn(String cookie);

  Future<bool> logOut(String id, String password);
}

class Auth extends BaseAuth {
  @override
  Future<bool> logIn(String id, String password) {
    // TODO: implement logIn
    throw UnimplementedError();
  }

  @override
  Future<bool> logOut(String id, String password) {
    // TODO: implement logOut
    throw UnimplementedError();
  }

  @override
  Future<bool> _cookieLogIn(String cookie) {
    // TODO: implement cookieLogIn
    throw UnimplementedError();
  }

  @override
  Future<AuthStatus> checkStatus() {
    // TODO: implement checkStatus
    throw UnimplementedError();
  }
}
