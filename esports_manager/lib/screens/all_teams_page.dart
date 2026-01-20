

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AllTeamsPage extends StatefulWidget {
  const AllTeamsPage({super.key});

  @override
  State<AllTeamsPage> createState() => _AllTeamsPageState();
}

class _AllTeamsPageState extends State<AllTeamsPage> {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchTeams() async {
    final response = await supabase
        .from('teams')
        .select()
        .order('created_at', ascending: false) as List<dynamic>;

    return response.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F5),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "All Teams",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.emoji_events),
            ),
          ],
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFD32F2F), Color(0xFFFF5252)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(26),
              ),
            ),
          ),
        ),
      ),

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchTeams(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFD32F2F)),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No teams registered yet"));
          }

          final teams = snapshot.data!;

          return Column(
            children: [
              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _infoTile(
                        icon: Icons.groups,
                        label: "Teams",
                        value: teams.length.toString(),
                      ),
                      _infoTile(
                        icon: Icons.sports_esports,
                        label: "Players",
                        value: "${teams.length * 5}+",
                      ),
                      _infoTile(
                        icon: Icons.emoji_events,
                        label: "Tournaments",
                        value: "Live",
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Registered Squads 🎮",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD32F2F),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: GridView.builder(
                    itemCount: teams.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.68,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final team = teams[index];

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: 90,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(16)),
                                    image: DecorationImage(
                                      image: team['logo_url'] != null &&
                                              team['logo_url'].isNotEmpty
                                          ? NetworkImage(team['logo_url'])
                                          : const AssetImage(
                                                  'assets/placeholder.png')
                                              as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD32F2F),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text(
                                      "TEAM",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    team['team_name'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFD32F2F),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  const SizedBox(height: 4),

                                  Row(
                                    children: [
                                      const Icon(Icons.person,
                                          size: 12,
                                          color: Color(0xFFFF5252)),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          team['manager_name'] ?? '',
                                          style:
                                              const TextStyle(fontSize: 11),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const Divider(height: 10),

                                  _playerText("🎯 IGL", team['igl'] ?? ''),
                                  _playerText("🎮 P2", team['player2'] ?? ''),
                                  _playerText("🎮 P3", team['player3'] ?? ''),
                                  _playerText("🎮 P4", team['player4'] ?? ''),
                                  _playerText(
                                      "🧑‍🔄 Sub", team['substitute'] ?? 'N/A'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _playerText(String label, String name) {
    return Text(
      "$label: $name",
      style: const TextStyle(fontSize: 11),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _infoTile(
      {required IconData icon,
      required String label,
      required String value}) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFD32F2F), size: 26),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.black54),
        ),
      ],
    );
  }
}
