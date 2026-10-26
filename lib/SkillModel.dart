class SkillModel {
  final String id;
  final String studentName;
  final String university;
  final String avatarInitials;
  final String avatarColor;
  final String skillTitle;
  final String description;
  final String category;
  final String type; // 'offering' or 'seeking'
  final int rating;
  final int sessions;

  const SkillModel({
    required this.id,
    required this.studentName,
    required this.university,
    required this.avatarInitials,
    required this.avatarColor,
    required this.skillTitle,
    required this.description,
    required this.category,
    required this.type,
    required this.rating,
    required this.sessions,
  });
}

// Sample data
final List<SkillModel> sampleSkills = [
  const SkillModel(
    id: '1',
    studentName: 'Aisha Rahman',
    university: 'UNIKL MIIT',
    avatarInitials: 'AR',
    avatarColor: '#7C3AED',
    skillTitle: 'Python Programming',
    description: 'I can help you with Python basics, data structures, and intro to data science. Great for beginners!',
    category: 'Programming',
    type: 'offering',
    rating: 5,
    sessions: 12,
  ),

  const SkillModel(
    id: '2',
    studentName: 'Hafiz Azman',
    university: 'UNIKL MIIT',
    avatarInitials: 'HA',
    avatarColor: '#D97706',
    skillTitle: 'Cybersecurity',
    description: 'Teaching principle of cybersecurity and important of cybersecurity awareness.',
    category: 'Cybersecurity',
    type: 'offering',
    rating: 4,
    sessions: 15,
  ),
  const SkillModel(
    id: '3',
    studentName: 'Mei Ling',
    university: 'UNIKL MIIT',
    avatarInitials: 'ML',
    avatarColor: '#0891B2',
    skillTitle: 'Networking',
    description: 'Teaching network protocol and principle in networking.',
    category: 'Network',
    type: 'seeking',
    rating: 3,
    sessions: 4,
  ),
  const SkillModel(
    id: '4',
    studentName: 'Danial Yusuf',
    university: 'UNIKL MIIT',
    avatarInitials: 'DY',
    avatarColor: '#BE185D',
    skillTitle: 'Graphic design',
    description: 'Show how to make graphic design with the right tools and to find creativity idea.',
    category: 'Multimedia',
    type: 'offering',
    rating: 5,
    sessions: 9,
  ),
];

const List<String> skillCategories = [
  'All',
  'Graphic design',
  'Java',
  'Cybersecurity',
  'Networking',
  'C++',
  'Python',
  'C#',
  'Programming',
  'Animation',
];