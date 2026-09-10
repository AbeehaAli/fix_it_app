import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final GoogleSignIn googleSignIn = GoogleSignIn.instance;

Future<UserCredential?> customersignUp({
  required String name,
  required String email,
  required String password,
  required String phone,
}) async {
  try {
    UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    String uid = userCredential.user!.uid;

    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'name': name.trim(),
      'email': email.trim(),
      'phone': phone.trim(),
      'role': 'customer',
      'createdAt': FieldValue.serverTimestamp(),
    });

    print('Account created Successfully');
    print('UID: $uid');

    return userCredential;
  } on FirebaseAuthException catch (e) {
    print('Firebase Authentication Error');
    print('Code: ${e.code}');
    print('Sign Up Error: $e');
    return null;
  } catch (e) {
    print('Sign Up Error: $e');
    return null;
  }
}
Future<UserCredential?> customerLogin({
  required String email,
  required String password,
})async {
  try {
    UserCredential userCredential=await _auth.signInWithEmailAndPassword(email:email.trim(),password:password.trim());
    print('Login Succesfully');
    print('UID : ${userCredential.user?.uid}');
    return userCredential;
  } on FirebaseAuthException catch (e) {
    print('Firebase Login Error');
    print('Code :${e.code}');
    print('Message: ${e.message}');
    return null;
  }catch (e){
    print('Login Error : $e');
    return null;
  }
}
Future<void> customerlogout() async {
  await _auth.signOut();
}


Future<UserCredential?> customersignUpWithGoogle() async {
  try {
    final GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider.addScope(
      'https://www.googleapis.com/auth/userinfo.email',
    );

    googleProvider.addScope(
      'https://www.googleapis.com/auth/userinfo.profile',
    );

    final UserCredential userCredential =
        await _auth.signInWithPopup(googleProvider);

    print('Google Sign-In successful!');
    print('Email: ${userCredential.user?.email}');

    return userCredential;
  } on FirebaseAuthException catch (e) {
    print('Firebase Google Sign-In Error: ${e.code}');
    print('Message: ${e.message}');
    return null;
  } catch (e) {
    print('Google Sign-In Error: $e');
    return null;
  }
}

