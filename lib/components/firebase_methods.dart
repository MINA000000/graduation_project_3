import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseMethods{

  static Future<bool> checkIfUserExists(String uid, String collection) async {
    // Get a reference to the Firestore collection
    CollectionReference usersInformation = FirebaseFirestore.instance.collection(collection);

    // Query the collection to check if a document with the given uid exists
    DocumentSnapshot documentSnapshot = await usersInformation.doc(uid).get();

    // Return true if the document exists, otherwise return false
    return documentSnapshot.exists;
  }

  static Future<void> setClientInformation({
    required String uid,
    required String email,
    required String fullName,
    required double latitude,
    required double longitude,
    required String phoneNumber,
    required DateTime timestamp,
  }) async {
    try {
      // Reference to the Firestore collection
      final CollectionReference handymenCollection =
      FirebaseFirestore.instance.collection('clients_information');

      // Set or update the document with the given UID
      await handymenCollection.doc(uid).set({
        'email': email,
        'full_name': fullName,
        'latitude': latitude,
        'longitude': longitude,
        'phone_number': phoneNumber,
        'timestamp': timestamp,
      }, SetOptions(merge: true)); // Use merge to update specific fields without overwriting the entire document

      print('Handyman information set/updated successfully for UID: $uid');
    } catch (e) {
      rethrow;
    }
  }
  static Future<void> signInWithEmailPassword(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      rethrow; // Rethrow the exception to handle it in the calling function
    } catch (e) {
      // print(e);
      rethrow;
    }
  }

  static Future<bool> signInWithGoogle() async {
    try {
      // Sign out any previously signed-in user
      await GoogleSignIn().signOut();

      // Trigger Google Sign-In
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return false; // User canceled the sign-in process
      }

      // Get authentication details from Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a credential from Google's access token and ID token
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Check if the user is successfully signed in
      final User? user = userCredential.user;
      if (user != null) {
        return true; // Sign-in successful
      } else {
        return false; // Firebase sign-in failed
      }
    } catch (error) {
      // Handle any errors that occur during the process
      print('Error during Google Sign-In: $error');
      return false; // Return false if an error occurs
    }
  }

  static Future<String> uploadImage(File imageFile) async {
    // Get a reference to the storage location
    final storageRef = FirebaseStorage.instance.ref().child('images/${DateTime.now().millisecondsSinceEpoch}.png');

    // Upload the image
    final uploadTask = storageRef.putFile(
      imageFile,
      SettableMetadata(contentType: 'image/png'), // Set the content type
    );

    // Monitor the upload progress
    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      print('Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100}%');
    });

    // Wait for the upload to complete
    await uploadTask;

    // Get the download URL
    String downloadURL = await storageRef.getDownloadURL();
    return downloadURL;
    print('File uploaded, download URL: $downloadURL');
  }
  static Future<void> setHandymanInformation({
    required String uid,
    required String category,
    required String description,
    required String email,
    required String explicitSkills,
    required String fullName,
    required String implicitSkills,
    required double latitude,
    required double longitude,
    required String phoneNumber,
    required String profilePicture,
    required double ratingAverage,
    required int ratingCount,
    required DateTime timestamp,
  }) async {
    try {
      // Reference to the Firestore collection
      final CollectionReference handymenCollection =
      FirebaseFirestore.instance.collection('handymen_information');

      // Set or update the document with the given UID
      await handymenCollection.doc(uid).set({
        'category': category,
        'description': description,
        'email': email,
        'explicit_skills': explicitSkills,
        'full_name': fullName,
        'implicit_skills': implicitSkills,
        'latitude': latitude,
        'longitude': longitude,
        'phone_number': phoneNumber,
        'profile_picture': profilePicture,
        'rating_average': ratingAverage,
        'rating_count': ratingCount,
        'timestamp': timestamp,
      }, SetOptions(merge: true)); // Use merge to update specific fields without overwriting the entire document

      print('Handyman information set/updated successfully for UID: $uid');
    } catch (e) {
      rethrow;
    }
  }
}
class CollectionsNames{
  static String clientsInformation = "clients_information";
  static String handymenInformation = "handymen_information";
  static bool isExit = false;
}