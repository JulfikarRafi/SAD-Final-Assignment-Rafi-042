


import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:esports_manager/screens/edit_team_page.dart';

class ManageTeamsPage extends StatefulWidget {
  const ManageTeamsPage({super.key});

  @override
  State<ManageTeamsPage> createState() => _ManageTeamsPageState();
}

class _ManageTeamsPageState extends State<ManageTeamsPage> {
  final supabase = Supabase.instance.client;

  bool isLoading = true;
  List teams = [];

  @override
  void initState() {
    super.initState();
    fetchMyTeams();
  }

  Future<void> fetchMyTeams() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final response = await supabase
        .from('teams')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    setState(() {
      teams = response;
      isLoading = false;
    });
  }

  Future<void> deleteTeam(String teamId) async {
    await supabase.from('teams').delete().eq('id', teamId);
    fetchMyTeams();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Team deleted successfully")),
    );
  }

  void confirmDelete(String teamId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text("Delete Team"),
        content: const Text("Are you sure you want to delete this team?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteTeam(teamId);
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Color(0xFFD32F2F)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F5),

      // ================= MODERN APP BAR =================
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85),
        child: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Manage My Teams",
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.6),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.settings),
            )
          ],
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFD32F2F), Color(0xFFFF5252)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(28),
              ),
            ),
          ),
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFD32F2F)))
          : teams.isEmpty
              ? const Center(
                  child: Text(
                    "You have not added any teams yet",
                    style: TextStyle(fontSize: 14),
                  ),
                )
              : Column(
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
                            _statTile(
                              icon: Icons.groups,
                              label: "My Teams",
                              value: teams.length.toString(),
                            ),
                            _statTile(
                              icon: Icons.edit,
                              label: "Editable",
                              value: "Yes",
                            ),
                            _statTile(
                              icon: Icons.verified,
                              label: "Status",
                              value: "Active",
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ================= GRID =================
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: GridView.builder(
                          itemCount: teams.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
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
                                children: [
                                  // IMAGE
                                  Container(
                                    height: 80,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          const BorderRadius.vertical(
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

                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              const Icon(Icons.person,
                                                  size: 12,
                                                  color: Color(0xFFFF5252)),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  team['manager_name'] ?? '',
                                                  style: const TextStyle(
                                                      fontSize: 11),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Divider(height: 6),
                                          _player("🎯 IGL", team['igl']),
                                          _player("🎮 P2", team['player2']),
                                          _player("🎮 P3", team['player3']),
                                          _player("🎮 P4", team['player4']),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // ACTIONS
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Color(0xFFD32F2F)),
                                        onPressed: () async {
                                          final result =
                                              await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  EditTeamPage(team: team),
                                            ),
                                          );
                                          if (result == true) fetchMyTeams();
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Color(0xFFFF5252)),
                                        onPressed: () => confirmDelete(
                                            team['id'].toString()),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _player(String label, String? name) {
    return Text(
      "$label: ${name ?? ''}",
      style: const TextStyle(fontSize: 11, color: Colors.black54),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _statTile(
      {required IconData icon,
      required String label,
      required String value}) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFD32F2F), size: 26),
        const SizedBox(height: 6),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label,
            style: const TextStyle(fontSize: 11, color: Colors.black54)),
      ],
    );
  }
}














