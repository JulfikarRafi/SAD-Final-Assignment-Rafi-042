



import 'package:esports_manager/screens/manage_teams_page.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'add_team_page.dart';
import 'all_teams_page.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F5), 
      appBar: AppBar(
  elevation: 0,
  centerTitle: false,
  toolbarHeight: 70,
  flexibleSpace: Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFFB71C1C),
          Color(0xFFD32F2F),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ),
  title: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
      Text(
        "Tournament Dashboard",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      SizedBox(height: 4),
      Text(
        "Manage • Compete • Win",
        style: TextStyle(
          fontSize: 12,
          color: Colors.white70,
        ),
      ),
    ],
  ),
  actions: [
    const SizedBox(width: 8),
    IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () async {
        await authService.logout();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      },
    ),
    const SizedBox(width: 8),
  ],
),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFFD32F2F), Color(0xFFFF5252)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Banner Image
                  Expanded(
                    flex: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: ClipRRect(
  borderRadius: BorderRadius.circular(16),
  child: Image.network(
    'https://i.ibb.co.com/Z6LVJTby/gpc.jpg', 
    fit: BoxFit.cover,
    height: 120,
  ),
),

                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Manage Your Esports Teams Effortlessly",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Track, organize, and grow your esports teams all in one platform. Create tournaments, manage squads, and stay competitive!",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _navButton(
                    context,
                    title: "Add Team",
                    icon: Icons.add_circle_outline,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddTeamPage()),
                    ),
                  ),
                  _navButton(
                    context,
                    title: "All Teams",
                    icon: Icons.groups,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AllTeamsPage()),
                    ),
                  ),
                  _navButton(
                    context,
                    title: "Manage Teams",
                    icon: Icons.settings,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ManageTeamsPage()),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _featureCard(
                    icon: Icons.emoji_events,
                    title: "Tournaments",
                    description:
                        "Create, manage and track tournaments for your teams. Stay competitive and organized.",
                    color: const Color(0xFFD32F2F),
                  ),
                  _featureCard(
                    icon: Icons.sports_esports,
                    title: "Team Stats",
                    description:
                        "Monitor player performance, track stats and manage your squad effectively.",
                    color: const Color(0xFFFF5252),
                  ),
                  _featureCard(
                    icon: Icons.people,
                    title: "Community",
                    description:
                        "Connect with other players, share strategies, and grow your esports network.",
                    color: const Color(0xFFD32F2F),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ================= Welcome Message =================
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Welcome to the Ultimate Esports Management Platform!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD32F2F),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Navigation Button Widget
  Widget _navButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton.icon(
          icon: Icon(icon, size: 18, color: Colors.white),
          label: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD32F2F),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }

  // Feature Card Widget
  Widget _featureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.9), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
