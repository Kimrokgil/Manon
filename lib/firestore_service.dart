import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addFormations() async {
    WriteBatch batch = _db.batch();

    Map<String, List<Map<String, dynamic>>> formations = {
      // 포메이션 데이터...
    };

    formations.forEach((formation, positions) {
      DocumentReference docRef = _db.collection('formations').doc(formation);
      batch.set(docRef, { 'positions': positions });
    });

    await batch.commit();
  }

  Future<Map<String, List<Map<String, dynamic>>>> getFormations() async {
    Map<String, List<Map<String, dynamic>>> formations = {};
    QuerySnapshot querySnapshot = await _db.collection('formations').get();
    for (var doc in querySnapshot.docs) {
      formations[doc.id] = List<Map<String, dynamic>>.from(doc['positions']);
    }
    return formations;
  }

  Future<void> savePlayerSkills(String playerId, List<double> attackingSkills, List<double> defendingSkills) async {
    await _db.collection('players').doc(playerId).set({
      'attackingSkills': attackingSkills,
      'defendingSkills': defendingSkills,
    });
  }
}
