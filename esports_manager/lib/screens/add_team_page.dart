

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddTeamPage extends StatefulWidget {
  const AddTeamPage({super.key});

  @override
  State<AddTeamPage> createState() => _AddTeamPageState();
}

class _AddTeamPageState extends State<AddTeamPage> {
  final supabase = Supabase.instance.client;

  final _formKey = GlobalKey<FormState>();

  final logoController = TextEditingController();
  final teamNameController = TextEditingController();
  final managerController = TextEditingController();
  final iglController = TextEditingController();
  final player2Controller = TextEditingController();
  final player3Controller = TextEditingController();
  final player4Controller = TextEditingController();
  final substituteController = TextEditingController();

  bool isLoading = false;

  Future<void> submitTeam() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await supabase.from('teams').insert({
        'logo_url': logoController.text.trim(),
        'team_name': teamNameController.text.trim(),
        'manager_name': managerController.text.trim(),
        'igl': iglController.text.trim(),
        'player2': player2Controller.text.trim(),
        'player3': player3Controller.text.trim(),
        'player4': player4Controller.text.trim(),
        'substitute': substituteController.text.trim(),
        'user_id': supabase.auth.currentUser!.id,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Team added successfully")),
      );

      _formKey.currentState!.reset();
      logoController.clear();
      teamNameController.clear();
      managerController.clear();
      iglController.clear();
      player2Controller.clear();
      player3Controller.clear();
      player4Controller.clear();
      substituteController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() => isLoading = false);
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF212121)),
      prefixIcon: Icon(icon, color: const Color(0xFFD32F2F)),
      filled: true,
      fillColor: const Color(0xFFFFFFFF),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text("Add Team"),
        backgroundColor: const Color(0xFFD32F2F),
        elevation: 4,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: logoController,
                    decoration: _inputDecoration("Team Logo URL", Icons.image),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: teamNameController,
                    decoration: _inputDecoration("Team Name", Icons.groups),
                    validator: (value) =>
                        value!.isEmpty ? "Team name required" : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: managerController,
                    decoration: _inputDecoration("Manager Name", Icons.person),
                    validator: (value) =>
                        value!.isEmpty ? "Manager name required" : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: iglController,
                    decoration: _inputDecoration(
                        "IGL (In-Game Leader)", Icons.emoji_events),
                    validator: (value) =>
                        value!.isEmpty ? "IGL name required" : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: player2Controller,
                    decoration: _inputDecoration(
                        "Player 2 IGN", Icons.sports_esports),
                    validator: (value) =>
                        value!.isEmpty ? "Player 2 IGN required" : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: player3Controller,
                    decoration: _inputDecoration(
                        "Player 3 IGN", Icons.sports_esports),
                    validator: (value) =>
                        value!.isEmpty ? "Player 3 IGN required" : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: player4Controller,
                    decoration: _inputDecoration(
                        "Player 4 IGN", Icons.sports_esports),
                    validator: (value) =>
                        value!.isEmpty ? "Player 4 IGN required" : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: substituteController,
                    decoration: _inputDecoration(
                        "Substitute Player IGN", Icons.person_outline),
                  ),
                  const SizedBox(height: 24),

                  GestureDetector(
                    onTapDown: (_) => setState(() => isLoading = true),
                    onTapUp: (_) => setState(() => isLoading = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.easeInOut,
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD32F2F),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFCDD2).withOpacity(0.5),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextButton(
                        onPressed: submitTeam,
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Submit Team",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
