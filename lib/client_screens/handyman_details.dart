import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grad_project/components/image_viewer_screen.dart';

import '../components/firebase_methods.dart';
import '../components/collections.dart';

class HandymanDetailsPage extends StatefulWidget {
  QueryDocumentSnapshot handyman;
  HandymanDetailsPage({required this.handyman});

  @override
  State<HandymanDetailsPage> createState() => _HandymanDetailsPageState();
}

class _HandymanDetailsPageState extends State<HandymanDetailsPage> {
  List<QueryDocumentSnapshot> workPictures=[];
  List<QueryDocumentSnapshot> comments=[];
  bool masterLoading = true;

  String formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return "${date.day}/${date.month}/${date.year}";
  }

  Future<void> fetchWorkPictures() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(CollectionsNames.handymenInformation)
          .doc(widget.handyman.id)
          .collection(CollectionsNames.workPictures)
          .get();
      workPictures = querySnapshot.docs;
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
  Future<void> fetchComments() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(CollectionsNames.handymenInformation)
          .doc(widget.handyman.id)
          .collection(CollectionsNames.comments)
          .get();
      comments = querySnapshot.docs;
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
    fetchWorkPictures();
    fetchComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: masterLoading?Center(child: CircularProgressIndicator(color: Colors.blue,),):Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.71, -0.71),
            end: Alignment(-0.71, 0.71),
            colors: [Color(0xFF56AB94), Color(0xFF53636C)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // Top Bar
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
                              'Details',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Nunito',
                              ),
                            ),
                            const Icon(Icons.settings, color: Colors.white),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Handyman Image
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ImageViewerScreen(imageUrl: widget.handyman[HandymanFieldsName.profilePicture]),));
                        },
                        child: Container(
                          width: 180,
                          height: 160,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(widget.handyman[HandymanFieldsName.profilePicture]),
                              fit: BoxFit.fill,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Name & Job Title
                       Text(
                        widget.handyman[HandymanFieldsName.fullName],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFF5F5F5),
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                       Text(
                         widget.handyman[HandymanFieldsName.category],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFF5F5F5),
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                       Text(
                        widget.handyman[HandymanFieldsName.email],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFF5F5F5),
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                       Text(
                         widget.handyman[HandymanFieldsName.phoneNumber],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFF5F5F5),
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      // Info display in it implicit/explicit skills and description
                      Card(
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          title: Text('About me'),
                          subtitle: Text(widget.handyman[HandymanFieldsName.description]),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Photos Section Title
                      const Text(
                        'photos',
                        style: TextStyle(
                          color: Color(0xFFF5F5F5),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 5,),
                      // Photos Scrollable Row
                      workPictures.isEmpty?Text('There is no pictures'):SizedBox(
                        height: 80,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          children: List.generate(
                            workPictures.length,
                          (index) => GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (_)=>ImageViewerScreen(imageUrl:workPictures[index]['image_url'])));
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: 106.54,
                              height: 70,
                              decoration: BoxDecoration(
                            image:  DecorationImage(
                              image: NetworkImage(workPictures[index]['image_url']),
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Comments',
                        style: TextStyle(
                          color: Color(0xFFF5F5F5),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 5,),
                      comments.isEmpty? Text('There is no comments'):SizedBox(
                        height: 200, // Increase height
                        child: ListView.builder(
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            var comment = comments[index];
                            return Card(
                              margin: EdgeInsets.all(8),
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text(comment[HandymanComments.clientName][0].toUpperCase()),
                                ),
                                title: Text(comment[HandymanComments.clientName]),
                                subtitle: Text(comment[HandymanComments.comment]),
                                trailing: Text(
                                  comment[HandymanComments.time] != null
                                      ? formatDate(comment[HandymanComments.time])
                                      : "Just now",
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 5,),
                      // "Make my request" Button
                      ElevatedButton(
                        onPressed: () {
                          // Add action here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF3D00),
                          padding:
                          const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Make my request',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito',
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 80), // Space for bottom navbar
                    ],
                  ),
                ),
              ),
              // Bottom Navigation Bar
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 60,
                  width: double.infinity,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentBox(String comment) {
    return Container(
      width: 180,
      height: 60,
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          comment,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
