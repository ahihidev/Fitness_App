import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        elevation: 0,
        title: Text(
          "Settings",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionTitle("Profile settings"),
          _buildSettingItem(
            icon: Icons.scale,
            title: "Set units",
            onTap: () {},
          ),
          const Divider(),
          _buildSectionTitle("Privacy"),
          _buildToggleItem(
            icon: Icons.bar_chart,
            title: "Display my measurements everywhere",
            value: false,
          ),
          const Divider(),
          _buildSectionTitle("Push notifications"),
          _buildToggleItem(
            icon: Icons.timer,
            title: "On timer expiration",
            value: true,
          ),
          _buildDropdownItem(
            icon: Icons.music_note,
            title: "Timer sound",
            value: "Sound 1",
          ),
          const Divider(),
          _buildSectionTitle("Other"),
          _buildSettingItem(
            icon: Icons.sync,
            title: "Data exchange",
            onTap: () {},
          ),
          _buildToggleItem(
            icon: Icons.format_quote,
            title: "Motivational phrases",
            value: true,
          ),
          _buildDropdownItem(
            icon: Icons.style,
            title: "Appearance",
            value: "Light theme",
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildSettingItem({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 16),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildToggleItem({required IconData icon, required String title, required bool value}) {
    return SwitchListTile(
      activeColor: Colors.pinkAccent,
      secondary: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 16),
      ),
      value: value,
      onChanged: (bool newValue) {},
    );
  }

  Widget _buildDropdownItem({required IconData icon, required String title, required String value}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 16),
      ),
      trailing: Text(
        value,
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
      ),
      onTap: () {},
    );
  }
}