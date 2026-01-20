

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditTeamPage extends StatefulWidget {
  final Map<String, dynamic> team;

  const EditTeamPage({super.key, required this.team});

  @override
  State<EditTeamPage> createState() => _EditTeamPageState();
}

class _EditTeamPageState extends State<EditTeamPage> {
  final supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  late TextEditingController logoController;
  late TextEditingController teamNameController;
  late TextEditingController managerController;
  late TextEditingController iglController;
  late TextEditingController player2Controller;
  late TextEditingController player3Controller;
  late TextEditingController player4Controller;
  late TextEditingController substituteController;

  final Color primaryRed = const Color(0xFFB71C1C);

  @override
  void initState() {
    super.initState();
    logoController = TextEditingController(text: widget.team['logo_url']);
    teamNameController = TextEditingController(text: widget.team['team_name']);
    managerController = TextEditingController(text: widget.team['manager_name']);
    iglController = TextEditingController(text: widget.team['igl']);
    player2Controller = TextEditingController(text: widget.team['player2']);
    player3Controller = TextEditingController(text: widget.team['player3']);
    player4Controller = TextEditingController(text: widget.team['player4']);
    substituteController =
        TextEditingController(text: widget.team['substitute']);
  }

  Future<void> updateTeam() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await supabase.from('teams').update({
        'logo_url': logoController.text.trim(),
        'team_name': teamNameController.text.trim(),
        'manager_name': managerController.text.trim(),
        'igl': iglController.text.trim(),
        'player2': player2Controller.text.trim(),
        'player3': player3Controller.text.trim(),
        'player4': player4Controller.text.trim(),
        'substitute': substituteController.text.trim(),
      }).eq('id', widget.team['id']);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Team updated successfully")),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() => isLoading = false);
  }

  InputDecoration inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: primaryRed),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(width: 4, height: 20, color: primaryRed),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionCard(List<Widget> children) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: children),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Edit Team"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFB71C1C), Color(0xFF7F0000)],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: primaryRed.withOpacity(0.1),
                    backgroundImage: NetworkImage(logoController.text),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.team['team_name'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              sectionTitle("Team Information"),
              sectionCard([
                TextFormField(
                  controller: logoController,
                  decoration:
                      inputDecoration("Team Logo URL", Icons.image),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: teamNameController,
                  decoration:
                      inputDecoration("Team Name", Icons.flag),
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
              ]),

              /// 👔 Management
              sectionTitle("Management"),
              sectionCard([
                TextFormField(
                  controller: managerController,
                  decoration:
                      inputDecoration("Manager Name", Icons.person),
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: iglController,
                  decoration:
                      inputDecoration("IGL (In-Game Leader)", Icons.shield),
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
              ]),

              sectionTitle("Players"),
              sectionCard([
                TextFormField(
                  controller: player2Controller,
                  decoration:
                      inputDecoration("Player 2 IGN", Icons.sports_esports),
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: player3Controller,
                  decoration:
                      inputDecoration("Player 3 IGN", Icons.sports_esports),
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: player4Controller,
                  decoration:
                      inputDecoration("Player 4 IGN", Icons.sports_esports),
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: substituteController,
                  decoration:
                      inputDecoration("Substitute Player", Icons.person_add),
                ),
              ]),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: isLoading ? null : updateTeam,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Update Team",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
