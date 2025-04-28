import 'package:shared_preferences/shared_preferences.dart';

class Tokenmanager {
  static const _tokenkey = 'auth_token';
  static Future<void> SaveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenkey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenkey);
  }
}
