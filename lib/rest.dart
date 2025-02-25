import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/components/firebase_methods.dart';
import 'package:grad_project/main.dart';
import 'package:provider/provider.dart';
import 'ProviderMina.dart';

class Rest extends StatelessWidget {
   // Constructor to receive the email



  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<Providermina>(context);
    // print(settingProvider.email);
    return FutureBuilder<bool>(
      future: FirebaseMethods.checkIfEmailExist(FirebaseAuth.instance.currentUser!.email!,CollectionsNames.clientsInformation), // Perform the async operation
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for the result
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          // Handle errors
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (snapshot.hasData) {
          // Update the provider role based on the result
          if (snapshot.data!) {
            settingProvider.role = 'client';
          } else {
            settingProvider.role = 'handyman';
          }

          // Return the appropriate home page
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(onPressed: ()async{
                  await FirebaseAuth.instance.signOut();
                  //TODO
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>ChooseScreen()), (route)=>false);
                }, icon: Icon(Icons.exit_to_app))
              ],
            ),
            body: Center(
              child: (settingProvider.role == 'client') ? ClientHome() : HandymanHome(),
            ),
          );
        } else {
          // Handle the case where no data is returned
          return Scaffold(
            body: Center(child: Text('No data found')),
          );
        }
      },
    );
  }
}

class ClientHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Client Home Page")),
    );
  }
}

class HandymanHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Handyman Home Page")),
    );
  }
}