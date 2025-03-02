
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/client_screens/handyman_details.dart';
import 'package:grad_project/components/firebase_methods.dart';
import 'package:grad_project/components/collections.dart';

class HanymenProfiles extends StatefulWidget {
  String categoryName;
  HanymenProfiles({required this.categoryName});

  @override
  State<HanymenProfiles> createState() => _HanymenProfilesState();
}

class _HanymenProfilesState extends State<HanymenProfiles> {
  bool masterLoading = true;
  List<QueryDocumentSnapshot> handymen=[];

  Future<void> fetchHandymenData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(CollectionsNames.handymenInformation)
          .where('category', isEqualTo: widget.categoryName)
          .get();
      handymen = querySnapshot.docs;
      setState(() {
        masterLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        masterLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();  // ✅ Always call super.initState() first
    fetchHandymenData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No default AppBar – we use our custom top bar in the body.
      body:masterLoading?Center(child: CircularProgressIndicator(color: Colors.blue,),): Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.71, -0.71),
            end: Alignment(-0.71, 0.71),
            colors: [Color(0xFF56AB94), Color(0xFF53636C)],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 80), // Top spacing
            // Custom Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const Text(
                    'Handymen',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Nunito',
                    ),
                  ),
                  const Icon(Icons.settings, color: Colors.white),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // List of Handymen
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: handymen.length,
                itemBuilder: (context, index) {
                  final handyman = handymen[index];
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HandymanDetailsPage(handyman: handyman),));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(handyman[HandymanFieldsName.profilePicture]),
                        ),
                        title: Text(
                          handyman[HandymanFieldsName.fullName],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(handyman[HandymanFieldsName.category]),
                            Text('He did ${handyman[HandymanFieldsName.projectsCount]} projects'),
                            Row(
                              children: List.generate(
                                5,
                                    (i) => Icon(
                                  i < handyman[HandymanFieldsName.ratingAverage].floor()
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.orange,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Custom Bottom Navigation Bar
            Container(
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Icon(Icons.home, size: 28),
                  Icon(Icons.person, size: 28),
                  Icon(Icons.search, size: 28),
                  Icon(Icons.insert_drive_file, size: 28),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
