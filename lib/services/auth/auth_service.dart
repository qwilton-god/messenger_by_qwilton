import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthService({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      // заходим
      UserCredential userCredential = 
        await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        "uid": userCredential.user!.uid,
        "email": email,
      }, SetOptions(merge: true));

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }
  

  //create user
  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      

      //add user to firestore
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        "uid": userCredential.user!.uid,
        "email": email,
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }
  //sign out
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

    
    
}
