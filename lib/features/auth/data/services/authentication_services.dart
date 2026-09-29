import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

// Web Client ID from app-forge-339be google-services.json
const String _webClientId =
    '84122045736-l2it1o2gj75j8145c0jru0icq7hurn91.apps.googleusercontent.com';

Future<UserCredential?> customerSignUp({
  required String name,
  required String email,
  required String password,
  required String phone,
}) async {
  try {
    final UserCredential userCredential = await _auth
        .createUserWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );

    // Save display name directly in Firebase Auth
    await userCredential.user?.updateDisplayName(name.trim());

    return userCredential;
  } on FirebaseAuthException catch (e) {
    throw e.message ?? 'Firebase Authentication Error: ${e.code}';
  } catch (e) {
    throw 'Sign Up Error: $e';
  }
}

Future<UserCredential?> customerLogin({
  required String email,
  required String password,
}) async {
  try {
    final UserCredential userCredential = await _auth
        .signInWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );

    return userCredential;
  } on FirebaseAuthException catch (e) {
    throw e.message ?? 'Firebase Login Error: ${e.code}';
  } catch (e) {
    throw 'Login Error: $e';
  }
}

Future<void> customerLogout() async {
  await _auth.signOut();
  await _googleSignIn.signOut();
}

Future<UserCredential?> customerSignUpWithGoogle() async {
  try {
    await _googleSignIn.initialize(serverClientId: _webClientId);
    await _googleSignIn.signOut();

    final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();

    if (googleUser == null) {
      return null;
    }

    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential = await _auth.signInWithCredential(
      credential,
    );

    return userCredential;
  } on FirebaseAuthException catch (e) {
    throw e.message ?? 'Firebase Google Sign-In Error: ${e.code}';
  } on GoogleSignInException catch (e) {
    if (e.code == GoogleSignInExceptionCode.canceled) {
      return null;
    }
    throw 'Google Sign-In Error [${e.code}]: ${e.description}';
  } catch (e) {
    throw 'Google Sign-In Error: $e';
  }
}
