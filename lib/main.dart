


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/ProviderMina.dart';
import 'package:grad_project/login.dart';
import 'package:grad_project/rest.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'client_signup.dart'; // Import the Client SignUp page
import 'components/firebase_methods.dart';
import 'handyman_signup.dart'; // Import the Handyman SignUp page

void main() async{
  // FirebaseAuth.instance.verifyPasswordResetCode(code)
  try{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    if(FirebaseAuth.instance.currentUser!=null)
      {
        bool handymanExit = await FirebaseMethods.checkIfEmailExist(FirebaseAuth.instance.currentUser!.email!, CollectionsNames.handymenInformation);
        bool clientExit = await FirebaseMethods.checkIfEmailExist(FirebaseAuth.instance.currentUser!.email!, CollectionsNames.clientsInformation);
        if(handymanExit||clientExit)
          {
            CollectionsNames.isExit = true;
          }
      }
    // print("fire base correctly initialized");
  }
  catch(e){
    print("some goes wrong with error : $e");
  }
  runApp(
    ChangeNotifierProvider(
      create: (context) => Providermina(), // Provide an instance of CounterModel
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: (FirebaseAuth.instance.currentUser!=null&&FirebaseAuth.instance.currentUser!.emailVerified&&CollectionsNames.isExit)?Rest():ChooseScreen(),
    );
  }
}

class ChooseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final providerSetting = Provider.of<Providermina>(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.71, -0.71),
                end: Alignment(-0.71, 0.71),
                colors: [Color(0xFF56AB94), Color(0xFF53636C)],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Handyman Option
                  GestureDetector(
                    onTap: () {
                      providerSetting.role = 'handyman';
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: Lottie.asset('assets/handyman.json'),
                        ),
                        const Text(
                          'Handyman',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
          
                  const SizedBox(height: 30),
          
                  // Client Option
                  GestureDetector(
                    onTap: () {
                      providerSetting.role = 'client';
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: Lottie.asset('assets/client.json'),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Client',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
