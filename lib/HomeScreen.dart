import 'package:flutter/material.dart';
import 'package:fyp1/SkillModel.dart';
import 'package:fyp1/AppTheme.dart';
import 'package:fyp1/SkillCard.dart';
import 'package:fyp1/CategoryChip.dart';
import 'package:fyp1/SkillService.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'A Peer-to-Peer Collaborative Learning & Mentorship',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
            ),

            Text(
              'Learn from peers, grow together',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        toolbarHeight: 72,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: AppTheme.primaryColor,
              child: const Text(
                'ME',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search skills or students...',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () => setState(() => _searchQuery = ''),
                )
                    : null,
              ),
            ),
          ),

          // Category Filter
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: skillCategories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = skillCategories[index];
                return CategoryChip(
                  label: category,
                  isSelected: _selectedCategory == category,
                  onTap: () => setState(() => _selectedCategory = category),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Skills List
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: SkillService.getSkillsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final allSkills = snapshot.data ?? [];

                final filtered = allSkills.where((s) {
                  final matchesCategory = _selectedCategory == 'All' ||
                      s['category'] == _selectedCategory;
                  final matchesSearch =
                      (s['skillTitle'] as String? ?? '')
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()) ||
                          (s['studentName'] as String? ?? '')
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase());
                  return matchesCategory && matchesSearch;
                }).toList();

                // Skills count row
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Text(
                            '${filtered.length} skills found',
                            style: const TextStyle(
                              color: AppTheme.textLight,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              _LegendDot(
                                  color: AppTheme.accentColor,
                                  label: 'Offering'),
                              const SizedBox(width: 12),
                              _LegendDot(
                                  color: Colors.orange.shade400,
                                  label: 'Seeking'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: filtered.isEmpty
                          ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off,
                                size: 64,
                                color: Colors.grey.shade300),
                            const SizedBox(height: 12),
                            Text(
                              'No skills found',
                              style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      )
                          : ListView.separated(
                        padding:
                        const EdgeInsets.fromLTRB(16, 4, 16, 80),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) =>
                        const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final data = filtered[index];
                          final skill = SkillModel(
                            id: data['id'] ?? '',
                            studentName: data['studentName'] ?? '',
                            university: data['university'] ?? '',
                            avatarInitials:
                            data['avatarInitials'] ?? 'ME',
                            avatarColor:
                            data['avatarColor'] ?? '#4F46E5',
                            skillTitle: data['skillTitle'] ?? '',
                            description: data['description'] ?? '',
                            category: data['category'] ?? '',
                            type: data['type'] ?? 'offering',
                            rating: (data['rating'] ?? 0) as int,
                            sessions: (data['sessions'] ?? 0) as int,
                          );
                          return SkillCard(skill: skill);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label,
            style:
            const TextStyle(fontSize: 11, color: AppTheme.textLight)),
      ],
    );
  }
}