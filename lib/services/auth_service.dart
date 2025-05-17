import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class AuthService {
  Future<bool> logout() async {
    // Awaiting the current user to get a ParseUser instance
    ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;

    if (currentUser != null) {
      final response = await currentUser.logout();
      return response.success;
    }
    return false;
  }
}
