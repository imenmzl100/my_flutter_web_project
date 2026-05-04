import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_application_06/widgets/custom_text_field.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _myBox = Hive.box('productsBox');

  void _addData() {
    if (_nameController.text.isNotEmpty) {
      _myBox.add({
        'name': _nameController.text,
        'desc': _descController.text,
        'time': DateTime.now().toString(),
      });

      _nameController.clear();
      _descController.clear();
    }
  }

  void _boxDelete(int index) {
    _myBox.deleteAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: _buildMainContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 350,
      color: Colors.indigo.shade900,
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          const Icon(
            Icons.auto_awesome,
            color: Colors.amber,
            size: 50,
          ),
          const SizedBox(height: 30),

          CustomTextField(
            controller: _nameController,
            hint: "Product Name",
            icon: Icons.edit,
          ),

          const SizedBox(height: 20),

          CustomTextField(
            controller: _descController,
            hint: "Description",
            icon: Icons.description,
            maxLines: 3,
          ),

          const SizedBox(height: 30),

          ElevatedButton(
            onPressed: _addData,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text(
              "Save Data",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return ValueListenableBuilder(
      valueListenable: _myBox.listenable(),
      builder: (context, Box box, _) {
        return ListView.builder(
          padding: const EdgeInsets.all(40),
          itemCount: box.length,
          itemBuilder: (context, index) {
            final item = box.getAt(index);

            return Card(
              child: ListTile(
                title: Text(item['name'] ?? ''),
                subtitle: Text(item['desc'] ?? ''),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () => _boxDelete(index),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
