import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseMethods{

  static Future<bool> checkIfEmailExist(String email,String collection) async {
    CollectionReference usersInformation = FirebaseFirestore.instance.collection(collection);
    QuerySnapshot querySnapshot = await usersInformation.where('email', isEqualTo: email).get();
    // print(email);
    return querySnapshot.docs.isNotEmpty;
  }

  static void addClientInformation(String name, String email, String phone, String location) {
    CollectionReference usersInformation = FirebaseFirestore.instance.collection(CollectionsNames.clientsInformation);
    usersInformation
        .add({
      'full_name': name,
      'email': email,
      'phone': phone,
      'location': location,
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  static Future<void> signInWithEmailPassword(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // FirebaseAuth.instance.verifyPasswordResetCode(code)
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      rethrow; // Rethrow the exception to handle it in the calling function
    } catch (e) {
      print(e);
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

}

class CollectionsNames{
  static String clientsInformation = "clients_information";
  static String handymenInformation = "handymen_information";
  static bool isExit = false;
}