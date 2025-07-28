import 'package:flutter/material.dart';

class FishermenScreen extends StatelessWidget {
  const FishermenScreen({super.key});

  // Dummy data list of fishermen
  final List<Map<String, String>> fishermen = const [
    {"id": "1", "name": "John Doe", "phone": "0712345678"},
    {"id": "2", "name": "Mary Smith", "phone": "0798765432"},
    {"id": "3", "name": "Ali Mohamed", "phone": "0700111222"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fishermen"),
        backgroundColor: const Color(0xFF00ACC1),
      ),
      body: ListView.builder(
        itemCount: fishermen.length,
        itemBuilder: (context, index) {
          final fisher = fishermen[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(fisher['name']!),
              subtitle: Text("Phone: ${fisher['phone']}"),
              trailing: const Icon(Icons.edit, color: Color(0xFF00838F)),
              onTap: () {
                // Navigate to edit screen and pass fisherman data
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditFishermanScreen(
                      id: fisher['id']!,
                      name: fisher['name']!,
                      phone: fisher['phone']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class EditFishermanScreen extends StatefulWidget {
  final String id;
  final String name;
  final String phone;

  const EditFishermanScreen({
    super.key,
    required this.id,
    required this.name,
    required this.phone,
  });

  @override
  State<EditFishermanScreen> createState() => _EditFishermanScreenState();
}

class _EditFishermanScreenState extends State<EditFishermanScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();

    // Initialize text controllers with existing data
    _nameController = TextEditingController(text: widget.name);
    _phoneController = TextEditingController(text: widget.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();

    super.dispose();
  }

  void _saveChanges() {
    // Here you would normally update data in your database or API.
    // For now, just show a SnackBar and pop the screen.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Updated: ${_nameController.text}, Phone: ${_phoneController.text}'),
      ),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00838F),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
