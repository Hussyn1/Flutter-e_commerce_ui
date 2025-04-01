import 'package:chat_app/screens/view/pages/fireBaseAuthServices/AuthServices.dart';
import 'package:chat_app/screens/view/pages/widget/customBtn.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
  String userEmail;
  String userPhonenumber;
  String profilePicture;
  String userName;
  ProfilePage({
    Key? key,
    required this.userEmail,
    required this.userPhonenumber,
    required this.profilePicture,
    required this.userName,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: const Color(0xFF6a5bc2),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          // Profile Image
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: NetworkImage(
                        "${widget.profilePicture}") // Placeholder image
                    ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {
                      // Add functionality to upload/change profile picture
                    },
                    child: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(0xFF6a5bc2),
                      child:
                          Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Profile Info Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildTextField(
                    controller: nameController,
                    labelText: '${widget.userName}',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: emailController,
                    labelText: '${widget.userEmail}',
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: phoneController,
                    labelText: '${widget.userPhonenumber}',
                    icon: Icons.phone,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: CustomBtn(
                text: "Logout",
                onPressed: () {
                  AuthServices().logout();
                }),
          )
        ],
      ),
      backgroundColor: const Color(0xFFF5F5F5),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF6a5bc2)),
        labelText: labelText,
        labelStyle: const TextStyle(color: Color(0xFF6a5bc2)),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
