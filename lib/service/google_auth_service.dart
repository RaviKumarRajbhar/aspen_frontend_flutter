import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: "553578623185-cjaashivts75uok5jf08pb36f3qvhso3.apps.googleusercontent.com",
    scopes: [
      'email',
      'profile',
      'openid',
    ],
  );

  Future<String> signIn() async {

    await _googleSignIn.signOut();

    final account = await _googleSignIn.signIn();

    if (account == null) {
      throw Exception("User cancelled login");
    }

    final auth = await account.authentication;

    final idToken = auth.idToken;

    if (idToken == null) {
      throw Exception("ID token missing");
    }

    return idToken;
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
  }
}