import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addFormations() async {
    WriteBatch batch = _db.batch();

    Map<String, List<Map<String, dynamic>>> formations = {
      '4-4-2': [
        { 'name': 'Goalkeeper', 'top': 556, 'left': 160 },
        { 'name': 'Left Back', 'top': 456, 'left': 20 },
        { 'name': 'Right Back', 'top': 456, 'left': 300 },
        { 'name': 'Left Center Back', 'top': 456, 'left': 80 },
        { 'name': 'Right Center Back', 'top': 456, 'left': 240 },
        { 'name': 'Left Midfielder', 'top': 356, 'left': 20 },
        { 'name': 'Right Midfielder', 'top': 356, 'left': 300 },
        { 'name': 'Left Center Midfielder', 'top': 356, 'left': 80 },
        { 'name': 'Right Center Midfielder', 'top': 356, 'left': 240 },
        { 'name': 'Left Forward', 'top': 256, 'left': 100 },
        { 'name': 'Right Forward', 'top': 256, 'left': 200 },
      ],
      '4-3-3': [
        { 'name': 'Goalkeeper', 'top': 556, 'left': 160 },
        { 'name': 'Left Back', 'top': 456, 'left': 20 },
        { 'name': 'Right Back', 'top': 456, 'left': 300 },
        { 'name': 'Left Center Back', 'top': 456, 'left': 80 },
        { 'name': 'Right Center Back', 'top': 456, 'left': 240 },
        { 'name': 'Center Defensive Midfielder', 'top': 356, 'left': 160 },
        { 'name': 'Left Center Midfielder', 'top': 356, 'left': 80 },
        { 'name': 'Right Center Midfielder', 'top': 356, 'left': 240 },
        { 'name': 'Left Winger', 'top': 256, 'left': 50 },
        { 'name': 'Center Forward', 'top': 256, 'left': 160 },
        { 'name': 'Right Winger', 'top': 256, 'left': 270 },
      ],
      '3-5-2': [
        { 'name': 'Goalkeeper', 'top': 556, 'left': 160 },
        { 'name': 'Left Center Back', 'top': 456, 'left': 80 },
        { 'name': 'Center Back', 'top': 456, 'left': 160 },
        { 'name': 'Right Center Back', 'top': 456, 'left': 240 },
        { 'name': 'Left Midfielder', 'top': 356, 'left': 20 },
        { 'name': 'Right Midfielder', 'top': 356, 'left': 300 },
        { 'name': 'Left Center Midfielder', 'top': 356, 'left': 80 },
        { 'name': 'Center Midfielder', 'top': 356, 'left': 160 },
        { 'name': 'Right Center Midfielder', 'top': 356, 'left': 240 },
        { 'name': 'Left Forward', 'top': 256, 'left': 100 },
        { 'name': 'Right Forward', 'top': 256, 'left': 200 },
      ],
      '4-5-1': [
        { 'name': 'Goalkeeper', 'top': 556, 'left': 160 },
        { 'name': 'Left Back', 'top': 456, 'left': 20 },
        { 'name': 'Right Back', 'top': 456, 'left': 300 },
        { 'name': 'Left Center Back', 'top': 456, 'left': 80 },
        { 'name': 'Right Center Back', 'top': 456, 'left': 240 },
        { 'name': 'Left Midfielder', 'top': 356, 'left': 20 },
        { 'name': 'Right Midfielder', 'top': 356, 'left': 300 },
        { 'name': 'Center Midfielder', 'top': 356, 'left': 160 },
        { 'name': 'Left Center Midfielder', 'top': 356, 'left': 80 },
        { 'name': 'Right Center Midfielder', 'top': 356, 'left': 240 },
        { 'name': 'Center Forward', 'top': 256, 'left': 160 },
      ],
      '3-4-3': [
        { 'name': 'Goalkeeper', 'top': 556, 'left': 160 },
        { 'name': 'Left Center Back', 'top': 456, 'left': 80 },
        { 'name': 'Center Back', 'top': 456, 'left': 160 },
        { 'name': 'Right Center Back', 'top': 456, 'left': 240 },
        { 'name': 'Left Midfielder', 'top': 356, 'left': 20 },
        { 'name': 'Right Midfielder', 'top': 356, 'left': 300 },
        { 'name': 'Left Center Midfielder', 'top': 356, 'left': 80 },
        { 'name': 'Right Center Midfielder', 'top': 356, 'left': 240 },
        { 'name': 'Left Forward', 'top': 256, 'left': 50 },
        { 'name': 'Center Forward', 'top': 256, 'left': 160 },
        { 'name': 'Right Forward', 'top': 256, 'left': 270 },
      ],
      '4-2-3-1': [
        { 'name': 'Goalkeeper', 'top': 556, 'left': 160 },
        { 'name': 'Left Back', 'top': 456, 'left': 20 },
        { 'name': 'Right Back', 'top': 456, 'left': 300 },
        { 'name': 'Left Center Back', 'top': 456, 'left': 80 },
        { 'name': 'Right Center Back', 'top': 456, 'left': 240 },
        { 'name': 'Left Defensive Midfielder', 'top': 356, 'left': 100 },
        { 'name': 'Right Defensive Midfielder', 'top': 356, 'left': 220 },
        { 'name': 'Left Attacking Midfielder', 'top': 256, 'left': 80 },
        { 'name': 'Center Attacking Midfielder', 'top': 256, 'left': 160 },
        { 'name': 'Right Attacking Midfielder', 'top': 256, 'left': 240 },
        { 'name': 'Center Forward', 'top': 156, 'left': 160 },
      ],
      '5-3-2': [
        { 'name': 'Goalkeeper', 'top': 556, 'left': 160 },
        { 'name': 'Left Back', 'top': 456, 'left': 20 },
        { 'name': 'Right Back', 'top': 456, 'left': 300 },
        { 'name': 'Left Center Back', 'top': 456, 'left': 80 },
        { 'name': 'Center Back', 'top': 456, 'left': 160 },
        { 'name': 'Right Center Back', 'top': 456, 'left': 240 },
        { 'name': 'Left Midfielder', 'top': 356, 'left': 80 },
        { 'name': 'Center Midfielder', 'top': 356, 'left': 160 },
        { 'name': 'Right Midfielder', 'top': 356, 'left': 240 },
        { 'name': 'Left Forward', 'top': 256, 'left': 100 },
        { 'name': 'Right Forward', 'top': 256, 'left': 200 },
      ],
      '5-4-1': [
        { 'name': 'Goalkeeper', 'top': 556, 'left': 160 },
        { 'name': 'Left Back', 'top': 456, 'left': 20 },
        { 'name': 'Right Back', 'top': 456, 'left': 300 },
        { 'name': 'Left Center Back', 'top': 456, 'left': 80 },
        { 'name': 'Center Back', 'top': 456, 'left': 160 },
        { 'name': 'Right Center Back', 'top': 456, 'left': 240 },
        { 'name': 'Left Midfielder', 'top': 356, 'left': 20 },
        { 'name': 'Right Midfielder', 'top': 356, 'left': 300 },
        { 'name': 'Left Center Midfielder', 'top': 356, 'left': 80 },
        { 'name': 'Right Center Midfielder', 'top': 356, 'left': 240 },
        { 'name': 'Center Forward', 'top': 256, 'left': 160 },
      ],
      '3-6-1': [
        { 'name': 'Goalkeeper', 'top': 556, 'left': 160 },
        { 'name': 'Left Center Back', 'top': 456, 'left': 80 },
        { 'name': 'Center Back', 'top': 456, 'left': 160 },
        { 'name': 'Right Center Back', 'top': 456, 'left': 240 },
        { 'name': 'Left Midfielder', 'top': 356, 'left': 20 },
        { 'name': 'Right Midfielder', 'top': 356, 'left': 300 },
        { 'name': 'Left Center Midfielder', 'top': 356, 'left': 80 },
        { 'name': 'Right Center Midfielder', 'top': 356, 'left': 240 },
        { 'name': 'Center Midfielder', 'top': 356, 'left': 160 },
        { 'name': 'Attacking Midfielder', 'top': 256, 'left': 160 },
        { 'name': 'Center Forward', 'top': 156, 'left': 160 },
      ],
      '4-1-4-1': [
        { 'name': 'Goalkeeper', 'top': 556, 'left': 160 },
        { 'name': 'Left Back', 'top': 456, 'left': 20 },
        { 'name': 'Right Back', 'top': 456, 'left': 300 },
        { 'name': 'Left Center Back', 'top': 456, 'left': 80 },
        { 'name': 'Right Center Back', 'top': 456, 'left': 240 },
        { 'name': 'Defensive Midfielder', 'top': 356, 'left': 160 },
        { 'name': 'Left Midfielder', 'top': 256, 'left': 20 },
        { 'name': 'Right Midfielder', 'top': 256, 'left': 300 },
        { 'name': 'Left Center Midfielder', 'top': 256, 'left': 80 },
        { 'name': 'Right Center Midfielder', 'top': 256, 'left': 240 },
        { 'name': 'Center Forward', 'top': 156, 'left': 160 },
      ],
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
}
