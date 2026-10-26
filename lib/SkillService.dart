import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SkillService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> postSkill({
    required String title,
    required String description,
    required String category,
    required String type,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await _db.collection('users').doc(user.uid).get();
    final userData = userDoc.data() ?? {};

    await _db.collection('skills').add({
      'userId': user.uid,
      'studentName': userData['fullName'] ?? 'Anonymous',
      'university': userData['university'] ?? '',
      'avatarInitials': userData['avatarInitials'] ?? 'ME',
      'avatarColor': '#4F46E5',
      'skillTitle': title,
      'description': description,
      'category': category,
      'type': type,
      'rating': 0,
      'sessions': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await _db.collection('users').doc(user.uid).update({
      'skillsPosted': FieldValue.increment(1),
    });
  }

  static Stream<List<Map<String, dynamic>>> getSkillsStream() {
    return _db
        .collection('skills')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList());
  }

  static Future<void> deleteSkill(String skillId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await _db.collection('skills').doc(skillId).delete();
    await _db.collection('users').doc(user.uid).update({
      'skillsPosted': FieldValue.increment(-1),
    });
  }

  static Future<void> sendConnectionRequest({
    required String toUserId,
    required String skillId,
    required String skillTitle,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _db.collection('connections').add({
      'fromUserId': user.uid,
      'toUserId': toUserId,
      'skillId': skillId,
      'skillTitle': skillTitle,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}