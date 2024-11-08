import 'package:down_care/screens/profile/about_app/about_app.dart';
import 'package:down_care/screens/profile/change_password/change_password.dart';
import 'package:down_care/screens/profile/delete_account/delete_account.dart';
import 'package:flutter/material.dart';
import 'package:down_care/api/logoutApi.dart';
import 'package:down_care/api/user_api.dart';
import 'package:down_care/screens/profile/profile_menu_item.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:down_care/widgets/custom_button.dart';
import 'package:down_care/screens/profile/update_profil/update_profile.dart';
import 'package:down_care/utils/transition.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                      FutureBuilder<Map<String, dynamic>>(
                        future: UserService().getCurrentUserData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return const Text('Error loading user data');
                          } else {
                            final user = snapshot.data!;
                            final profileUrl = user['photoURL'] as String? ?? '';

                            return CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: profileUrl.isNotEmpty ? NetworkImage(profileUrl) : null,
                              child: profileUrl.isEmpty ? const Icon(Icons.person, color: Colors.white, size: 40) : null,
                            );
                          }
                        },
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
                            final avatarUrl = user['photoURL'] as String? ?? '';
                            final username = user['displayName'] as String? ?? 'Unknown User';

                            return Column(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : const AssetImage('assets/avatar.png') as ImageProvider,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  username,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                  ),
                                ),
                              ],
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
                      svgPath: "assets/icon/profile.svg",
                      text: "Perbarui Profil",
                      onTap: () {
                        Navigator.push(
                          context,
                          createRoute(const UpdateProfileScreen()),
                        );
                      },
                    ),
                    ProfileMenuItem(
                      // icon: Icons.lock,
                      svgPath: "assets/icon/key.svg",
                      text: "Ubah Kata Sandi",
                      onTap: () {
                        Navigator.push(
                          context,
                          createRoute(const ChangePasswordScreen()),
                        );
                      },
                    ),
                    ProfileMenuItem(
                      icon: Icons.delete_outline,
                      text: "Hapus Akun",
                      onTap: () {
                        Navigator.push(
                          context,
                          createRoute(const DeleteAccountScreen()),
                        );
                      },
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
                      onTap: () {
                        Navigator.push(
                          context,
                          createRoute(const AboutAppScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: CustomButton(
          text: 'Keluar',
          color: Colors.red[600],
          onPressed: () {
            _showLogoutConfirmation(context);
          },
          icon: Icons.logout,
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
                'Keluar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                  color: Colors.red[600],
                ),
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
                    color: Colors.red[600],
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
