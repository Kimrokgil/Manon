import 'package:cloud_firestore/cloud_firestore.dart';


class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addFormations() async {
    var formations = {
      '4-4-2': [
        {'name': 'GK', 'left': 160, 'top': 20},
        {'name': 'LB', 'left': 20, 'top': 120},
        {'name': 'CB', 'left': 80, 'top': 120},
        {'name': 'CB', 'left': 240, 'top': 120},
        {'name': 'RB', 'left': 300, 'top': 120},
        {'name': 'LM', 'left': 20, 'top': 220},
        {'name': 'CM', 'left': 80, 'top': 220},
        {'name': 'CM', 'left': 240, 'top': 220},
        {'name': 'RM', 'left': 300, 'top': 220},
        {'name': 'ST', 'left': 100, 'top': 320},
        {'name': 'ST', 'left': 200, 'top': 320},
      ],
      '4-3-3': [
        {'name': 'GK', 'left': 160, 'top': 20},
        {'name': 'LB', 'left': 20, 'top': 120},
        {'name': 'CB', 'left': 80, 'top': 120},
        {'name': 'CB', 'left': 240, 'top': 120},
        {'name': 'RB', 'left': 300, 'top': 120},
        {'name': 'CDM', 'left': 160, 'top': 220},
        {'name': 'CM', 'left': 80, 'top': 220},
        {'name': 'CM', 'left': 240, 'top': 220},
        {'name': 'LW', 'left': 50, 'top': 320},
        {'name': 'CF', 'left': 160, 'top': 320},
        {'name': 'RW', 'left': 270, 'top': 320},
      ],
      '3-5-2': [
        {'name': 'GK', 'left': 160, 'top': 20},
        {'name': 'CB', 'left': 20, 'top': 120},
        {'name': 'CB', 'left': 160, 'top': 120},
        {'name': 'CB', 'left': 300, 'top': 120},
        {'name': 'LM', 'left': 20, 'top': 220},
        {'name': 'CM', 'left': 80, 'top': 220},
        {'name': 'CM', 'left': 160, 'top': 220},
        {'name': 'CM', 'left': 240, 'top': 220},
        {'name': 'RM', 'left': 300, 'top': 220},
        {'name': 'ST', 'left': 100, 'top': 320},
        {'name': 'ST', 'left': 200, 'top': 320},
      ],
    };

    formations.forEach((formation, players) async {
      await _db.collection('formations').doc(formation).set({'players': players});
    });
  }

  Future<Map<String, List<Map<String, dynamic>>>> getFormations() async {
    var snapshot = await _db.collection('formations').get();
    var formations = <String, List<Map<String, dynamic>>>{};

    for (var doc in snapshot.docs) {
      if (doc.exists && doc.data().containsKey('players')) {
        formations[doc.id] = List<Map<String, dynamic>>.from(doc['players']);
      }
    }

    return formations;
  }

  Future<void> updatePlayerData(String playerId, Map<String, dynamic> playerData) async {
    await _db.collection('players').doc(playerId).set(playerData, SetOptions(merge: true));
  }

  Future<List<DocumentSnapshot>> getPlayers(String teamId) async {
    QuerySnapshot snapshot = await _db.collection('teams').doc(teamId).collection('players').get();
    return snapshot.docs;
  }

  Future<void> updateFormation(String teamId, String formation, List<Map<String, dynamic>> positions) async {
    await _db.collection('teams').doc(teamId).update({
      'formation': formation,
      'positions': positions,
    });
  }
}
