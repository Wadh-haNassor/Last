import 'package:flutter/material.dart';

class EditFishermanScreen extends StatefulWidget {
  final String name;
  final String id;
  final String contact;

  const EditFishermanScreen({
    super.key,
    required this.name,
    required this.id,
    required this.contact,
  });

  @override
  State<EditFishermanScreen> createState() => _EditFishermanScreenState();
}

class _EditFishermanScreenState extends State<EditFishermanScreen> {
  late TextEditingController _nameController;
  late TextEditingController _idController;
  late TextEditingController _contactController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _idController = TextEditingController(text: widget.id);
    _contactController = TextEditingController(text: widget.contact);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    // Save changes logic goes here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Fisherman info updated")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Fisherman"),
        backgroundColor: const Color(0xFF00ACC1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _idController,
              decoration: const InputDecoration(labelText: "Fisherman ID"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _contactController,
              decoration: const InputDecoration(labelText: "Contact Number"),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _saveChanges,
              icon: const Icon(Icons.save),
              label: const Text("Save Changes"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00ACC1),
              ),
            )
          ],
        ),
      ),
    );
  }
}
