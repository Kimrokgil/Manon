import 'package:cloud_firestore/cloud_firestore.dart';

class Formation {
  String name;
  List<Map<String, dynamic>> positions;

  Formation({required this.name, required this.positions});

  factory Formation.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Formation(
      name: doc.id,
      positions: List<Map<String, dynamic>>.from(data['positions']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'positions': positions,
    };
  }
}

class FormationModel {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addFormation(Formation formation) async {
    await _db.collection('formations').doc(formation.name).set(formation.toMap());
  }

  Future<List<Formation>> getFormations() async {
    QuerySnapshot querySnapshot = await _db.collection('formations').get();
    return querySnapshot.docs.map((doc) => Formation.fromFirestore(doc)).toList();
  }
}
