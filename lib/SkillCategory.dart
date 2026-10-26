import 'package:flutter/material.dart';
import 'package:fyp1/AppTheme.dart';
import 'package:fyp1/SkillService.dart';

class SkillCategory {
  final String name;
  final IconData icon;
  final Color color;

  const SkillCategory({
    required this.name,
    required this.icon,
    required this.color,
  });
}

const List<SkillCategory> skillCategories = [
  SkillCategory(name: 'Graphic Design', icon: Icons.brush, color: Colors.pink),
  SkillCategory(name: 'Java', icon: Icons.code, color: Colors.orange),
  SkillCategory(name: 'Cybersecurity', icon: Icons.security, color: Colors.red),
  SkillCategory(name: 'Networking', icon: Icons.wifi, color: Colors.blue),
  SkillCategory(name: 'C++', icon: Icons.memory, color: Colors.indigo),
  SkillCategory(name: 'Python', icon: Icons.code, color: Colors.green),
  SkillCategory(name: 'C#', icon: Icons.developer_mode, color: Colors.purple),
  SkillCategory(name: 'Animation', icon: Icons.movie, color: Colors.teal),
  SkillCategory(name: 'Programming', icon: Icons.terminal, color: Colors.blueGrey),
];

class PostSkillScreen extends StatefulWidget {
  const PostSkillScreen({super.key});

  @override
  State<PostSkillScreen> createState() => _PostSkillScreenState();
}

class _PostSkillScreenState extends State<PostSkillScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  late SkillCategory _selectedCategory;
  String _selectedType = 'offering';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedCategory = skillCategories.first;
  }

  void _submit() async {
    if (_titleController.text.isEmpty || _descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    await SkillService.postSkill(
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      category: _selectedCategory.name,
      type: _selectedType,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Posted: ${_titleController.text} (${_selectedCategory.name})'),
        backgroundColor: AppTheme.accentColor,
      ),
    );

    _titleController.clear();
    _descController.clear();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post a Skill')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('I am...', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                _TypeToggle(
                  label: 'Offering',
                  value: 'offering',
                  selected: _selectedType,
                  onTap: () => setState(() => _selectedType = 'offering'),
                ),
                const SizedBox(width: 10),
                _TypeToggle(
                  label: 'Seeking',
                  value: 'seeking',
                  selected: _selectedType,
                  onTap: () => setState(() => _selectedType = 'seeking'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text('Skill Title',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            TextField(controller: _titleController),

            const SizedBox(height: 20),

            const Text('Category',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<SkillCategory>(
                  value: _selectedCategory,
                  isExpanded: true,
                  items: skillCategories.map((c) {
                    return DropdownMenuItem(
                      value: c,
                      child: Row(
                        children: [
                          Icon(c.icon, color: c.color, size: 18),
                          const SizedBox(width: 10),
                          Text(c.name),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedCategory = value!);
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text('Description',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            TextField(
              controller: _descController,
              maxLines: 3,
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Post Skill'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeToggle extends StatelessWidget {
  final String label;
  final String value;
  final String selected;
  final VoidCallback onTap;

  const _TypeToggle({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selected;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}