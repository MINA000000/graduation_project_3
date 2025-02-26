import 'package:flutter/material.dart';
import 'package:grad_project/components/category_skills.dart';
import 'package:grad_project/components/location_methods.dart';
import "package:lottie/lottie.dart";
import 'login.dart';


class HandymanSignUp extends StatefulWidget {
  @override
  _HandymanSignUpState createState() => _HandymanSignUpState();
}

class _HandymanSignUpState extends State<HandymanSignUp> {
  List<bool> _selectedSkills = List.generate(5, (_) => false);
  List<String> skillsName = [];
  String _selectedCategory = 'Carpenter';
  // Position position = Position(longitude: 0, latitude: 0);
  final TextEditingController _projectInfoController = TextEditingController();

  @override
  void dispose() {
    _projectInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.71, -0.71),
            end: Alignment(-0.71, 0.71),
            colors: [Color(0xFF56AB94), Color(0xFF53636C)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    padding: EdgeInsets.only(
                        top: 30, left: 20, right: 20, bottom: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        // Sign Up Title (inside the box)
                        Text(
                          'Sign up',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Nunito',
                          ),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: (){

                          },
                          child: Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 3),
                                  boxShadow: [
                                    BoxShadow(color: Colors.black26, blurRadius: 10),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.asset('assets/avatar.png', fit: BoxFit.cover),
                                ),
                              ),
                              Icon(Icons.add,size: 100,color: Colors.blueGrey,),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        // First and Last Name
                        Row(
                          children: [
                            Expanded(
                                child: _buildTextField(
                                    'First name', Icons.person)),
                            SizedBox(width: 10),
                            Expanded(
                                child:
                                    _buildTextField('Last name', Icons.person)),
                          ],
                        ),
                        SizedBox(height: 8),

                        // Email
                        _buildTextField('Email address', Icons.email),
                        SizedBox(height: 8),

                        // Password
                        //_buildTextField('Password', Icons.lock, obscureText: true),
                        _buildPasswordField("Password"),
                        SizedBox(height: 8),

                        // Confirm Password
                        //_buildTextField('Confirm password', Icons.lock, obscureText: true),
                        _buildPasswordField(" Confirm Password"),
                        SizedBox(height: 8),

                        // Location
                        TextButton(
                          //TODO
                          onPressed: () async {
                            await LocationMethods.getUserLocation();
                          },
                          child: Text("Get Location"),
                        ),

                        SizedBox(height: 8),

                        // Phone Number
                        _buildTextField('Phone number', Icons.phone),
                        SizedBox(height: 8),

                        // Category Dropdown
                        DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: InputDecoration(
                            prefixIcon:
                                Icon(Icons.category, color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          items: [
                            'Carpenter',
                            'Plumbing',
                            'Blacksmith',
                            'Electrical',
                            'Painter',
                            'Aluminum worker',
                            'Marble worker',
                            'Upholsterer',
                            // 'Other'
                          ]
                              .map((category) => DropdownMenuItem(
                                    child: Text(category),
                                    value: category,
                                  ))
                              .toList(),
                          onChanged: (value) {
                            _selectedSkills = List.generate(5, (_) => false);
                            setState(() {
                              _selectedCategory = value!;
                            });
                          },
                        ),
                        SizedBox(height: 20),

                        // Skills Checkboxes
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(CategorySkills.categorySkills[_selectedCategory]!.length, (index) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: _selectedSkills[index],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedSkills[index] = value!;
                                    });
                                  },
                                ),
                                Text('${CategorySkills.categorySkills[_selectedCategory]![index]}',style: TextStyle(color: Colors.deepOrange),),
                              ],
                            );
                          }),
                        ),
                        SizedBox(height: 20),

                        // Project Info Text Field
                        TextField(
                          controller: _projectInfoController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'Add information about your projects',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        // Sign Up Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFF3C00),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                              );
                            },
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                fontSize: 28,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),

                        // Social Media Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSocialButton('assets/google.png'),
                            SizedBox(width: 50),
                            _buildSocialButton('assets/facebook.png'),
                            SizedBox(width: 50),
                            _buildSocialButton('assets/apple.png'),
                          ],
                        ),
                        SizedBox(height: 20),

                        // Log In Option
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                );
                              },
                              child: Text(
                                'Log in',
                                style: TextStyle(
                                  color: Color(0xFFFF3C00),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Privacy Policy
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Privacy policy',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Gear GIF Positioned on top of the border box
                Positioned(
                  top: -55,
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: Lottie.asset('assets/gear_loading.json'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper Methods

  Widget _buildTextField(String hint, IconData icon,
      {bool obscureText = false}) {
    return SizedBox(
      height: 45,
      child: TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey),
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // Build Password Field
  static Widget _buildPasswordField(String hint) {
    return SizedBox(
      height: 40,
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock, color: Colors.grey),
          suffixIcon: const Icon(Icons.visibility_off, color: Colors.grey),
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String assetPath) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Image.asset(
          assetPath,
          width: 40,
          height: 40,
        ),
      ),
    );
  }
}
