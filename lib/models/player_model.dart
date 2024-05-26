import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  String id;
  String name;
  Map<String, double> skills;

  Player({required this.id, required this.name, required this.skills});

  factory Player.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Player(
      id: doc.id,
      name: data['name'] ?? '',
      skills: Map<String, double>.from(data['skills'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'skills': skills,
    };
  }
}

class PlayerModel {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addPlayer(Player player) async {
    await _db.collection('players').doc(player.id).set(player.toMap());
  }

  Future<List<Player>> getPlayers() async {
    QuerySnapshot querySnapshot = await _db.collection('players').get();
    return querySnapshot.docs.map((doc) => Player.fromFirestore(doc)).toList();
  }
}
