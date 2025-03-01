
import 'package:flutter/material.dart';

class HanymanProfile extends StatelessWidget {
  final List<Map<String, dynamic>> handymen = List.generate(4, (index) {
    return {
      'name': 'Amr Ali Ahmed',
      'profession': 'Plumber',
      'projects': 50,
      'rating': 4.5,
      'imageUrl': 'https://via.placeholder.com/150', // Placeholder image
    };
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No default AppBar – we use our custom top bar in the body.
      body: Container(
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
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(handyman['imageUrl']),
                      ),
                      title: Text(
                        handyman['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(handyman['profession']),
                          Text('He did ${handyman['projects']} projects'),
                          Row(
                            children: List.generate(
                              5,
                                  (i) => Icon(
                                i < handyman['rating'].floor()
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
