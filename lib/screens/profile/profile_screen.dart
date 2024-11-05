import 'package:flutter/material.dart';
import 'package:down_care/api/logoutApi.dart';
import 'package:down_care/api/user_api.dart';
import 'package:down_care/screens/profile/profile_menu_item.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:down_care/widgets/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/avatar.png'),
                      ),
                      const SizedBox(height: 10),
                      FutureBuilder<Map<String, dynamic>>(
                        future: UserService().getCurrentUserData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return const Text('Error loading user data');
                          } else {
                            final user = snapshot.data!;
                            final username = user['displayName'] as String? ?? 'Unknown User';

                            return Text(
                              username,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildSection(
                  context,
                  title: "Akun",
                  items: [
                    ProfileMenuItem(
                      icon: Icons.person,
                      text: "Perbarui Profil",
                      onTap: () {},
                    ),
                    ProfileMenuItem(
                      icon: Icons.lock,
                      text: "Ubah Kata Sandi",
                      onTap: () {},
                    ),
                    ProfileMenuItem(
                      icon: Icons.delete_outline,
                      text: "Hapus Akun",
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSection(
                  context,
                  title: "Notifikasi",
                  items: [
                    ProfileMenuItem(
                      icon: Icons.notifications,
                      text: "Notifikasi Aplikasi",
                      onTap: () {},
                    ),
                    ProfileMenuItem(
                      icon: Icons.email,
                      text: "Notifikasi Email",
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSection(
                  context,
                  title: "Informasi Lainnya",
                  items: [
                    ProfileMenuItem(
                      icon: Icons.info_outline,
                      text: "Tentang Aplikasi",
                      onTap: () {},
                    ),
                    ProfileMenuItem(
                      icon: Icons.logout,
                      text: "Keluar",
                      textColor: Colors.red,
                      onTap: () {
                        _showLogoutConfirmation(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required List<Widget> items}) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.2),
            spreadRadius: 0.5,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.leagueSpartan().fontFamily,
              ),
            ),
          ),
          Divider(color: Theme.of(context).colorScheme.secondary),
          ...items,
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Logout',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                    color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 10),
              Text(
                'Apakah anda yakin ingin keluar?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    widthFactor: 0.4,
                    heightFactor: 0.05,
                    text: 'Batal',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.white,
                    textColor: Colors.black,
                    borderSide: const BorderSide(color: Colors.black, width: 1.5),
                  ),
                  CustomButton(
                    widthFactor: 0.4,
                    heightFactor: 0.05,
                    text: 'Keluar',
                    onPressed: () async {
                      Navigator.pop(context); // Close the modal
                      await logoutUser(context); // Perform logout action here
                    },
                    color: Colors.red[400],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
